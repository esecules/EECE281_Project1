package com.example.reflow;

import java.util.ArrayList;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.Messenger;
import android.util.Log;
import android.widget.LinearLayout;
import at.abraxas.amarino.AmarinoIntent;
import android.content.IntentFilter;
import at.abraxas.amarino.Amarino;
import com.example.reflow.graphview.GraphView;
import com.example.reflow.graphview.GraphView.GraphViewData;
import com.example.reflow.graphview.GraphViewSeries;
import com.example.reflow.graphview.GraphViewStyle;
import com.example.reflow.graphview.LineGraphView;

public class Graph_activity extends Activity {
	private final String TAG = this.getClass().getSimpleName();
	static final int WINDOW_SIZE = 30;
	private GraphViewData[] data;
	private GraphViewSeries graphSeries;
	private LinearLayout layout;
	private GraphView graphView;
	private int lastRead;
	static int datax; 
	
private ArduinoReceiver arduinoReceiver = new ArduinoReceiver();

private static final String DEVICE_ADDRESS =  "00:06:66:66:33:1B";
	


	// private int x = 0, y = 0;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Log.d(TAG, "On Create");
		setContentView(R.layout.activity_graph_view);
		Handler handler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				Bundle reply = msg.getData();
				Log.d(TAG, "Got reply");
				if ((Boolean) reply.get("Append")) {
					Log.d(TAG, "Calling append");
					appendGraphSeries(ReflowOven.getbtGraphData());
				}
			}
		};
		graphView = new LineGraphView(this, "Temperature Chart");
		layout = (LinearLayout) findViewById(R.id.graph1);
		GraphViewStyle style = new GraphViewStyle();
		data = new GraphViewData[] { new GraphViewData(0, 0) };
		graphSeries = new GraphViewSeries(data);
		style.setTextSize(10);
		style.setNumHorizontalLabels(3);
		graphView.setViewPort(0, WINDOW_SIZE);
		graphView.setScrollable(true);
		graphView.setClickable(true);
		graphView.setGraphViewStyle(style);
		graphView.setBackgroundColor(Color.rgb(80, 30, 30));
		layout.addView(graphView);
		lastRead = 0; // Read from start.
		Intent updateGraphIntent = new Intent(Constants.UPDATE_GRAPH);
		updateGraphIntent.setClass(getBaseContext(), GraphService.class);
		updateGraphIntent.putExtra("messenger", new Messenger(handler));
		Log.d(TAG, "Starting " + updateGraphIntent.getAction());
		startService(updateGraphIntent);
	}

	@Override
	protected void onStart() {
		super.onStart();
		// in order to receive broadcasted intents we need to register our receiver
		registerReceiver(arduinoReceiver, new IntentFilter(AmarinoIntent.ACTION_RECEIVED));
		
		// this is how you tell Amarino to connect to a specific BT device from within your own code
		Amarino.connect(this, DEVICE_ADDRESS);
	}


	@Override
	protected void onStop() {
		super.onStop();
		
		Log.d(TAG, "On Stop");
		GraphService.stopMe();
		
		// if you connect in onStart() you must not forget to disconnect when your app is closed
		Amarino.disconnect(this, DEVICE_ADDRESS);
		
		// do never forget to unregister a registered receiver
		unregisterReceiver(arduinoReceiver);
	}
	
	
	public class ArduinoReceiver extends BroadcastReceiver {

		@Override
		public void onReceive(Context context, Intent intent) {
			String data = null;
			
			// the type of data which is added to the intent
			final int dataType = intent.getIntExtra(AmarinoIntent.EXTRA_DATA_TYPE, -1);
			
			// we only expect String data though, but it is better to check if really string was sent.
			// you have to parse the data to the type you have sent from Arduino.
			if (dataType == AmarinoIntent.STRING_EXTRA){
				data = intent.getStringExtra(AmarinoIntent.EXTRA_DATA);
				
					try {
						// since we know that our string value is an int number we can parse it to an integer
						datax = Integer.parseInt(data);
					} 
					catch (NumberFormatException e) { /* oh data was not an integer */ }
				}
			}
		}
	
	/**
	 * Appends the graph series with new data from dataArray and updates the
	 * display
	 * 
	 * @param arrayList
	 */
	public void appendGraphSeries(ArrayList<GraphViewData> arrayList) {

		GraphViewData data;
		int i;
		if (ReflowOven.getbtGraphData().size() > lastRead) {
			Log.d(TAG, "appendindata this many elements: " + (arrayList.size() - lastRead));
			for (i = lastRead; i < ReflowOven.getbtGraphData().size(); i++) {
				Log.d(TAG, "Reading from: " + i);
				data = ReflowOven.getbtGraphData().get(i);
				Log.d(TAG, "Appending Data (" + data.valueX + "," + data.valueY + ")");
				graphSeries.appendData(data, (data.valueX >= WINDOW_SIZE), 150);
			}
			lastRead = i;
			Log.d(TAG, "Next index is " + lastRead);

			this.graphView.removeAllSeries();
			this.graphView.addSeries(graphSeries);
			this.layout.refreshDrawableState();
		} else
			Log.d(TAG, "No new data yet");
	}

}
