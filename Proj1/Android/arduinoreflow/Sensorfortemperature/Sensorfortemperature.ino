//#include <LiquidCrystal.h>

/*
  Sends sensor data to Arduino
  (needs SensorGraph and Amarino app installed and running on Android)
*/
 
#include <MeetAndroid.h>

MeetAndroid meetAndroid;
int sensor = 5;
int sensorValue = 0;
int outputValue = 0;
//LiquidCrystal lcd(8, 9, 4, 5, 6, 7);

void setup()  
{
  // use the baud rate your bluetooth module is configured to 
  // not all baud rates are working well, i.e. ATMEGA168 works best with 57600
  Serial.begin(115200); 
 
  // we initialize analog pin 5 as an input pin
  pinMode(sensor, INPUT);
// lcd.begin(16, 2);              // start the library
 //lcd.setCursor(0,0);

}

void loop()
{
  meetAndroid.receive(); // you need to keep this in your loop() to receive events
  //lcd.clear();
  //lcd.setCursor(0,0);
   //lcd.print(analogRead(sensor)); // print a simple message
  // read input pin and send result to Android
  meetAndroid.send(analogRead(sensor));
  
  // add a little delay otherwise the phone is pretty busy
  delay(100);
}


