package com.example.reflow;

import android.app.IntentService;
import android.content.Intent;
import android.os.Bundle;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;
import android.util.Log;

public class GraphService extends IntentService {
	private static boolean isRunning = true;
	private static final String TAG = ReflowOvenService.class
			.getSimpleName();

	public GraphService() {
		super("GraphService");
		Log.d(TAG, "constructor");
		// TODO Auto-generated constructor stub
	}

	@Override
	public void onCreate() {
		Log.d(TAG, "creating Service");
		// TODO Auto-generated method stub
		super.onCreate();
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
				Bundle bundle = workIntent.getExtras();
				if (bundle != null) {
					Messenger messenger = (Messenger) bundle
							.get("messenger");
					Message msg = Message.obtain();
					Bundle data = new Bundle();
					data.putBoolean("Append", true);
					msg.setData(data); // put the data here
					try {
						messenger.send(msg);
					} catch (RemoteException e) {
						Log.i(TAG, "error");
					}
				}
				try {
					Thread.sleep(2000);
				} catch (InterruptedException e) {
					Log.d(TAG, e.getMessage());
				}
			}
		}
	}

}
