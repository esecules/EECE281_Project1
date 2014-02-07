package com.example.reflow;

import java.util.ArrayList;
import java.util.Random;

import android.util.Log;

import com.example.reflow.graphview.GraphView.GraphViewData;

public class ReflowOven {
	private static final String TAG = ReflowOvenService.class.getSimpleName();
	private static ArrayList<GraphViewData> btGraphData = new ArrayList<GraphViewData>();
	private static boolean running;
	private static int tempi, nElements = 0;
	static double tempa = 20;
	static double time = 0;
	private static String stateStr = "Stopped";
	public boolean stateWasSet = false;

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
		ReflowOven.tempa = d;
	}

	public static double getTime() {
		return time;
	}

	public static void setTime(double d) {
		ReflowOven.time = d;
	}

	public static void getBTData() {
		Random rn = new Random();
		String currentState = "Boggis";
		int currentTime;
		// TODO read the x, y, and state data
		synchronized (btGraphData) {
			setStateStr(currentState);
			setTime(getTime() + 1);
			Log.d(TAG, "Appending data");
			GraphViewData data = new GraphViewData(ReflowOven.getTime(),
					rn.nextInt() % 10);
			btGraphData.add(data);
			// Log.d(TAG, "returning from BT Data");
		}
	}

	public static ArrayList<GraphViewData> getbtGraphData() {
		synchronized (btGraphData) {
			return btGraphData;
		}
	}

}
