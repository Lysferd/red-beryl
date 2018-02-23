/*
	red_crystal.h - Biblioteca criada com a função de assistir na programação do medidor de bioimpedancia
	Criado por Vitor H. Cardoso. 23 de fevereiro, 2018
*/

#ifndef red_crystal_h
#define red_crystal_h

#if ARDUINO >= 100
  #include <Arduino.h>
#else
  #include <WProgram.h>
  #include <pins_arduino.h>
  #include <WConstants.h>
#endif
#include <AD5933.h>
#include <leituras.h>

class red_crystal
{
	private:
		AD5933 ad;
		leituras leitura1;
		
	public:
		red_crystal();
		
};

#endif