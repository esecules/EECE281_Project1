package com.example.reflow;

import android.app.Application;
import at.abraxas.amarino.Amarino;

public class bluetooth extends Application {
	
	private static final String DEVICE_ADDRESS =  "00:06:66:66:33:1B";

    @Override
    public void onCreate() 
    {
        super.onCreate();
        Amarino.connect(this, DEVICE_ADDRESS);
    }

}