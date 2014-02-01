package com.example.reflow;

public class ReflowOven {
	private static boolean running;
	private static int tempi, tempa, state;
	private static String stateStr;
	

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

	public static int getState() {
		return state;
	}

	public static void setState(int state) {
		ReflowOven.state = state;
	}

}
