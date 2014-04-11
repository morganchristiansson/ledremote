#include <Adafruit_NeoPixel.h>

#define PIN 13

// Parameter 1 = number of pixels in strip
// Parameter 2 = Arduino pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
//   NEO_KHZ800  800 KHz bitstream (most NeoPixel products w/WS2812 LEDs)
//   NEO_KHZ400  400 KHz (classic 'v1' (not v2) FLORA pixels, WS2811 drivers)
//   NEO_GRB     Pixels are wired for GRB bitstream (most NeoPixel products)
//   NEO_RGB     Pixels are wired for RGB bitstream (v1 FLORA pixels, not v2)
Adafruit_NeoPixel strip = Adafruit_NeoPixel(500, PIN, NEO_GRB + NEO_KHZ800);
uint8_t has_error=0;
int readbyte;
uint8_t *pixels, *pixelsStart;

void setup() {
  strip.begin();
  //strip.show();

  Serial.begin(1000000);
  Serial.println(F("ledremote2 boot"));
  pixelsStart = strip.getPixels();
}
unsigned long nextBeat = 0;

void loop() {
  if(nextBeat < millis()) {
    Serial.print("R");
    Serial.flush();
    nextBeat = millis()+100;
  }
  if (Serial.read() == '\n') {
    nextBeat = millis()+100;
    while(!Serial.available());
    readbyte = Serial.read();
    process_cmd:
    switch(readbyte) {
      case '\0':
        {
          has_error=0;
          pixels = pixelsStart;
          for(int i=0; i<1500; i++) {
            while(!Serial.available());
            if((readbyte = Serial.read()) == '\n') {
              while(!Serial.available());
              if((readbyte = Serial.read()) != '\n') {
                Serial.print("G");
                goto process_cmd;
              }
            }
            *(pixels++) = (uint8_t)readbyte;
          }
          strip.show();
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
      Serial.println("E");
    }
  }
}

