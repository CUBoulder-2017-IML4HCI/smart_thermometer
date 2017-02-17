import processing.serial.*;

import cc.arduino.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

Serial serial;
Arduino arduino;

final int blueLED = 5;
final int greenLED = 6;
final int yellowLED = 8;
final int redLED = 9;

final int tempPin = 0;

//raw reading variable
int tempVal;

//voltage variable
float volts;

//final temperature variables
float tempC;
float tempF;


void setup() {
  //size(470, 280);
  size(400,400);
  frameRate(25);

  // Prints out the available serial ports.
  //printArray(Arduino.list());
 
   /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  dest = new NetAddress("127.0.0.1",6448);
  
  arduino = new Arduino(this, Arduino.list()[2], 57600);
  arduino.pinMode(blueLED,arduino.OUTPUT);
  arduino.pinMode(greenLED,arduino.OUTPUT);
  arduino.pinMode(yellowLED,arduino.OUTPUT);
  arduino.pinMode(redLED,arduino.OUTPUT);
}

void draw()
{
  tempVal = arduino.analogRead(tempPin);

   //converting that reading to voltage by multiplying the reading by 3.3V (voltage of       //the 101 board)
   volts = tempVal * 3.3;
   volts /= 1023.0;


   //calculate temperature celsius from voltage
   //equation found on the sensor spec.
   tempC = (volts - 0.5) * 100 ;

  // Convert from celcius to fahrenheit
  tempF = (tempC * 9.0 / 5.0) + 32.0;

  
  //println(temp);
  OscMessage msg = new OscMessage("/wek/inputs");
  msg.add(tempF); 
  //println(msg);
  oscP5.send(msg, dest);
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 println("received message");
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    if(theOscMessage.checkTypetag("f")) {
      float f = theOscMessage.get(0).floatValue();
      colorLight((int)f);
      
    }
  }
}

void colorLight(int c){
  if(c==1) {
    arduino.digitalWrite(5,1);
    arduino.digitalWrite(6,0);
    arduino.digitalWrite(8,0);
    arduino.digitalWrite(9,0);
  }
  else if(c==2){
    arduino.digitalWrite(5,0);
    arduino.digitalWrite(6,1);
    arduino.digitalWrite(8,0);
    arduino.digitalWrite(9,0);
  }
  else if(c==3){
    arduino.digitalWrite(5,0);
    arduino.digitalWrite(6,0);
    arduino.digitalWrite(8,1);
    arduino.digitalWrite(9,0);
    
  }
  else if(c==4){
    arduino.digitalWrite(5,0);
    arduino.digitalWrite(6,0);
    arduino.digitalWrite(8,0);
    arduino.digitalWrite(9,1);
  }
}




 