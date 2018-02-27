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
	Wire.setClock(400000);  //Definir a velocidade de clock do Wire para conversar com a AD.
	leitura1 = {1,1,1,1,1,1,1,1};
	if(initialConfig()){
		Serial.println("Configuração inicial da AD5933 concluida.");
	}
}
bool red_crystal::initialConfig()
{
	if(!AD5933::reset()){
		Serial.println("ERRO: Reset falhou!");
		return false;
	}
	if(!AD5933::setInternalClock(true)){
		Serial.println("ERRO: SetInternalClock falhou!");
		return false;
	}
	if(!AD5933::setStartFrequency(START_FREQ*0.95)){
		Serial.println("ERRO: SetStartFrequency falhou!");
		return false
	}
	if(!AD5933::setIncrementFrequency(FREQ_INCR)){
		Serial.println("ERRO: SetIncrementFrequency falhou!");
		return false;
	}
	if(!AD5933::setNumberIncrements(NUM_INCR)){
		Serial.println("ERRO: SetNumberIncrements falhou!");
		return false;
	}
	if(!AD5933::setPGAGain(PGA_GAIN_X1)){
		Serial.println("ERRO: SetPGAGain falhou!");
		return false
	}
	return true;
}
bool red_crystal::configurar(long f)
{
	if(!AD5933::reset()){
		Serial.println("ERRO: Reset falhou!");
		return false;
	}
	if(!AD5933::setInternalClock(true)){
		Serial.println("ERRO: SetInternalClock falhou!");
		return false;
	}
	if(!AD5933::setStartFrequency(f*0.95)){
		Serial.println("ERRO: SetStartFrequency falhou!");
		return false
	}
	if(!AD5933::setIncrementFrequency(f/100)){
		Serial.println("ERRO: SetIncrementFrequency falhou!");
		return false;
	}
	if(!AD5933::setNumberIncrements(NUM_INCR)){
		Serial.println("ERRO: SetNumberIncrements falhou!");
		return false;
	}
	if(!AD5933::setPGAGain(PGA_GAIN_X1)){
		Serial.println("ERRO: SetPGAGain falhou!");
		return false
	}
	return true;
}


leituras red_crystal::lerAD()
{
	if(!(AD5933::setPowerMode(POWER_STANDBY) 	&&
			AD5933::setControlMode(CTRL_INIT_START_FREQ)	&&
				AD5933::setControlMode(CTRL_START_FREQ_SWEEP) ))
				{
					Serial.print("Falhou em inicializar SWEEP.");
					return false;
				}
	
	long cfreq=f*0.95;
	medReal=0;
	medImag=0;
	double real, imag;
	leituras leiTemp;
	while((AD5933::readStatusRegister() & STATUS_SWEEP_DONE) != STATUS_SWEEP_DONE){
		if(!AD5933::getComplexData(&real, &imag)){
			Serial.println("Falhou em adquirir DATA de frequencia.");
		}
		Serial.print(cfreq/1000);
		Serial.print(": R=");
		Serial.print(real);

		medReal+=real;
    
		Serial.print("/I=");
		Serial.print(imag);

		medImag+=imag;

		double magnitude = sqrt(pow(real, 2) + pow(imag, 2));
		double impedance = 1/(magnitude*gain[i]);
		Serial.print("  |Z|=");
		Serial.println(impedance);

		i++;
		cfreq +=inc;
		AD5933::setControlMode(CTRL_INCREMENT_FREQ);
	}
	medReal/=(NUM_INCR+1);
	medImag/=(NUM_INCR+1);
  
	Serial.println("Completo!");
	Serial.print("MedReal=");
	Serial.println(medReal);
	Serial.print("MedImag=");
	Serial.println(medImag);
	leiTemp={f, medReal, medImag};

	//Serial.print("EEPROM address 0:");Serial.println(EEPROM.read(0));
  
    // Set AD5933 power mode to standby when finished
	if (!AD5933::setPowerMode(POWER_STANDBY)){
		Serial.println("Could not set to standby...");
	}
	return leiTemp;
}