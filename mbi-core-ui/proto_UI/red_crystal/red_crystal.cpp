/*
	red_crystal.h - Biblioteca criada com a função de assistir na programação do medidor de bioimpedancia
	Criado por Vitor H. Cardoso. 23 de fevereiro, 2018
*/

#include "red_crystal.h"
#include <AD5933.h>
#include <Wire.h>
#include <leituras.h>
#include <Math.h>

#define START_FREQ  (50000) 			// frequencia inicial padrão.
#define FREQ_INCR   (START_FREQ/100) 	// incremento de frequencia padrão.
#define NUM_INCR    (10)  				// numero padrão de incrementos.
#define REF_RESIST  (996.50) 			// valor de referencia de resistor.
//#define REF_RESIST  (762.61) 			// valor de referencia de resistor.
#define CAL_VAL		(2200)					// diferença entre os valores de calibração inicial
#define NUM_CAL		((100000-5000)/CAL_VAL)	// numero de valores de calibração.

#define PI (3.14159265)

red_crystal::red_crystal()
{
	Serial.println("Construtor basico red_crystal utilizado.");
}

void red_crystal::init()
{
	Serial.println("Inicializador red_crystal utilizado.");
	Wire.setClock(400000);  //Definir a velocidade de clock do Wire para conversar com a AD.
	leitura1 = {1};
	_pinD7 = 7;
	pinMode(_pinD7, OUTPUT);
	digitalWrite(_pinD7, LOW);
	_range = 1;
	if(initialConfig()){
		Serial.println("Configuração inicial da AD5933 concluida.");
	}
	else
	{
		Serial.println("Erro ao configurar a AD5933.");
	}
}


bool red_crystal::reset()
{
	if(AD5933::reset())
	{
		return true;
	}
	else
	{
		Serial.println("AD-reset falhou.");
		return false;
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
		return false;
	}
	_freq=START_FREQ;
	if(!AD5933::setIncrementFrequency(FREQ_INCR)){
		Serial.println("ERRO: SetIncrementFrequency falhou!");
		return false;
	}
	if(!AD5933::setNumberIncrements(NUM_INCR)){
		Serial.println("ERRO: SetNumberIncrements falhou!");
		return false;
	}
	if(!AD5933::setRange(_range)){
		Serial.println("ERR: SetRange falhou!");
		return false;
	}
	if(!AD5933::setPGAGain(PGA_GAIN_X1)){
		Serial.println("ERRO: SetPGAGain falhou!");
		return false;
	}
	if(!AD5933::calibrate(gain, phase, REF_RESIST, (NUM_INCR+1)))
    {
      Serial.println("ERRO: Calibração falhou!");
	  return false;
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
		return false;
	}
	_freq=f;
	if(!AD5933::setIncrementFrequency(f/100)){
		Serial.println("ERRO: SetIncrementFrequency falhou!");
		return false;
	}
	if(!AD5933::setNumberIncrements(NUM_INCR)){
		Serial.println("ERRO: SetNumberIncrements falhou!");
		return false;
	}
	if(!AD5933::setRange(_range)){
		Serial.println("ERR: SetRange falhou!");
		return false;
	}
	if(!AD5933::setPGAGain(PGA_GAIN_X1)){
		Serial.println("ERRO: SetPGAGain falhou!");
		return false;
	}
	
	digitalWrite(_pinD7, LOW);
	delay(10);
	if(!AD5933::calibrate(gain, phase, REF_RESIST, (NUM_INCR+1)))
    {
      Serial.println("ERRO: Calibração falhou!");
	  return false;
    }
	else
	{
		for(int i=0;i<11;i++)
		{
			Serial.print("gain=");
			Serial.println(gain[i], 15);
		}
	}
	delay(10);

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
		return false;
	}
	_freq=f;
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
		return false;
	}
	
	return true;
}


