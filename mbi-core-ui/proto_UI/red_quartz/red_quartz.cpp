/*
	red_quartz.h - Biblioteca criada com a função de testar a funcionalidade do RTC no mbi
	Criado por Vitor H. Cardoso. 22 de fevereiro, 2018
*/

#include "red_quartz.h"
#include <DS3231.h>
#include <Wire.h>

//DS3231 time;
red_quartz::red_quartz()
{
	Wire.begin();
	Serial.println("Construido");
	_minute = serial_minute();
	_hour = serial_hour();
}
int red_quartz::serial_minute()
{
	int temp = time.getMinute();
	Serial.print("Minuto: ");
	Serial.println(temp);
	return temp;
}
int red_quartz::serial_hour()
{
	bool h12,pm;
	int temp = time.getHour(h12, pm);
	Serial.print("Hora: ");
	Serial.println(temp);
	return temp;
}
bool red_quartz::test_minute(int min)
{
	if(min>=0 && min<60){
		Serial.println("Minuto valido");
		return true;
	}
	else{
		Serial.println("Minuto invalido!");
		return false;
	}
}
bool red_quartz::test_hour(int hr)
{
	if(hr>=0 && hr<24){
		Serial.println("Hora valida");
		return true;
	}
	else{
		Serial.println("Hora invalida!");
		return false;
	}
}