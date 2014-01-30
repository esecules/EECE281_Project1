package com.example.reflow;


import com.jjoe64.graphview.BarGraphView;
import com.jjoe64.graphview.GraphView;
import com.jjoe64.graphview.GraphViewSeries;
import com.jjoe64.graphview.GraphView.GraphViewData;
import android.app.Activity;
import android.os.Bundle;
import android.widget.LinearLayout;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.ToggleButton;


public class Main_screen extends Activity {
	EditText txtsoakTemp, txtsoakTime, txtmaxTemp;
	Integer soakTemp, soakTime, maxTemp;
	ToggleButton toggle;
	boolean running;
	boolean caughtFormatException = false;
	Builder outOfRangeAlert;
	Builder emptyFieldAlert;
	String errors="blah";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_screen);
        
        toggle = (ToggleButton)findViewById(R.id.toggleButton1);
        txtsoakTemp = (EditText)findViewById(R.id.editSTemp);
        txtsoakTime = (EditText)findViewById(R.id.editSTime);
        txtmaxTemp = (EditText)findViewById(R.id.editMTemp);
        emptyFieldAlert = new AlertDialog.Builder(this).setTitle("Invalid Input").setMessage("All fields are required\nTry again").setNeutralButton("Close", null);
        outOfRangeAlert = new AlertDialog.Builder(this).setTitle("Invalid Input").setMessage(errors).setNeutralButton("Close", null);
        
     
        
        toggle.setOnCheckedChangeListener(new OnCheckedChangeListener() {
        ProgressBar mProgress = (ProgressBar) findViewById(R.id.progressBar1);	
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
						 running = false;
						 emptyFieldAlert.show();
					}
					if(!caughtFormatException){
						if(validateInput()){
							running = true;
							mProgress.setProgress(10);
						}
						else
							toggle.setChecked(false);
					}else
						caughtFormatException = false;
				}
				else if (running){
					running = false;
					mProgress.setProgress(0);
					mProgress.setDrawingCacheBackgroundColor(0xFF0000);
				}
				
			}
		});
        
//     // init example series data
//        GraphViewSeries exampleSeries = new GraphViewSeries(new GraphViewData[] {
//              new GraphViewData(1, 2.0d)
//              , new GraphViewData(2, 1.5d)
//              , new GraphViewData(3, 2.5d)
//              , new GraphViewData(4, 1.0d)
//        });
//         
//        GraphView graphView = new BarGraphView(
//              this // context
//              , "GraphViewDemo" // heading
//        );
//        graphView.addSeries(exampleSeries); // data
//         
//        LinearLayout layout = (LinearLayout) findViewById(R.id.graph1);
//        layout.addView(graphView);
        
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
