#include <red_quartz.h>

red_quartz *quartz;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  quartz = new red_quartz();
}

void loop() {
  // put your main code here, to run repeatedly:
  static int fakeMin=0;
  delay(300);
  if(quartz->test_minute(fakeMin)){
    Serial.print(fakeMin);
    Serial.println(" OK.");
    fakeMin++;
  }
  else{
    Serial.print(fakeMin);
    Serial.println(" -/-");
    fakeMin=0;
  }
  delay(300);
  quartz->test_minute(quartz->serial_minute());
  quartz->test_hour(quartz->serial_hour());
}
