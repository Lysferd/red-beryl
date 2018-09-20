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
#include <red_beryl.h>

#define lineSize 8
	
#define VERSION "1.0.0"	
		
class red_beryl
{
	private:
		int _pinUP;
		int	_pinDOWN;
		int _pinYES;
		int _pinNO;
		int _pinBAT;
		
		int _notificationType;
		int _pointGain;
		bool _up;
		bool _down;
		bool _yes;
		bool _no;
		
		bool persistentNotify;
		bool busyNotify;
		bool BLE;
		
	public:
		
		red_beryl();
		
		Adafruit_SSD1306 display;
		
		leitura leitura0;
		
		red_quartz clock;

		red_crystal crystal;
		
		void notification();
		bool notificationTimer(bool inUse);
		
		int getBatteryPct();
		void upperBar();
		void checarPin();
		
		void adResetTest();
		
		void menu();
		bool menu_leitura();
		bool menu_sinc();
		bool menu_ajuste();
		bool nova_leitura();
		bool historico();
		bool relogio();
		bool deletaLeitura(int delPos);
		
		int getPoint();
		
		bool menu_range();
		bool menu_point();
		bool menu_aviso();
		bool menu_historico();
		
		void imprimeEscolha(int i, int l, leitura lt, bool s);
		void scrollBar(int j);
		
		void warning(const char *s);
		void warning(const char *s, const char *s2);
};

#endif
