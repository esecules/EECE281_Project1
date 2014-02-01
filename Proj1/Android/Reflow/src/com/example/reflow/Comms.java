package com.example.reflow;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.bluetooth.BluetoothAdapter;

public class Comms  {
	private Builder noBluetooth;
	public void setup(){
		BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
		if (mBluetoothAdapter == null) {
			noBluetooth = new AlertDialog.Builder(this).setTitle("Invalid Input").setMessage("Input cannot be parsed into a 32 bit integer, try again").setNeutralButton("Close", null);
		}
	}
}
