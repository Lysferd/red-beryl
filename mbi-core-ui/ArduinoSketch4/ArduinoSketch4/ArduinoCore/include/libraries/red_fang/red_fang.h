/*
	red_fang.h - Biblioteca criada com a função de assistir na programação do medidor de bioimpedancia
	Criado por Vitor H. Cardoso. 02 de março, 2018
*/

#ifndef red_fang_h
#define red_fang_h

#if ARDUINO >= 100
  #include <Arduino.h>
#else
  #include <WProgram.h>
  #include <pins_arduino.h>
  #include <WConstants.h>
#endif
#include <leituras.h>
#include <EEPROM.h>
#include <red_beryl.h>

class red_fang
{
	private:
		bool _Get;
		bool _Req;	
		bool _complex;
		bool _isBeingUsed;
		long _freq;
		int _num;
	public:
		red_fang();
		red_beryl *beryl;
		void ler_serial();
		void check_string(char str[]);
		void serialEnviar(char message[]);
		bool deletaLeitura(int delPos);
		bool serialLeitura(leitura lt, int i);
		bool getComplex(leitura lt, int n);
		bool get(int n, bool complex);
		bool isBeingUsed();
};



#endif