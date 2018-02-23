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
	//Wire.begin();
	Serial.println("Construtor basico red_quartz utilizado.");
	bool dummy;
	_segundo 	= time.getSecond();
	_minuto 	= time.getMinute();
	_hora 		= time.getHour(dummy, dummy);
	_dia 		= time.getDate();
	_mes 		= time.getMonth(dummy);
	_ano 		= time.getYear();
}
int red_quartz::segundo()
{
	
}
int red_quartz::minuto()
{
	
}
int red_quartz::hora()
{
	
}
int red_quartz::dia()
{
	
}
int red_quartz::mes()
{
	
}
int red_quartz::ano()
{
	
}
char* red_quartz::data_hora(bool completo)
{
	
}
		
bool red_quartz::testa_segundo(int s)		//testa se o valor recebido é valido, retorna TRUE se sim, FALSE se não.
{
	if(s>=0 && s<60){						//0-59
		return true;
	}
	else{
		return false;
	}
}
bool red_quartz::testa_minuto(int min)		//testa se o valor recebido é valido, retorna TRUE se sim, FALSE se não.
{
	if(min>=0 && min<60){					//0-59
		return true;
	}
	else{
		return false;
	}
}
bool red_quartz::testa_hora(int hr)			//testa se o valor recebido é valido, retorna TRUE se sim, FALSE se não.
{
	if(hr>=0 && hr<24){						//0-23
		return true;
	}
	else{
		return false;
	}
}
bool red_quartz::testa_dia(int d, int mn)	//testa se o valor recebido é valido, retorna TRUE se sim, FALSE se não.
{
	if(d>0){
		if(d<=28){							//1-28
			return true;
		}
		else{
			if(mn==2){
				return false;
			}
			else{
				if(d<=30){					//29-30
					return true;
				}
				else{						//dia 31
					if(mn<8){				//antes de agosto
						
					}
				}
			}
		}
	}
	else{
		return false;
	}
}
bool red_quartz::testa_mes(int mn)			//testa se o valor recebido é valido, retorna TRUE se sim, FALSE se não.
{
	if(mn>0 && mn <=12){					//1-12
		return true;
	}
	else{
		return false;
	}
}
bool red_quartz::testa_ano(int a)			//testa se o valor recebido é valido, retorna TRUE se sim, FALSE se não.
{
	if(a>=0){								//0-...
		return true;
	}
	else{
		return false;
	}
}