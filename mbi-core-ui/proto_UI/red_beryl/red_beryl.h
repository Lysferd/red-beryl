/*
	red_beryl.h - Biblioteca criada com a função de assistir na programação do medidor de bioimpedancia
	Criado por Vitor H. Cardoso. 20 de fevereiro, 2018
*/

#ifndef red_beryl_h
#define red_beryl_h

#if ARDUINO >= 100
  #include <Arduino.h>
#else
  #include <WProgram.h>
  #include <pins_arduino.h>
  #include <WConstants.h>
#endif

#include <Adafruit_SSD1306.h>
#include <Adafruit_GFX.h>
#include <leituras.h>
#include <red_crystal.h>
#include <red_quartz.h>


#define lineSize 8
	
		
class red_beryl
{
	private:
		int _pinUP;
		int	_pinDOWN;
		int _pinYES;
		int _pinNO;
		int _pinBAT;
		
		bool _up;
		bool _down;
		bool _yes;
		bool _no;
		
		Adafruit_SSD1306 display;
		leituras leitura0;
		red_crystal c;
    
	public:
		
		red_beryl();
		
		int getBatteryPct();
		void upperBar();
		void checarPin();
		
		void menu();
		bool menu_leitura();
		bool menu_sinc();
		bool menu_ajuste();
		bool nova_leitura();
		bool historico();
		bool relogio();
};

#endif
