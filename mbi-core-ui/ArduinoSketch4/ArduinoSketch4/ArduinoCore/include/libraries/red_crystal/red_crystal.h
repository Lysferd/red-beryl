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

#define START_FREQ  (50000) 				// frequencia inicial padrão.
#define FREQ_INCR   (START_FREQ/100) 		// incremento de frequencia padrão.
#define NUM_INCR    (10)  					// numero padrão de incrementos.
#define REF_RESIST  (996.50) 				// valor de referencia de resistor.
#define CAL_VAL		(1000)					// diferença entre os valores de calibração inicial
#define NUM_CAL		((100000-5000)/CAL_VAL)	// numero de valores de calibração.


class red_crystal
{
	private:
		AD5933 AD;
		leitura leitura1;
		
		float gain[NUM_INCR+1];  // vetor double para conter o valor de ganho.
		
		double calibP[NUM_CAL+1];		// vetor double para conter os valores de phase iniciais.
		float calibG[NUM_CAL+1];		// vetor float para conter os valores de ganho iniciais.
		
		double phase[NUM_INCR+1];  // vetor double para conter o valor de fase.
		double medReal, medImag; //variaveis int para receber os valores médios dos vetores.
		double arrayR[11], arrayJ[11];
		unsigned long _freq;
		
		int _range;
		int _pinD7;
	public:
		red_crystal();
		void init();
		
		
		bool reset();
		bool initialConfig();
		bool configurar(long f);
		bool lerAD(int point, leitura &l);
		double temperatura();
		
		bool setRange(int range);
		int getRange();
};

#endif