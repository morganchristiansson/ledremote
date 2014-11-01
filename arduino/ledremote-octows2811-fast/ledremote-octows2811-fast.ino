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
  Serial.setTimeout(100);
  Serial.println(F("ledremote3 boot"));

  for(int i=0; i<NUM_PIXELS; i++) {
    leds.setPixel(i, 255, 255, 255);
  }
  leds.show();
}

char readBuffer[NUM_SUBPIXELS];

void loop() {
  while(!Serial.available()) {
    delay(1);
  }
  if(Serial.readBytes(readBuffer, NUM_SUBPIXELS)) {
    for(int i=0; i<NUM_PIXELS; i++) {
      char *p = &readBuffer[i*3];
      leds.setPixel(i, *p++, *p++, *p++);
    }
    leds.show();
  } else {
    Serial.print("E");
  }
}

