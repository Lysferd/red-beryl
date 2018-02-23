/*
	red_crystal.h - Biblioteca criada com a função de assistir na programação do medidor de bioimpedancia
	Criado por Vitor H. Cardoso. 23 de fevereiro, 2018
*/

#include "red_crystal.h"
#include <AD5933.h>
#include <Wire.h>
#include <leituras.h>

#define START_FREQ  (50000) 			// frequencia inicial padrão.
#define FREQ_INCR   (START_FREQ/100) 	// incremento de frequencia padrão.
#define NUM_INCR    (10)  				// numero padrão de incrementos.
#define REF_RESIST  (10000) 			// valor de referencia de resistor.

red_crystal::red_crystal()
{
	Serial.println("Construtor basico red_crystal utilizado.");
	leitura1 = {1,1,1,1,1,1,1,1};

}