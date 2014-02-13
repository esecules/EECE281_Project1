/*
  Sends sensor data to Arduino
  (needs SensorGraph and Amarino app installed and running on Android)
*/
 
#include <MeetAndroid.h>

MeetAndroid meetAndroid;
int sensor = 5;
int sensorValue = 0;
int outputValue = 0;
void setup()  
{
  // use the baud rate your bluetooth module is configured to 
  // not all baud rates are working well, i.e. ATMEGA168 works best with 57600
  Serial.begin(115200); 
 
  // we initialize analog pin 5 as an input pin
  pinMode(sensor, INPUT);
}

void loop()
{
  meetAndroid.receive(); // you need to keep this in your loop() to receive events
  
  // read input pin and send result to Android
  sensorValue = analogRead(sensor);
  outputValue = map(sensorValue, 0, 1023, 0, 300); 
  meetAndroid.send(outputValue);
  
  // add a little delay otherwise the phone is pretty busy
  delay(100);
}


