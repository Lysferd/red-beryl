#include <Wire.h>
#include <Math.h>

#define AD5933_ADDR     (0x0D)
#define CTRL_REG1       (0x80)

void setup() {
  Serial.begin(9600);
  Wire.begin();
  Wire.setClock(400000);

  Serial.println("Testing temperature");

  byte val, add, gen;
  val &= 0x0F;
  val |= 0b10010000;
  add = 0x80;
  gen = 0x0D;

  Wire.beginTransmission(AD5933_ADDR);

  Wire.write(CTRL_REG1);

  Wire.write(val);

  Wire.endTransmission();

  delay(100);
  
  Wire.beginTransmission(0x0D);
  Wire.write(0xB0);
  Wire.write(0x92);
  Wire.endTransmission();

delay(100);
  
  byte temp1,temp2;

  Wire.requestFrom(0x0D, 1);
  if(Wire.available())
  {
    temp1=Wire.read();
  }

delay(100);
  Wire.beginTransmission(0x0D);
  Wire.write(0xb0);
  Wire.write(0x93);
  Wire.endTransmission();
delay(100);

  Wire.requestFrom(0x0D,1);

  if(Wire.available())
  {
    temp2=Wire.read();
  }
delay(100);
  double rawTempVal = (temp1 << 8 | temp2) & 0x1FFF;

  //if(temp1 & (1<<5)==0)
  {
    rawTempVal = rawTempVal/32.0;
  }
  //else
    {
    //  rawTempVal = (rawTempVal - 16384)/32.0;
    }

  Serial.println(rawTempVal);
  // put your setup code here, to run once:

}

void loop() {

  byte val, add, gen;
  val &= 0x0F;
  val |= 0b10010000;
  add = 0x80;
  gen = 0x0D;

  Wire.beginTransmission(AD5933_ADDR);

  Wire.write(CTRL_REG1);

  Wire.write(val);

  Wire.endTransmission();

  delay(100);
  
  Wire.beginTransmission(0x0D);
  Wire.write(0xB0);
  Wire.write(0x92);
  Wire.endTransmission();

delay(100);
  
  byte temp1,temp2;

  Wire.requestFrom(0x0D, 1);
  if(Wire.available())
  {
    temp1=Wire.read();
  }

delay(100);
  Wire.beginTransmission(0x0D);
  Wire.write(0xb0);
  Wire.write(0x93);
  Wire.endTransmission();
delay(100);

  Wire.requestFrom(0x0D,1);

  if(Wire.available())
  {
    temp2=Wire.read();
  }
delay(100);
  double rawTempVal = (temp1 << 8 | temp2) & 0x1FFF;

  //if(temp1 & (1<<5)==0)
  {
    rawTempVal = rawTempVal/32.0;
  }
  //else
    {
    //  rawTempVal = (rawTempVal - 16384)/32.0;
    }

  Serial.println(rawTempVal);
}
