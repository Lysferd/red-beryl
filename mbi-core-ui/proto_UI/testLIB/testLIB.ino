#include <red_beryl.h>
#include <red_fang.h>
#include <Wire.h>

red_beryl *rb;
red_fang fang;
///////////////////////////////////   Codigo do memoryFree para fins de depuração.
#ifdef __arm__
// should use uinstd.h to define sbrk but Due causes a conflict
extern "C" char* sbrk(int incr);
#else  // __ARM__
extern char *__brkval;
#endif  // __arm__

int freeMemory() {
  char top;
#ifdef __arm__
  return &top - reinterpret_cast<char*>(sbrk(0));
#elif defined(CORE_TEENSY) || (ARDUINO > 103 && ARDUINO != 151)
  return &top - __brkval;
#else  // __arm__
  return __brkval ? &top - __brkval : &top - __malloc_heap_start;
#endif  // __arm__
}
///////////////////////////////////

void setup() {
  // put your setup code here, to run once:
  
  Serial.begin(19200); 
  Wire.begin();
  
  rb = new red_beryl();
  fang.beryl = rb;
  //fang.check_string("BAT");
  
  Serial.println("Iniciou!");
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
  delay(10);
  //Serial.println(freeMemory());
}


