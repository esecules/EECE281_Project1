package com.example.reflow;

import android.util.Log;

import com.example.reflow.graphview.GraphView.GraphViewData;

public class ReflowOven {
	private static final String TAG = ReflowOvenService.class.getSimpleName();
	private static GraphViewData[] btGraphData = new GraphViewData[30000];
	private static boolean running;
	private static int tempi,nElements=0;
	static double tempa;
	static double time;
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
	
	public static void getBTData(){
		String currentState = "Boggis";
		int currentTime = 0;
		//TODO read the x, y, and state data
		setStateStr(currentState);
		setTime(currentTime);
		Log.d(TAG, "Appending data");
		btGraphData[nElements] = new GraphViewData(ReflowOven.getTime(),ReflowOven.getTempa());
		nElements++;
		Log.d(TAG, "returning from BT Data");
	}
	
	public static int getnElements() {
		return nElements;
	}

	public static void setnElements(int nElements) {
		ReflowOven.nElements = nElements;
	}

	public static GraphViewData[] getbtGraphData(){
		return btGraphData;
	}

	

}
