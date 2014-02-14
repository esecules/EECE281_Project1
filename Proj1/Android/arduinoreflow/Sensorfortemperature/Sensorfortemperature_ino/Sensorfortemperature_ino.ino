

/*
  Mega multple serial test
 
 Receives from the main serial port, sends to the others. 
 Receives from serial port 1, sends to the main serial (Serial 0).
 
 This example works only on the Arduino Mega
 
 The circuit: 
 * Any serial device attached to Serial port 1
 * Serial monitor open on Serial port 0:
 
 created 30 Dec. 2008
 modified 20 May 2012
 by Tom Igoe & Jed Roach
 
 This example code is in the public domain.
 
 */
#include <MeetAndroid.h>

MeetAndroid meetAndroid;

char buffer[100];
char returnchar = '\r' ;

void setup() {
  // initialize both serial ports:
  Serial.begin(115200);
  Serial1.begin(57600);
  
  
  meetAndroid.registerFunction(soak_temp, 'A');
  meetAndroid.registerFunction(soak_time, 'B');  
  meetAndroid.registerFunction(reflow_temp, 'C'); 
  meetAndroid.registerFunction(reflow_time, 'D');
  meetAndroid.registerFunction(max_temp, 'E');  
  meetAndroid.registerFunction(start_tag, 'F'); 
  meetAndroid.registerFunction(stop_tag, 'Z'); 
  
}

void loop() {
  
   meetAndroid.receive();
   
  // read from port 1, send to port 0:
  if (Serial1.available()) {
  Serial1.readBytesUntil(returnchar,buffer,100);
  for(int i=0;i<65;i++){
   meetAndroid.send(buffer[i]); 
  }
  }
  
  // read from port 0, send to port 1:
 // if (Serial.available()) {
 //   Serial1.write(meetAndroid.getInt()); 
 // }
  delay(100);
}

void soak_temp(byte flag, byte numOfValues)
{
  Serial1.write(meetAndroid.getInt());
}

void soak_time(byte flag, byte numOfValues)
{
  Serial1.write(meetAndroid.getInt());
}

void reflow_temp(byte flag, byte numOfValues)
{
  Serial1.write(meetAndroid.getInt());
}

void reflow_time(byte flag, byte numOfValues)
{
  Serial1.write(meetAndroid.getInt());
}

void max_temp(byte flag, byte numOfValues)
{
  Serial1.write(meetAndroid.getInt());
}

void start_tag(byte flag, byte numOfValues)
{
  Serial1.write(meetAndroid.getInt());
}

void stop_tag(byte flag, byte numOfValues)
{
  Serial1.write(meetAndroid.getInt());
}