leitura red_crystal::lerAD(int point)
{
	digitalWrite(_pinD7, HIGH);
	if(!(AD5933::setPowerMode(POWER_STANDBY) 	&&
			AD5933::setControlMode(CTRL_INIT_START_FREQ)	&&
				AD5933::setControlMode(CTRL_START_FREQ_SWEEP) ))
				{
					Serial.print("Falhou em inicializar SWEEP.");
					return;
				}
	
	long cfreq=_freq*0.95;
	long inc = _freq/100;
	medReal=0;
	medImag=0;
	
	int real, imag;
	int i=0;
	while((AD5933::readStatusRegister() & STATUS_SWEEP_DONE) != STATUS_SWEEP_DONE){
		if(!AD5933::getComplexData(&real, &imag)){
			Serial.println("Falhou em adquirir DATA de frequencia.");
		}
		Serial.print(cfreq);

		long tempPow = pow(real, 2) + pow(imag, 2);
		double magnitude = sqrt(tempPow);
		
		float tempImp = magnitude*gain[i];
		double impedance = 1.0/tempImp;
		
		double ph = atan2(imag, real);
		
		Serial.print("imag/real=phase == ");
		Serial.print(imag);
		Serial.print("/");
		Serial.print(real);
		Serial.print("=");
		Serial.println((double) imag/real);
	
		Serial.print(ph);
		Serial.print(":");
		Serial.println(ph * 180/PI);
		
		ph -= phase[i];
		Serial.print("M=");
		Serial.println(magnitude);
		Serial.print("|Z|=");
		Serial.println(impedance);
		Serial.print("G=");
		Serial.println(gain[i], 15);
		Serial.print("phase:");
		Serial.println(ph  * 180.00 / PI);
		
		Serial.print("R=");
		double r = (double) impedance * cos(ph);
		Serial.print(r);
		
		Serial.print("|I=");
		double j = (double) impedance * sin(ph);
		Serial.println(j);
		
		medReal+=r;

		medImag+=j;
		
		arrayR[i] = r;
		arrayJ[i] = j;
		
		i++;
		cfreq +=inc;
		AD5933::setControlMode(CTRL_INCREMENT_FREQ);
	}
	medReal/=(NUM_INCR+1);
	medImag/=(NUM_INCR+1);
	float medGain=0;
	if(point == 1)
	{
		Serial.println("Modo 1point.");
	}
	else if(point == 2)				//CHANGE THIS, MAKE SURE THE TWO-POINT FACTOR IS CALCULATED WITH THE NUMBER OF READINGS IN MIND.
	{
		float firstP = gain[0];
		float finalP = gain[10];
		float dif = finalP-firstP;
		dif /= 10;
		for(int i=1;i<10;i++)
		{
			gain[i] = firstP + (i*dif);
		}
		Serial.println("Modo 2point.");
		
		//Serial.println("Modo 2-point desabilitado, 1-point utilizado.");
	}
	else
	{
		Serial.println("Erro, modo point falhou, padrão utilizado.");
	}
	
	for(int i=0;i<NUM_INCR+1;i++)
	{
		medGain+=gain[i];
	}
	medGain/=(NUM_INCR+1);
	digitalWrite(_pinD7, LOW);
	Serial.println("Completo!");
	Serial.print("MedReal=");
	Serial.println(medReal);
	Serial.print("MedImag=");
	Serial.println(medImag);
	leitura leiTemp = {_freq, medReal, medImag};
	memcpy(leiTemp.arrayR, arrayR, sizeof leiTemp.arrayR);
	memcpy(leiTemp.arrayJ, arrayJ, sizeof leiTemp.arrayJ);

	//Serial.print("EEPROM address 0:");Serial.println(EEPROM.read(0));
  
    // Set AD5933 power mode to standby when finished
	if (!AD5933::setPowerMode(POWER_STANDBY)){
		Serial.println("Could not set to standby...");
	}
	return leiTemp;
}
double red_crystal::temperatura()
{
	return AD5933::getTemperature();
}

bool red_crystal::setRange(int range)
{
	if(range<1 || range>4)
	{
		return false;
	}
	else
	{
		_range = range;
		return true;
	}
	return false;
}
int red_crystal::getRange()
{
	return _range;
}