/*
	red_beryl.h - Biblioteca criada com a função de assistir na programação do medidor de bioimpedancia
	Criado por Vitor H. Cardoso. 20 de fevereiro, 2018
*/

#include "red_beryl.h"
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define OLED_RESET 4

red_beryl::red_beryl(int pinUP, int pinDOWN, int pinYES, int pinNO)
{ 
  display = new Adafruit_SSD1306(OLED_RESET);
  
	_pinUP = pinUP;
	pinMode(_pinUP, INPUT);
	
	_pinDOWN = pinDOWN;
	pinMode(_pinDOWN, INPUT);
	
	_pinYES = pinYES;
	pinMode(_pinYES, INPUT);
	
	_pinNO = pinNO;
	pinMode(_pinNO, INPUT);
}

void red_beryl::checarPin()
{
	display->display();
	Serial.println("Listening...");
	static int tempButton = 0;    //botão temporario que vai receber o valor do ultimo botão apertado para impedir que a ação se repita.
	if(digitalRead(_pinUP)||digitalRead(_pinDOWN)||digitalRead(_pinYES)||digitalRead(_pinNO))
	{
		if(digitalRead(_pinUP) && tempButton != digitalRead(_pinUP)){
			tempButton = digitalRead(_pinUP);
			Serial.print("UP:");Serial.println(digitalRead(_pinUP));
			up();      
		}
		if(digitalRead(_pinDOWN) && tempButton != digitalRead(_pinDOWN)){
			tempButton = digitalRead(_pinDOWN);
			Serial.print("DOWN:");Serial.println(digitalRead(_pinDOWN));
			down();
		}
		if(digitalRead(_pinYES) && tempButton != digitalRead(_pinYES)){
			tempButton = digitalRead(_pinYES);
			Serial.print("YES:");Serial.println(digitalRead(_pinYES));
			yes();
		}
		if(digitalRead(_pinNO) && tempButton != digitalRead(_pinNO)){
			tempButton = digitalRead(_pinNO);
			Serial.print("NO:");Serial.println(digitalRead(_pinNO));
			no();
		}
    delay(10);
	}
	tempButton = 0;
}

void red_beryl::up()
{
	Serial.println("UP!!!!!!!!!!!!!!!!!!!");
	display->clearDisplay();
	display->fillScreen(BLACK);
	display->display();
	Serial.println("APAGADO!!!!");
	//_display->display();
}
void red_beryl::down()
{
	
}
void red_beryl::yes()
{
	
}
void red_beryl::no()
{
	
}
