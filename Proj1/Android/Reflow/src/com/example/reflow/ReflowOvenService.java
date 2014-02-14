package com.example.reflow;

import android.app.IntentService;
import android.app.Service;
import android.content.Intent;
import android.os.Bundle;
import android.os.IBinder;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;
import android.util.Log;

public class ReflowOvenService extends IntentService {
	private static boolean isRunning = true;
	private final String TAG = this.getClass().getSimpleName();
	
	public ReflowOvenService() {
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
		isRunning = true;
		// Gets data from the incoming Intent
		String dataString = workIntent.getAction();
		// Do work here, based on the contents of dataString
		Log.d(TAG, "got Intent " + dataString);
		if (dataString.equals(Constants.GET_DATA)) {
			// Log.d(TAG, "got Intent " + dataString);
			while (isRunning) {
				//Log.d(TAG, "cycleing");
				ReflowOven.getBTData();
				Bundle bundle = workIntent.getExtras();
			    if (bundle != null) {
			        Messenger messenger = (Messenger) bundle.get("messenger");
			        Message msg = Message.obtain();
			        Bundle data = new Bundle();
					data.putString("state", ReflowOven.getStateStr());
					data.putDouble("progress", ReflowOven.getTime()/6);
					msg.setData(data); //put the data here
			        try {
			            messenger.send(msg);
			        } catch (RemoteException e) {
			            Log.i(TAG, "error");
			        }
			    }
				try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					Log.d(TAG, e.getMessage());
				}
			}
		}
	}
	

	public static void stopMe() {
		isRunning = false;
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
