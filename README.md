# smart_thermometer
Third Assignment for IML4HCI

This is a simple smart themometer that we are going to modify with a waterproof temperature sensor so we can help people only drink their drinks when they are the right temperature. The entire system uses an arduino so without tht it will be hard to replicate. I use the Standard Firmata on the ardunio and then processing to complete the communication over osc with wekinator. The arduino is communicating to the processing program via the serial port. The brief schematic for connecting the board is as follows

Blue LED: Digital Pin 5
Green LED: Digital Pin 6
Yellow LED: Digital Pin 8
Red LED: Digital Pin 9

The temperature sensor is connected to Analog Pin 0. 

Once you have this set up. Load the Standard Firmata on the Arduino and then start the wekinaotr project and the processing program. You can train the program for yourself in order for the temperature sensor be personalized to your drink temperature preferences.
