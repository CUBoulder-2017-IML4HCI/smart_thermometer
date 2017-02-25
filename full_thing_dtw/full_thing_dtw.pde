import processing.serial.*;

import cc.arduino.*;

import oscP5.*;
import netP5.*;
import controlP5.*;

ControlP5 cp5;
OscP5 oscP5;
//OscP5 oscP51;
NetAddress dest;
NetAddress dest1;

Serial serial;
Arduino arduino;

final int blueLED = 9;
final int redLED = 8;

final long hi = 262;
final long lo = 563;


final int buttonPin = 3;

final int tempPin = 0;
final int heartRate = 1;
final int buzzer = 5;

boolean isRecording = true; //mode
boolean isRecordingNow = false;
boolean isRunningNow = false;

boolean initial_press = true;

//raw reading variable
int tempVal;

int currentClass = 1;

int currentHue = 100;


void setup() {
  //size(470, 280);
  size(400,400);
  frameRate(25);
  background(255);

  // Prints out the available serial ports.
  printArray(Arduino.list());
 
 //Classification
   /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  dest = new NetAddress("127.0.0.1",6448);
 
 //DTW
   /* start oscP5, listening for incoming messages at port 12000 */
  //oscP51 = new OscP5(this,12001);
  dest1 = new NetAddress("127.0.0.1",6449);
  
  arduino = new Arduino(this, Arduino.list()[2], 57600);
 
  arduino.pinMode(buttonPin,Arduino.INPUT);
  arduino.pinMode(blueLED,Arduino.OUTPUT);
  arduino.pinMode(redLED,Arduino.OUTPUT);
  arduino.pinMode(buzzer,Arduino.OUTPUT);
  
  createControls();
}

void createControls() {
  cp5 = new ControlP5(this);
  cp5.addToggle("isRecording")
     .setPosition(10,20)
     .setSize(75,20)
     .setValue(true)
     .setCaptionLabel("record/run")
     .setMode(ControlP5.SWITCH)
     ;
}

void draw()
{
  background(currentHue);
 int buttonState = arduino.digitalRead(buttonPin);
 //println(buttonState);
 if(buttonState == Arduino.LOW){
   
   if(initial_press) {
     initial_press = false;
    if (isRecording) {
     isRecordingNow = true;
     OscMessage msg = new OscMessage("/wekinator/control/startDtwRecording");
     msg.add(currentClass);
     oscP5.send(msg, dest1);
  } else {
    isRunningNow = true;
    OscMessage msg = new OscMessage("/wekinator/control/startRunning");
    oscP5.send(msg, dest1);
  }
   }
  int heartRateMeasurement = arduino.analogRead(heartRate);
  float hr = map(heartRateMeasurement, 0, 1023, 0, 100);
  sendOsc(hr);
 }
 else {
    if (isRecordingNow) {
     isRecordingNow = false;
     OscMessage msg = new OscMessage("/wekinator/control/stopDtwRecording");
      oscP5.send(msg, dest1);
  }
  else if (isRunningNow){
    isRunningNow = false;
    println("stopped running");
    OscMessage msg = new OscMessage("/wekinator/control/stopRunning");
    oscP5.send(msg, dest1);
  }
  initial_press = true;
   
 }
 tempVal = arduino.analogRead(tempPin);
 OscMessage msg = new OscMessage("/wek/inputs");
  msg.add(tempVal); 
  //println(msg);
  oscP5.send(msg, dest);
 
 
}

void keyPressed() {
  int keyIndex = -1;
  if (key >= '1' && key <= '9') {
    currentClass = key - '1' + 1;
  }
}

void sendOsc(float hr) {
   OscMessage msg = new OscMessage("/wek/inputs");
  msg.add(hr); 
  //println(msg);
  oscP5.send(msg, dest1);
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 println(theOscMessage);
 println(theOscMessage.get(0).floatValue());
 println(theOscMessage.get(1).floatValue());
 
 
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    if(theOscMessage.checkTypetag("f")) {
      float f = theOscMessage.get(0).floatValue();
      colorLight((int)f);
      
    }
    if(theOscMessage.checkTypetag("ff")) {
      float f1 = theOscMessage.get(0).floatValue();
      float f2 = theOscMessage.get(1).floatValue();
      if (f1<f2) {
        print("here1");
       currentHue = 0;
      }
      else {
        print("here2");
        currentHue = 200;
      }
      
      
    }
  }
  
}

void colorLight(int c){
  if(c==1) {
    arduino.digitalWrite(blueLED,1);
    arduino.digitalWrite(redLED,0);
  }
  
  else if(c==2){
    arduino.digitalWrite(blueLED,0);
    arduino.digitalWrite(redLED,1);
  }
}