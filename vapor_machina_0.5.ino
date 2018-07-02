#include <SPI.h>

SPISettings ltc2620(50000000, MSBFIRST, SPI_MODE3); //settings specific to the ltc2620CGN#PBF octal DAC

const int slavePin = 53; //tells SPI slave device (DAC) to listen for input (active LOW)
const int clrPin = 7; //clears all DAC registers and stops output (active LOW)

byte dacAddress = 0b00000000; //first 4 bits are the operation type, second 4 bits are DAC identity (see datasheet)
byte dacAddress_2 = 0b00000001;
byte dacAddress_3 = 0b00000010;
byte dacAddress_4 = 0b00000011;
byte dacLoad = 0b00011111;
byte dacUnload = 0b00101111;

int TriggerPin = 13;
int Triggered = 0;
int LastStatus = 0;
int Connected = 0;
int LowByte = 0;
int HighByte = 0;
long IntervalStartTime = 0;
int inByte = 0;
int inByte2 = 0;

// Arrays for storing the initialization variables, 200 different transitions
unsigned int StimTimeMs[200]; // time in which stimulation is to be applied, 2 bytes in ms
byte digital_out_1_8; // digital outputs to receive appropiate byte
byte digital_out_9_16; // digital outputs
byte digital_out_17_24; // digital outputs
byte digital_out_25_32; // digital outputs
unsigned long digital_out[200];
unsigned int mass_flow_1[200]; // mass flow controller 1 analog values 
unsigned int mass_flow_2[200]; // mass flow controller 2 analog values 
unsigned int mass_flow_3[200]; // mass flow controller 3 analog values
unsigned int mass_flow_4[200]; // mass flow controller 4 analog values
word stimulation_total_steps; // Total number of valve outputs and mass flow states 
word stimulation_this_step; // Current step in which the stimulation is

int ValvePins[] = {18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37,
38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50};

boolean ShutDown = false;


//Variables for keeping time
unsigned long start_train_ms;
unsigned long ellapsed_time;
unsigned long time_to_stop;


void setup() {    
  
  pinMode(slavePin, OUTPUT);
  pinMode(clrPin, OUTPUT);
  pinMode(TriggerPin, INPUT);
  //Set the pins that control valves as outputs
  int valve_pins=32; 
  for (valve_pins = 0; valve_pins < 33; valve_pins++) { // Channel 0 and 1 are the channels for the USB connection. Do not touch! 
    pinMode(ValvePins[valve_pins], OUTPUT); 
  }

  digitalWrite(ValvePins[31], HIGH);
  
  SPI.begin(); 
  Serial.begin(115200);
  IntervalStartTime = micros();

}

