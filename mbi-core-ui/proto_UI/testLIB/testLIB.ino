#include <red_beryl.h>

red_beryl *rb;

void setup() {
  // put your setup code here, to run once:
  
  Serial.begin(9600);  

  rb = new red_beryl();
}

void loop() {
  // put your main code here, to run repeatedly:
  rb->display.clearDisplay();
  rb->clock.checkTime();
  
  rb->checarPin();
  rb->menu();
  rb->upperBar();
  rb->display.display();
  delay(1);
}
