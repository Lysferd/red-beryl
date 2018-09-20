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

}
void red_quartz::init()
{
	Serial.println("Inicializador red_quartz.init utilizado.");
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
	return _segundo;
}
int red_quartz::minuto()
{
	return _minuto;
}
int red_quartz::hora()
{
	return _hora;
}
int red_quartz::dia()
{
	return _dia;
}
int red_quartz::mes()
{
	return _mes;
}
int red_quartz::ano()
{
	return _ano;
}
char* red_quartz::data_hora(bool completo)					//recebe um bool que define se retorna apenas hora ou hora e data
{
	if(completo){											//se o bool [completo] for true, retorna data e hora,[00/00/00-00:00]14 caracteres+finalizador=15 caracteres.
		char *tempStr = (char*)malloc(sizeof(char) * 15);			//inicializa e aloca memoria para o array de char tempStr que será retornado.
		char filler[20];									//inicializa filler para construir a string.
		itoa(_dia, filler, 10);								//traduz o valor int de _dia para filler.
		if(_dia<10){										//se _dia for menor que 10.
			strcpy(tempStr, "0");							//string recebe zero.
			strcat(tempStr, filler);						//valor de filler[dia] adicionado ao final da string.
		}
		else{												//se _dia for pelo menos 10.
			strcpy(tempStr, filler);						//string recebe filler[dia]
		}
		strcat(tempStr, "/");								//adiciona separador de data ao final da string.
		
		itoa(_mes, filler, 10);								//traduz o valor int de _mes para filler.
		if(_mes<10){										//se _mes for menor que 10.
			strcat(tempStr, "0");							//zero é adicionado ao fim da string.
		}
		strcat(tempStr, filler);							//valor de filler[mes] adicionado ao final da string.
		strcat(tempStr, "/");								//adiciona separador de data ao final da string.
		
		itoa(_ano, filler, 10);								//traduz o valor int de _ano para filler.
		if(_ano<10){										//se o _ano for menor que 10.
			strcat(tempStr, "0");							//zero é adicionado ao fim da string.
		}
		strcat(tempStr, filler);							//valor de filler[ano] adicionado ao final da string.
		strcat(tempStr, " ");								//adiciona um espaço vazio como separador.
		
		itoa(_hora, filler, 10);							//traduz o valor int de _hora para filler.
		if(_hora<10){										//se _hora for menor que 10.
			strcat(tempStr, "0");							//string recebe zero.
		}
		strcat(tempStr, filler);							//string recebe filler[hora]
		strcat(tempStr, ":");								//adiciona separador de hora ao final da string.
		
		itoa(_minuto, filler, 10);							//traduz o valor int de _minuto para filler.
		if(_minuto<10){										//se _minuto for menor que 10.
			strcat(tempStr, "0");							//zero é adicionado ao fim da string.
		}
		strcat(tempStr, filler);							//valor de filler[minuto] adicionado ao final da string.
		
		return tempStr;										//RETORNA STRING.
	}
	else{													//se o bool [completo] for false, retorna apenas hora [00:00]5 caracteres+finalizador=6.
		char *tempStr = (char*)malloc(sizeof(char) * 6);			//inicializa e aloca memoria para o array de char tempStr que será retornado.
		char filler[20];									//inicializa filler para construir a string.
		itoa(_hora, filler, 10);							//traduz o valor int de _hora para filler.
		if(_hora<10){										//se _hora for menor que 10.
			strcpy(tempStr, "0");							//string recebe zero.
			strcat(tempStr, filler);						//valor de filler[hora] adicionado ao final da string.
		}
		else{												//se _hora for pelo menos 10.
			strcpy(tempStr, filler);						//string recebe filler[hora]
		}
		strcat(tempStr, ":");								//adiciona separador de hora ao final da string.
		
		itoa(_minuto, filler, 10);							//traduz o valor int de _minuto para filler.
		if(_minuto<10){										//se _minuto for menor que 10.
			strcat(tempStr, "0");							//zero é adicionado ao fim da string.
		}
		strcat(tempStr, filler);							//valor de filler[minuto] adicionado ao final da string.
		
		return tempStr;										//RETORNA STRING.
	}
}
	
void red_quartz::checkTime()
{
	bool dummy;
	_segundo 	= time.getSecond();
	_minuto 	= time.getMinute();
	_hora 		= time.getHour(dummy, dummy);
	_dia 		= time.getDate();
	_mes 		= time.getMonth(dummy);
	_ano 		= time.getYear();
}
bool red_quartz::set_segundo(int s)
{
	if(testa_segundo(s)){
		time.setSecond(s);
		return true;
	}
	else{
		return false;
	}
}
bool red_quartz::set_minuto(int m)
{
	if(testa_minuto(m)){
		time.setMinute(m);
		return true;
	}
	else{
		return false;
	}
}
bool red_quartz::set_hora(int h)
{
	if(testa_hora(h)){
		time.setHour(h);
		return true;
	}
	else{
		return false;
	}
}
bool red_quartz::set_dia(int d, int m)
{
	if(testa_dia(d, m)){
		time.setDate(d);
		return true;
	}
	else{
		return false;
	}
}
bool red_quartz::set_mes(int m)
{
	if(testa_mes(m)){
		time.setMonth(m);
		return true;
	}
	else{
		return false;
	}
}
bool red_quartz::set_ano(int a)
{
	if(testa_ano(a)){
		time.setYear(a);
		return true;
	}
	else{
		return false;
	}
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
						if(mn%2!=0){		//meses impares.
							return true;
						}
					}
					else{					//agosto e depois
						if(mn%2==0){		//meses pares.
							return true;
						}
					}
				}
			}
		}
	}
	return false;
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