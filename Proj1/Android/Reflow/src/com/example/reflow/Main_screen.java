/**
 * Manages the main screen of the app
 * @author Eric Secules
 *
 * Thanks to jjoe64 for Graph View
 * http://android-graphview.org/
 */

package com.example.reflow;


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
	EditText txtsoakTemp, txtsoakTime, txtmaxTemp;
	TextView currentState;
	Integer soakTemp, soakTime, maxTemp;
	ToggleButton toggle;
	Button toGraph;
	public ProgressBar mProgress;
	boolean caughtFormatException = false;
	Builder outOfRangeAlert;
	Builder emptyFieldAlert;
	String errors;
	ReflowOvenService oven;

	
	
	
	
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
							ReflowOven.setRunning(true);

							
							DataSender sendStart = new DataSender();
							sendStart.execute(Constants.SOAK_TEMP_TAG,
									soakTemp, Constants.SOAK_TIME_TAG,
									soakTime, Constants.MAX_TEMP_TAG, maxTemp,
									Constants.START_TAG);
							 
							
							Intent getDataIntent = new Intent(Constants.GET_DATA);
							getDataIntent.setClass(getBaseContext(),ReflowOvenService.class);
							getDataIntent.putExtra("messenger", new Messenger(handler));
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
				}
			}
		});

	}
	


	
	/*
	 * Validate the input and show appropriate error messages if input is out of
	 * bounds
	 */
	private boolean validateInput() {
		String eSoakTemp, eSoakTime, eMaxTemp;
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

		if (maxTemp > 260) {
			eMaxTemp = "-Max temp too high (>260)\n";
			wasError = true;
		} else if (maxTemp < 200) {
			eMaxTemp = "-Max temp too low (<200)\n";
			wasError = true;
		} else
			eMaxTemp = "";

		if (wasError) {
			errors = eSoakTemp + eSoakTime + eMaxTemp;
			new AlertDialog.Builder(this).setTitle("Invalid Input")
					.setMessage(errors).setNeutralButton("Close", null).show();
			return false;
		} else
			return true;

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
				for (Integer i : params) {
					Log.d(TAG, "sending " + i.toString());
					// TODO Put BT sending code here
				}
			}
			if (params.length == Constants.STOP_PARAMS) {
				Log.d(TAG, "stop code " + params[0].toString());
				// TODO Put BT sending code here

			}
			return null;
		}

	}
}
