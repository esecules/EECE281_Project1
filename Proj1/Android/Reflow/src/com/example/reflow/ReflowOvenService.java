package com.example.reflow;

import android.app.IntentService;
import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;

public class ReflowOvenService extends IntentService {
	static boolean isRunning = true;
	private static final String TAG = ReflowOvenService.class.getSimpleName();
	public  ReflowOvenService() {
		super("ReflowOvenService");
		// TODO Auto-generated constructor stub
	}

	@Override
	public IBinder onBind(Intent intent) {
		// TODO Auto-generated method stub
		return super.onBind(intent);
	}

	@Override
	protected void onHandleIntent(Intent workIntent) {
		// Gets data from the incoming Intent
		String dataString = workIntent.getDataString();
		if ("com.example.reflow.GET_BACKGROUND_DATA" == dataString)
			Log.d(TAG, "got Intent " + dataString);
		
		while(isRunning){
			Log.d(TAG, "cycleing");
			ReflowOven.getBTData();
			try{
				Thread.sleep(1000);
			}catch(InterruptedException e){
				Log.d(TAG,e.getMessage());
			}
		}
		// Do work here, based on the contents of dataString
	}

	@Override
	public void onCreate() {
		// TODO Auto-generated method stub
		Log.d(TAG, "creating Service");
		super.onCreate();
	}

	@Override
	public void onDestroy() {
		// TODO Auto-generated method stub
		Log.d(TAG, "Destroying Service");
		super.onDestroy();
		
	}

}
