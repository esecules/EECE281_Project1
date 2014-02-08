package com.example.reflow;

import java.util.ArrayList;

import com.example.reflow.graphview.GraphView;
import com.example.reflow.graphview.GraphViewSeries;
import com.example.reflow.graphview.GraphViewStyle;
import com.example.reflow.graphview.LineGraphView;
import com.example.reflow.graphview.GraphView.GraphViewData;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.IntentService;
import android.app.Service;
import android.graphics.Color;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.LinearLayout;
import android.app.AlertDialog.Builder;
import android.content.Intent;

public class Graph_activity extends Activity {
	private static final String TAG = ReflowOvenService.class.getSimpleName();
	static final int WINDOW_SIZE = 60;
	private GraphViewData[] data;
	private GraphViewSeries graphSeries;
	private LinearLayout layout;
	private GraphView graphView;
	private Button refresh;
	private int lastRead;

	// private int x = 0, y = 0;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_graph_view);
		graphView = new LineGraphView(this, "Temperature Chart");
		layout = (LinearLayout) findViewById(R.id.graph1);
		refresh = (Button) findViewById(R.id.refresh);
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
		Intent getDataIntent = new Intent(
				Constants.UPDATE_GRAPH);
		getDataIntent.setClass(getBaseContext(),
				GraphService.class);
		Log.d(TAG, "Starting " + getDataIntent.getAction());
		startService(getDataIntent);
//		appendGraphSeries(ReflowOven.getbtGraphData());
//		refresh.setOnClickListener(new OnClickListener() {
//		
//			@Override
//			public void onClick(View v) {
//				Log.d(TAG, "Refresh Clicked");
//				appendGraphSeries(ReflowOven.getbtGraphData());
//			}
//		});
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
			Log.d(TAG, "appendindata this long: " + arrayList.size());
			for (i = lastRead + 1; i < ReflowOven.getbtGraphData().size(); i++) {
				data = ReflowOven.getbtGraphData().get(i);
				Log.d(TAG, "Appending Data (" + data.valueX + "," + data.valueY + ")");
				graphSeries.appendData(data, (data.valueX >= WINDOW_SIZE), 150);
			}
			lastRead = i;
			Log.d(TAG, "Last index read is" + lastRead);

			this.graphView.removeAllSeries();
			this.graphView.addSeries(graphSeries);
			this.layout.refreshDrawableState();
		}else
			Log.d(TAG, "No new data yet");
	}
	private static class GraphService extends IntentService{
		private static boolean isRunning = true;
		private static final String TAG = ReflowOvenService.class.getSimpleName();
		public GraphService(String name) {
			super(name);
			// TODO Auto-generated constructor stub
		}

		@Override
		protected void onHandleIntent(Intent workIntent) {
			isRunning = true;
			// Gets data from the incoming Intent
			String dataString = workIntent.getAction();
			// Do work here, based on the contents of dataString
			Log.d(TAG, "got Intent " + dataString);
			if (dataString.equals(Constants.UPDATE_GRAPH)) {
				// Log.d(TAG, "got Intent " + dataString);
				while (isRunning) {
					Log.d(TAG, "updating graph");
					//TODO notify graph view to run appendGraphSeries once.				
					try {
						Thread.sleep(2000);
					} catch (InterruptedException e) {
						Log.d(TAG, e.getMessage());
					}
				}
			}
		}
		
	}
}
