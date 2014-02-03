/**
 * Thanks to jjoe64 for Graph View
 * http://android-graphview.org/
 */

package com.example.reflow;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.ToggleButton;

import com.example.reflow.graphview.BarGraphView;
import com.example.reflow.graphview.GraphView;
import com.example.reflow.graphview.GraphView.GraphViewData;
import com.example.reflow.graphview.GraphViewSeries;
import com.example.reflow.graphview.LineGraphView;


public class Main_screen extends Activity {
	EditText txtsoakTemp, txtsoakTime, txtmaxTemp;
	TextView currentState;
	Integer soakTemp, soakTime, maxTemp;
	ToggleButton toggle;
	Button toGraph;
	ProgressBar mProgress;
	boolean caughtFormatException = false;
	Builder outOfRangeAlert;
	Builder emptyFieldAlert;
	String errors;
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_screen);
        currentState = (TextView) findViewById(R.id.currentState);
        mProgress = (ProgressBar) findViewById(R.id.progressBar1);	
        toggle = (ToggleButton)findViewById(R.id.toggleButton1);
        toGraph = (Button)findViewById(R.id.button1);
        txtsoakTemp = (EditText)findViewById(R.id.editSTemp);
        txtsoakTime = (EditText)findViewById(R.id.editSTime);
        txtmaxTemp = (EditText)findViewById(R.id.editMTemp);
        emptyFieldAlert = new AlertDialog.Builder(this).setTitle("Invalid Input").setMessage("Input cannot be parsed into a 32 bit integer, try again").setNeutralButton("Close", null);
       
        currentState.setText(ReflowOven.getStateStr());
        
        toGraph.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
				Intent intentMain = new Intent(Main_screen.this , 
	                       Graph_activity.class);
				Main_screen.this.startActivity(intentMain);
				Log.i("Content "," Main layout ");
			}
        });
        
        toggle.setOnCheckedChangeListener(new OnCheckedChangeListener() {
			@Override
			public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
				if(isChecked){
					try{
						soakTemp = Integer.valueOf( txtsoakTemp.getText().toString() );
						soakTime = Integer.valueOf( txtsoakTime.getText().toString() );
						maxTemp = Integer.valueOf( txtmaxTemp.getText().toString() );
					}
					catch(NumberFormatException e){
						 caughtFormatException = true;
						 toggle.setChecked(false);
						 ReflowOven.setRunning(false);
						 emptyFieldAlert.show();
					}
					if(!caughtFormatException){
						if(validateInput()){
							ReflowOven.setRunning(true);
							mProgress.setProgress(10);
						}else
							toggle.setChecked(false);
					}else
						caughtFormatException = false;
				}
				else if (ReflowOven.isRunning()){
					ReflowOven.setRunning(false);
					mProgress.setProgress(0);
				}	
			}
		});  
        
    }
private boolean validateInput(){
	String eSoakTemp, eSoakTime, eMaxTemp; 
	boolean wasError = false;
	if (soakTemp > 215 ){
		eSoakTemp = "-Soak temp too high (>215)\n";
		wasError = true;
	}
	else if(soakTemp <= 100 ){
		eSoakTemp = "-Soak temp too low (<100)\n";
		wasError = true;
	}
	else if(soakTemp > maxTemp){
		eSoakTemp = "-Soak temp greater than max temp\n";
		wasError = true;
	}
	else
		eSoakTemp = "";
	
	if(soakTime > 180 ){
		eSoakTime = "-Soak time too long (>180)\n";
		wasError = true;
		}
	else if (soakTime < 60){
		eSoakTime = "-Soak time too short (<60)\n";
		wasError = true;
	}
	else
		eSoakTime = "";
	
	if(maxTemp > 260 ){
		eMaxTemp = "-Max temp too high (>260)\n";
		wasError = true;
	}
	else if(maxTemp < 200){
		eMaxTemp = "-Max temp too low (<200)\n";
		wasError = true;
	}
	else
		eMaxTemp = "";
		
	if(wasError){
		errors = eSoakTemp + eSoakTime + eMaxTemp;
		new AlertDialog.Builder(this).setTitle("Invalid Input").setMessage(errors).setNeutralButton("Close", null).show();
		return false;
	}
	else
	return true;
	
}
    
}
