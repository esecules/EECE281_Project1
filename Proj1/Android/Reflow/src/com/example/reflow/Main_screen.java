/**
 * Manages the main screen of the app
 * @author Eric Secules
 *
 * Thanks to jjoe64 for Graph View
 * http://android-graphview.org/
 */

package com.example.reflow;

import java.sql.Ref;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.Messenger;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.ToggleButton;
import at.abraxas.amarino.Amarino;
import at.abraxas.amarino.AmarinoIntent;

public class Main_screen extends Activity {
	// Declare class variables
	EditText txtsoakTemp, txtsoakTime, txtmaxTemp, txtreflowTime,
			txtreflowTemp;
	TextView currentState;
	Integer soakTemp, soakTime, maxTemp, reflowTemp, reflowTime;
	ToggleButton toggle;
	Button toGraph;
	public ProgressBar mProgress;
	boolean caughtFormatException = false;
	Builder outOfRangeAlert;
	Builder emptyFieldAlert;
	String errors;
	ReflowOvenService oven;
	static int datax;

	private ArduinoReceiver arduinoReceiver = new ArduinoReceiver();

	private static final String DEVICE_ADDRESS = "00:06:66:66:33:1B";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// set up fields and buttons as variables
		final String TAG = this.getLocalClassName();
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main_screen);
		currentState = (TextView) findViewById(R.id.currentState);
		mProgress = (ProgressBar) findViewById(R.id.progressBar1);
		toggle = (ToggleButton) findViewById(R.id.toggleButton1);
		toGraph = (Button) findViewById(R.id.refresh);
		txtsoakTemp = (EditText) findViewById(R.id.editSTemp);
		txtsoakTime = (EditText) findViewById(R.id.editSTime);
		txtmaxTemp = (EditText) findViewById(R.id.editMTemp);
		txtreflowTime = (EditText) findViewById(R.id.reflowTime);
		txtreflowTemp = (EditText) findViewById(R.id.reflowTemp);
		emptyFieldAlert = new AlertDialog.Builder(this)
				.setTitle("Invalid Input")
				.setMessage(
						"Input cannot be parsed into a 32 bit integer, try again")
				.setNeutralButton("Close", null);

		currentState.setText(ReflowOven.getStateStr());
		/*
		 * Change to the graph view on button press
		 */
		toGraph.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent intentMain = new Intent(Main_screen.this,
						Graph_activity.class);
				Main_screen.this.startActivity(intentMain);
				Log.i("Content ", " Main layout ");
			}
		});

		/*
		 * On button click either start or stop the machine based on current
		 * state On start send the data in the fields to the machine if valid
		 * and the start signal On stop send the stop signal
		 */
		toggle.setOnCheckedChangeListener(new OnCheckedChangeListener() {
			Handler handler = new Handler() {
				@Override
				public void handleMessage(Message msg) {
					Bundle reply = msg.getData();
					mProgress.setProgress((int) reply.getDouble("progress"));
					currentState.setText(reply.getString("state"));
				}
			};

			@Override
			public void onCheckedChanged(CompoundButton buttonView,
					boolean isChecked) {
				if (isChecked) {
					try {
						soakTemp = Integer.valueOf(txtsoakTemp.getText()
								.toString());
						soakTime = Integer.valueOf(txtsoakTime.getText()
								.toString());
						maxTemp = Integer.valueOf(txtmaxTemp.getText()
								.toString());
						reflowTime = Integer.valueOf(txtreflowTime.getText()
								.toString());
						reflowTemp = Integer.valueOf(txtreflowTemp.getText()
								.toString());
					} catch (NumberFormatException e) {
						caughtFormatException = true;
						toggle.setChecked(false);
						ReflowOven.setRunning(false);
						emptyFieldAlert.show();
					}
					if (!caughtFormatException) {
						if (validateInput()) {
							// Were good to start!
							Log.d(TAG, "Starting");
							ReflowOven.setStateStr("Started");
							ReflowOven.setRunning(true);
							Bluetooth startBT = new Bluetooth();
							startBT.execute(true);
							DataSender sendStart = new DataSender();
							sendStart.execute(soakTemp, soakTime, reflowTemp,
									reflowTemp, maxTemp, Constants.START_TAG);

							Intent getDataIntent = new Intent(
									Constants.GET_DATA);
							getDataIntent.setClass(getBaseContext(),
									ReflowOvenService.class);
							getDataIntent.putExtra("messenger", new Messenger(
									handler));
							Log.d(TAG, "Starting " + getDataIntent.getAction());
							startService(getDataIntent);

						} else
							toggle.setChecked(false);
					} else
						caughtFormatException = false;
				} else if (ReflowOven.isRunning()) {
					// Stop Button Pressed
					Log.d(TAG, "Trying to stop service");
					DataSender sendStop = new DataSender();
					sendStop.execute(Constants.STOP_TAG);
					ReflowOvenService.stopMe();
					currentState.setText("Stopped");
					mProgress.setProgress(0);
					ReflowOven.reset();
					Bluetooth startBT = new Bluetooth();
					startBT.execute(false);
				}
			}
		});

	}

	/*
	 * Validate the input and show appropriate error messages if input is out of
	 * bounds
	 */
	private boolean validateInput() {
		String eSoakTemp, eSoakTime, eMaxTemp, eReflowTemp, eReflowTime;
		boolean wasError = false;
		if (soakTemp > 215) {
			eSoakTemp = "-Soak temp too high (>215)\n";
			wasError = true;
		} else if (soakTemp <= 100) {
			eSoakTemp = "-Soak temp too low (<100)\n";
			wasError = true;
		} else if (soakTemp > maxTemp) {
			eSoakTemp = "-Soak temp greater than max temp\n";
			wasError = true;
		} else
			eSoakTemp = "";

		if (soakTime > 180) {
			eSoakTime = "-Soak time too long (>180)\n";
			wasError = true;
		} else if (soakTime < 60) {
			eSoakTime = "-Soak time too short (<60)\n";
			wasError = true;
		} else
			eSoakTime = "";

		if (reflowTemp > 225) {
			eReflowTemp = "-Reflow temp too high (>225)\n";
			wasError = true;
		} else if (reflowTemp < 200) {
			eReflowTemp = "-Reflow temp too low (<200)\n";
			wasError = true;
		} else
			eReflowTemp = "";

		if (reflowTime > 90) {
			eReflowTime = "-Reflow time too high (>90)\n";
			wasError = true;
		} else if (reflowTemp < 40) {
			eReflowTime = "-Reflow time too low (<40)\n";
			wasError = true;
		} else
			eReflowTime = "";

		if (maxTemp > 255) {
			eMaxTemp = "-Max temp too high (>255)\n";
			wasError = true;
		} else if (maxTemp < 217) {
			eMaxTemp = "-Max temp too low (<217)\n";
			wasError = true;
		} else
			eMaxTemp = "";

		if (wasError) {
			errors = eSoakTemp + eSoakTime + eReflowTemp + eReflowTime
					+ eMaxTemp;
			new AlertDialog.Builder(this).setTitle("Invalid Input")
					.setMessage(errors).setNeutralButton("Close", null).show();
			return false;
		} else
			return true;

	}

	private class Bluetooth extends AsyncTask<Boolean, Integer, Boolean> {

		@Override
		protected Boolean doInBackground(Boolean... params) {

			if (params.length == 1) {
				for (Boolean b : params) {
					if (b) {
						// in order to receive broadcasted intents we need to
						// register our receiver
						registerReceiver(arduinoReceiver, new IntentFilter(
								AmarinoIntent.ACTION_RECEIVED));
						// this is how you tell Amarino to connect to a specific
						// BT device from within your own code
						Amarino.connect(getBaseContext(), DEVICE_ADDRESS);
						return true;
					} else {
						// if you connect in onStart() you must not forget to
						// disconnect when your app is closed
						Amarino.disconnect(getBaseContext(), DEVICE_ADDRESS);

						// do never forget to unregister a registered receiver
						unregisterReceiver(arduinoReceiver);
						return true;
					}
				}
			} else {
				return false;
			}
			return false;
		}
	}

	private class DataSender extends AsyncTask<Integer, Integer, String> {
		final String TAG = this.getClass().getSimpleName();

		@Override
		protected void onPostExecute(String result) {
			super.onPostExecute(result);
		}

		@Override
		protected void onProgressUpdate(Integer... values) {
			super.onProgressUpdate(values);
		}

		@Override
		protected String doInBackground(Integer... params) {
			if (params.length == Constants.SEND_PARAMS) {
				Amarino.sendDataToArduino(getBaseContext(), DEVICE_ADDRESS, 'a', params[0]); // soak temp
				Amarino.sendDataToArduino(getBaseContext(), DEVICE_ADDRESS, 'b', params[1]); // soak time
				Amarino.sendDataToArduino(getBaseContext(), DEVICE_ADDRESS, 'c', params[2]); // reflow temp
				Amarino.sendDataToArduino(getBaseContext(), DEVICE_ADDRESS, 'd', params[3]); // reflow time
				Amarino.sendDataToArduino(getBaseContext(), DEVICE_ADDRESS, 'e', params[4]); // max temp
				Amarino.sendDataToArduino(getBaseContext(), DEVICE_ADDRESS, 'f', params[5]); // start
			}
			if (params.length == Constants.STOP_PARAMS) {
				Log.d(TAG, "stop code " + params[0].toString());
				// TODO Put BT sending code here
				Amarino.sendDataToArduino(getBaseContext(), DEVICE_ADDRESS,
						'z', params[0]); // stop
			}
			return null;
		}

	}

	public class ArduinoReceiver extends BroadcastReceiver {

		@Override
		public void onReceive(Context context, Intent intent) {
			String data = null;

			// the type of data which is added to the intent
			final int dataType = intent.getIntExtra(
					AmarinoIntent.EXTRA_DATA_TYPE, -1);

			// we only expect String data though, but it is better to check if
			// really string was sent.
			// you have to parse the data to the type you have sent from
			// Arduino.
			if (dataType == AmarinoIntent.STRING_EXTRA) {
				data = intent.getStringExtra(AmarinoIntent.EXTRA_DATA);

				try {
					// since we know that our string value is an int number we
					// can parse it to an integer
					String[] states = {"Preheat","Soak","Reflow","Cooldown", "Safe"};
					ReflowOven.setStateStr(states[(Integer.parseInt(data)) & 0xF000]);
					ReflowOven.setTempa((Integer.parseInt(data)) & 0x0FFF);
				} catch (NumberFormatException e) { /*
													 * oh data was not an
													 * integer
													 */
				}
			}
		}
	}
}
