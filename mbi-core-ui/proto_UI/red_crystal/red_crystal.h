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

#define START_FREQ  (50000) 			// frequencia inicial padrão.
#define FREQ_INCR   (START_FREQ/100) 	// incremento de frequencia padrão.
#define NUM_INCR    (10)  				// numero padrão de incrementos.
#define REF_RESIST  (10000) 			// valor de referencia de resistor.


class red_crystal
{
	private:
		AD5933 AD;
		leitura leitura1;
		
		double gain[NUM_INCR+1];  // vetor double para conter o valor de ganho.
		int phase[NUM_INCR+1];  // vetor int para conter o valor de fase.
		double medReal, medImag; //variaveis int para receber os valores médios dos vetores.
		double arrayR[11], arrayJ[11];
		long _freq;
		
	public:
		red_crystal();
		void init();
		
		
		bool reset();
		bool initialConfig();
		bool configurar(long f);
		leitura lerAD();
		double temperatura();
};

#endif