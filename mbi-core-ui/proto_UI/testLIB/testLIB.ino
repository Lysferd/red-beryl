#include <red_beryl.h>
#include <red_fang.h>

red_beryl *rb;
red_fang fang;

void setup() {
  // put your setup code here, to run once:
  
  Serial.begin(9600); 
  rb = new red_beryl();
  fang.beryl = rb;
  //fang.check_string("BAT");
}

void loop() {
  // put your main code here, to run repeatedly:
  fang.ler_serial();
  rb->display.clearDisplay();
  rb->clock.checkTime();
  rb->checarPin();
  rb->menu();
  rb->upperBar();
  rb->display.display();
  delay(1);
}
