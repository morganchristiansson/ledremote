#include <OctoWS2811.h>

const int ledsPerStrip = 150;
#define NUM_PIXELS 600
#define NUM_SUBPIXELS NUM_PIXELS*3

DMAMEM int displayMemory[ledsPerStrip*6];
int drawingMemory[ledsPerStrip*6];

const int config = WS2811_GRB | WS2811_800kHz;
OctoWS2811 leds(ledsPerStrip, displayMemory, drawingMemory, config);

uint8_t has_error=0;
int readbyte;
int offset;

void setup() {
  leds.begin();
  //leds.show();

  Serial.begin(1000000);
  Serial.println(F("ledremote2 boot"));

  for(int i=0; i<NUM_PIXELS; i++) {
    leds.setPixel(i, 255, 255, 255);
  }
  leds.show();
}
unsigned long nextBeat = 0;

void loop() {
  if(nextBeat < millis()) {
    Serial.print("R");
    Serial.flush();
    nextBeat = millis()+500;
  }
  if (Serial.read() == '\n') {
    while(!Serial.available());
    readbyte = Serial.read();

    process_cmd:
    nextBeat = millis()+100;
    switch(readbyte) {
      case '\0':
        {
          has_error=0;
          int r,g,b;
          for(int i=0; i<NUM_SUBPIXELS; i++) {
            while(!Serial.available());
            if((readbyte = Serial.read()) == '\n') {
              while(!Serial.available());
              if((readbyte = Serial.read()) != '\n') {
                Serial.print("G");
                goto process_cmd;
              }
            }
            switch(i % 3) {
              case 0:
                r = readbyte;
                break;
              case 1:
                g = readbyte;
                break;
              case 2:
                b = readbyte;
                leds.setPixel(i / 3, r, g, b);
                break;
            }
          }
          leds.show();
          Serial.print("_");
        }
        break;
      case -1:
        break;
      default:
        Serial.print("F");
        Serial.println(readbyte);
        break;
    }
  } else {
    if(!has_error) {
      has_error=1;
      Serial.print("E"); Serial.println(readbyte);
    }
  }
}

