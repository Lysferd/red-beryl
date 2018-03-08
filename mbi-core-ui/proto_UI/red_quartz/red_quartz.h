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
		int _segundo;
		int _minuto;
		int _hora;
		int _dia;
		int _mes;
		int _ano;
	public:
		DS3231 time;
		red_quartz();
		
		int segundo();
		int minuto();
		int hora();
		int dia();
		int mes();
		int ano();		
		
		char* data_hora(bool completo);
		
		void checkTime();
		
		bool set_segundo(int s);
		bool set_minuto(int m);
		bool set_hora(int h);
		bool set_dia(int d, int m);
		bool set_mes(int m);
		bool set_ano(int a);
		
		bool testa_segundo(int s);
		bool testa_minuto(int min);
		bool testa_hora(int hr);
		bool testa_dia(int d, int mn);
		bool testa_mes(int mn);
		bool testa_ano(int a);
};

#endif