void loop()                     
{
  if (Serial.available() > 0) {
    inByte = Serial.read();
    while (Serial.available() == 0) {
    }
    inByte2 = Serial.read();
    switch (inByte) {

    case 51: // This is where I will load my matrix of stimulation
      {
        LowByte = inByte2;
        while (Serial.available() == 0) {
        }
        HighByte = Serial.read();
        stimulation_total_steps= word(HighByte, LowByte); // this is the number of transitions
        for ( stimulation_this_step = 0 ;  stimulation_this_step < stimulation_total_steps ; stimulation_this_step++) {
          // Read the timing of the stimulations
          while (Serial.available() == 0) {
          }
          HighByte=Serial.read(); // time in which stimulation is to be applied, 2 bytes in ms
          while (Serial.available() == 0) {
          }
          LowByte=Serial.read(); // time in which stimulation is to be applied, 2 bytes in ms
          StimTimeMs[stimulation_this_step]=word(HighByte, LowByte);

          // Read the state of 32 bits to control the valves
          while (Serial.available() == 0) {
          }
          digital_out_1_8=Serial.read();
          while (Serial.available() == 0) {
          }
          digital_out_9_16=Serial.read();
          while (Serial.available() == 0) {
          }
          digital_out_17_24=Serial.read();
          while (Serial.available() == 0) {
          }
          digital_out_25_32=Serial.read();
          //digital_out[stimulation_this_step]=16777216*digital_out_1_8 + 65536*digital_out_9_16 + 256*digital_out_17_24 + digital_out_25_32;
          digital_out[stimulation_this_step]=long(16777216)*digital_out_1_8 + long(65536)*digital_out_9_16 + long(256)*digital_out_17_24 + digital_out_25_32;

          //Read the Analog Value for the Mass Flow Controllers

          //The data code for the DAC is most significant bit first (MSB) of a 16-bit word,
          //so the 12-bit value needs to be shifted 4 places to the left in order to place
          //the 4 "don't care" bits at the end of the reading frame

          //Mass Flow 1
          while (Serial.available() == 0) {
          }
          HighByte=Serial.read(); // time in which stimulation is to be applied, 2 bytes in ms
          while (Serial.available() == 0) {
          }
          LowByte=Serial.read(); // time in which stimulation is to be applied, 2 bytes in ms
          mass_flow_1[stimulation_this_step]=(word(HighByte, LowByte));
          //Mass Flow 2
          while (Serial.available() == 0) {
          }
          HighByte=Serial.read(); // time in which stimulation is to be applied, 2 bytes in ms
          while (Serial.available() == 0) {
          }
          LowByte=Serial.read(); // time in which stimulation is to be applied, 2 bytes in ms
          mass_flow_2[stimulation_this_step]=(word(HighByte, LowByte));
          //Mass Flow 3
          while (Serial.available() == 0) {
          }
          HighByte=Serial.read(); // time in which stimulation is to be applied, 2 bytes in ms
          while (Serial.available() == 0) {
          }
          LowByte=Serial.read(); // time in which stimulation is to be applied, 2 bytes in ms
          mass_flow_3[stimulation_this_step]=(word(HighByte, LowByte));
          //Mass Flow 4
          while (Serial.available() == 0) {
          }
          HighByte=Serial.read(); // time in which stimulation is to be applied, 2 bytes in ms
          while (Serial.available() == 0) {
          }
          LowByte=Serial.read(); // time in which stimulation is to be applied, 2 bytes in ms
          mass_flow_4[stimulation_this_step]=(word(HighByte, LowByte));
        }
      }

      Serial.flush();
      break;

      case 59: 
      Serial.print(5); 
      Serial.flush();
      //Rest all the variables
      Triggered = LOW;
      LastStatus = HIGH;
      // Zero DAC
      digitalWrite(clrPin, LOW);
      // Close all the valves
      write_Valve_state(0L);
      // Open cleaning valves
      digitalWrite(ValvePins[31],HIGH);
      break; 
    }

  }

  Triggered = digitalRead(TriggerPin);
  if (Triggered == HIGH && LastStatus == LOW) { 
    start_train_ms = millis();
    time_to_stop = start_train_ms;
    LastStatus = HIGH;
    stimulation_this_step = 0;
    while((stimulation_this_step < stimulation_total_steps)&&(LastStatus == HIGH) ) {// Stimulation is done during the while loop 
      write_Valve_state(digital_out[stimulation_this_step]);
      write_DA_converter(mass_flow_1[stimulation_this_step], mass_flow_2[stimulation_this_step], mass_flow_3[stimulation_this_step], mass_flow_4[stimulation_this_step]);
      delay(StimTimeMs[stimulation_this_step]);
      time_to_stop=time_to_stop+StimTimeMs[stimulation_this_step];
      do {
        Triggered = digitalRead(TriggerPin);
        ellapsed_time = millis();
      }
      while((ellapsed_time<time_to_stop)&&(LastStatus == HIGH));  
      stimulation_this_step++;
      
    }
    
    // Zero DAC
    digitalWrite(clrPin, LOW);
    // Close all the valves
    write_Valve_state(0L);
    // Open cleaning valves
    digitalWrite(ValvePins[31],HIGH);
    
  }
  
  if ((Triggered == LOW ) && (LastStatus == HIGH)) {
    LastStatus = LOW;
    // Zero DAC
    digitalWrite(clrPin, LOW);
    // Close all the valves
    write_Valve_state(0L);
    // Open cleaning valves
    digitalWrite(ValvePins[31],HIGH);
  
  }
}
//Function to write into the 4 DA converters
void write_DA_converter(word mass_flow_1, word mass_flow_2, word mass_flow_3, word mass_flow_4) 
{
  
  digitalWrite(clrPin, HIGH); //open input/DAC registers for writing

  //load input register on DAC_A
  SPI.beginTransaction(ltc2620);
  digitalWrite(slavePin, LOW);
  SPI.transfer(dacAddress);
  SPI.transfer(highByte(mass_flow_1)); //left-most byte of 16-bit data word
  SPI.transfer(lowByte(mass_flow_1));
  digitalWrite(slavePin, HIGH);
  SPI.endTransaction();

  //load input register on DAC_B
  SPI.beginTransaction(ltc2620);
  digitalWrite(slavePin, LOW);
  SPI.transfer(dacAddress_2);
  SPI.transfer(highByte(mass_flow_2));
  SPI.transfer(lowByte(mass_flow_2));
  digitalWrite(slavePin, HIGH);
  SPI.endTransaction();

    //load input register on DAC_C
  SPI.beginTransaction(ltc2620);
  digitalWrite(slavePin, LOW);
  SPI.transfer(dacAddress_3);
  SPI.transfer(highByte(mass_flow_3));
  SPI.transfer(lowByte(mass_flow_3));
  digitalWrite(slavePin, HIGH);
  SPI.endTransaction();

    //load input register on DAC_D
  SPI.beginTransaction(ltc2620);
  digitalWrite(slavePin, LOW);
  SPI.transfer(dacAddress_4);
  SPI.transfer(highByte(mass_flow_4));
  SPI.transfer(lowByte(mass_flow_4));
  digitalWrite(slavePin, HIGH);
  SPI.endTransaction();

  //shift all data in input registers to their respective DAC registers and start voltage output
  SPI.beginTransaction(ltc2620);
  digitalWrite(slavePin, LOW);
  SPI.transfer(dacLoad);
  SPI.transfer(0);
  SPI.transfer(0);
  digitalWrite(slavePin, HIGH);
  SPI.endTransaction(); 
}

// Function to write the 32 values received into the output pins
void write_Valve_state(long valve_out) 
{  
  int counter = 34;
  boolean da_bit_to_write;
  for (counter = 33; counter >= 0 ; counter--) {
    da_bit_to_write=bitRead(valve_out, counter) ;
    digitalWrite(ValvePins[counter],da_bit_to_write);
  }
}




























