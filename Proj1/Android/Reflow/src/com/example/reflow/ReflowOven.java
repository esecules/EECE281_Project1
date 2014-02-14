package com.example.reflow;

import java.util.ArrayList;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import at.abraxas.amarino.AmarinoIntent;
import com.example.reflow.graphview.GraphView.GraphViewData;

public class ReflowOven {
	private final String TAG = this.getClass().getSimpleName();
	private static ArrayList<GraphViewData> btGraphData = new ArrayList<GraphViewData>();
	private static ArrayList<GraphViewData> tempiGraphData = new ArrayList<GraphViewData>();
	private static boolean running;
	private static int tempi = 0;
	static double tempa = 0;
	private static long tempaSum;
	private static int avgCount=0;
	static double time = 0;
	private static String stateStr = "Stopped";
	public static boolean stateWasSet = false;

	public static boolean isRunning() {
		return running;
	}

	public static void setRunning(boolean run) {
		running = run;
	}

	public static String getStateStr() {
		return stateStr;
	}

	public static void setStateStr(String stateStr) {
		ReflowOven.stateStr = stateStr;
	}

	public static int getTempi() {
		return tempi;
	}

	public static void setTempi(int tempi) {
		ReflowOven.tempi = tempi;
	}

	public static double getTempa() {
		return tempa;
	}

	public static void setTempa(double d) {
		tempaSum+=d;
		avgCount++;
		if(avgCount > 15){
			ReflowOven.tempa = tempaSum/avgCount;
			avgCount = 0;
			tempaSum = 0;
		}
	}

	public static double getTime() {
		return time;
	}

	public static void setTime(double d) {
		ReflowOven.time = d;
	}

	public static void getBTData() {
		time += 1;
		synchronized (btGraphData) {
			Log.d("GET DATA", "Appending data ("+time+","+tempa+")");
			GraphViewData data = new GraphViewData(time, tempa);
			btGraphData.add(data);
			// Log.d(TAG, "returning from BT Data");
		}
		synchronized (tempiGraphData) {
			GraphViewData data = new GraphViewData(time, tempi);
			tempiGraphData.add(data);
			// Log.d(TAG, "returning from BT Data");
		}

	}

	public static ArrayList<GraphViewData> getbtGraphData() {
		synchronized (btGraphData) {
			return btGraphData;
		}
	}
	public static ArrayList<GraphViewData> getTempiGraphData() {
		synchronized (tempiGraphData) {
			return tempiGraphData;
		}
	}

	public static void reset() {
		time = 0;
		tempa = 0;
		tempi = 0;
		btGraphData.clear();
		tempiGraphData.clear();
		stateStr = "Stopped";
		stateWasSet = false;
		running = false;
	}

}
