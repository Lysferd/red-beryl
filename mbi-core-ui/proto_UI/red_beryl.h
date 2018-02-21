/*
	red_beryl.h - Biblioteca criada com a função de assistir na programação do medidor de bioimpedancia
	Criado por Vitor H. Cardoso. 20 de fevereiro, 2018
*/

#ifndef red_beryl_h
#define red_beryl_h

#if ARDUINO >= 100
  #include "Arduino.h"
#else
  #include "WProgram.h"
  #include "pins_arduino.h"
  #include "WConstants.h"
#endif

#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

class red_beryl
{
	public:
		red_beryl(int pinUP, int pinDOWN, int pinYES, int pinNO);
		void up();
		void down();
		void yes();
		void no();
		void checarPin();
   
    Adafruit_SSD1306 *display;
    
	private:
		int _pinUP;
		int	_pinDOWN;
		int _pinYES;
		int _pinNO;
    

};

#endif
