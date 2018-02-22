/*
	red_quartz.h - Biblioteca criada com a função de testar a funcionalidade do RTC no mbi
	Criado por Vitor H. Cardoso. 22 de fevereiro, 2018
*/

#ifndef	red_quartz_h
#define red_quartz_h

#if ARDUINO >= 100
  #include <Arduino.h>
#else
  #include <WProgram.h>
  #include <pins_arduino.h>
  #include <WConstants.h>
#endif
#include <DS3231.h>

class red_quartz
{
	private:
		int _minute;
		int _hour;
	public:
		DS3231 time;
		red_quartz();
		int serial_minute();
		int serial_hour();
		bool test_minute(int min);
		bool test_hour(int hr);
};

#endif