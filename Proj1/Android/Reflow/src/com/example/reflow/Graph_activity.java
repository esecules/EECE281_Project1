package com.example.reflow;

import java.util.ArrayList;

import com.example.reflow.graphview.GraphView;
import com.example.reflow.graphview.GraphViewSeries;
import com.example.reflow.graphview.GraphViewStyle;
import com.example.reflow.graphview.LineGraphView;
import com.example.reflow.graphview.GraphView.GraphViewData;

import android.app.Activity;
import android.app.AlertDialog;
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
//	private int x = 0, y = 0;

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
		appendGraphSeries(ReflowOven.getbtGraphData());
		refresh.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				Log.d(TAG, "Graph Clicked");
				appendGraphSeries(ReflowOven.getbtGraphData());
			}
		});
	}
/**
 * Appends the graph series with new data from dataArray and updates the display
 * @param arrayList
 */
	public void appendGraphSeries(ArrayList<GraphViewData> arrayList) {
		Log.d(TAG, "appendindata this long: " + arrayList.size());
		for (GraphViewData data : ReflowOven.getbtGraphData()) {
			Log.d(TAG, "Appending Data (" + data.valueX + ","+ data.valueY+")");
			this.graphSeries.appendData(data,
					(data.valueX >= WINDOW_SIZE), 150);
		}
		this.graphView.addSeries(graphSeries);
		this.layout.addView(graphView);
	}
}
