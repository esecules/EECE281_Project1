package com.example.reflow;

import com.example.reflow.graphview.GraphView;
import com.example.reflow.graphview.GraphViewSeries;
import com.example.reflow.graphview.GraphViewStyle;
import com.example.reflow.graphview.LineGraphView;
import com.example.reflow.graphview.GraphView.GraphViewData;


import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.widget.LinearLayout;

public class Graph_activity extends Activity {
	private GraphViewData[] data;
	GraphViewData btGraphData;
	private GraphViewSeries graphSeries;
	private LinearLayout layout;
	private GraphView graphView;
	
	 
	
	protected void onCreate(Bundle savedInstanceState) {
	        super.onCreate(savedInstanceState);
	        setContentView(R.layout.activity_graph_view);
	        graphView = new LineGraphView(this , "Temperature Chart");
	        layout = (LinearLayout) findViewById(R.id.graph1);
	        GraphViewStyle style = new GraphViewStyle();
	        data = new GraphViewData[]{new GraphViewData(0,0)};
	        graphSeries = new GraphViewSeries(data);
	        style.setTextSize(10);
	        style.setNumHorizontalLabels(10);
	        // add data
	        // set view port, start=2, size=40
	        graphView.setViewPort(0, 40);
	        graphView.setScrollable(true);
	        graphView.setGraphViewStyle(style);
	        graphView.setBackgroundColor(Color.rgb(80, 30, 30));
	        graphView.addSeries(graphSeries);
	        layout.addView(graphView);
	 }
	public void appendGraphSeries(GraphViewData data) {
		this.graphSeries.appendData(data, true, 150);
		graphView.addSeries(graphSeries);
		layout.addView(graphView);
	}
	protected void onResume(){
		while(true){
			appendGraphSeries(btGraphData);
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
}
