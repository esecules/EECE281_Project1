package com.example.reflow;

import android.os.Bundle;
import android.app.Activity;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.ToggleButton;

public class Main_screen extends Activity {
	EditText txtsoakTemp, txtsoakTime, txtmaxTemp;
	Integer soakTemp, soakTime, maxTemp;
	ToggleButton toggle;
	boolean running;
	boolean caughtFormatException = false;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_screen);
        
        toggle = (ToggleButton)findViewById(R.id.toggleButton1);
        txtsoakTemp = (EditText)findViewById(R.id.editSTemp);
        txtsoakTime = (EditText)findViewById(R.id.editSTime);
        txtmaxTemp = (EditText)findViewById(R.id.editMTemp);
       
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
					}
					if(!caughtFormatException){
						if(validateInput()){
							running = true;
						}
					}
				}
				else if (running){
					running = false;
				}
				
			}
		});
        
    }
private boolean validateInput(){
	@SuppressWarnings("unused")
	String errors, eSoakTemp="", eSoakTime ="", eMaxTemp=""; 
	int errorCt = 0;
	if (soakTemp > 215 || soakTemp < 100 || soakTemp > maxTemp){
		eSoakTemp = "ERROR soak temp\n";
		errorCt ++;
	}
	if(soakTime > 180 || soakTime < 0){
		eSoakTime = "ERROR soak time\n";
		errorCt ++;
	}
	if(maxTemp > 260 || maxTemp < soakTemp){
		eMaxTemp = "ERROR max temp\n";
		errorCt ++;
	}
	if(errorCt < 0){
		errors = eSoakTemp + eSoakTime + eMaxTemp;
		//TODO 
		//display pop-up box with errors
		return false;
	}
	return true;
	
}
    
}
