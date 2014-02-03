package com.example.reflow;

import com.example.reflow.graphview.GraphView.GraphViewData;

public class ReflowOven {
	private static GraphViewData btGraphData;
	private static boolean running;
	private static int tempi, tempa, time;
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

	public static int getTempa() {
		return tempa;
	}

	public static void setTempa(int tempa) {
		ReflowOven.tempa = tempa;
	}

	public static int getTime() {
		return time;
	}

	public static void setTime(int time) {
		ReflowOven.time = time;
	}
	
	protected void getBTData(){
		String currentState = "";
		int currentTime = 0;
		//TODO read the x, y, and state data
		setStateStr(currentState);
		setTime(currentTime);
		btGraphData = new GraphViewData(ReflowOven.getTime(),ReflowOven.getTempa());
	}
	
	public static GraphViewData getbtGraphData(){
		return btGraphData;
	}

}
