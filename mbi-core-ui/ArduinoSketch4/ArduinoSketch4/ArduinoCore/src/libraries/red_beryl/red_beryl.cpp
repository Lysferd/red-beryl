/*
	red_beryl.h - Biblioteca criada com a função de assistir na programação do medidor de bioimpedancia
	Criado por Vitor H. Cardoso. 20 de fevereiro, 2018
*/

#include "red_beryl.h"
#include <stdio.h>
#include <string.h>
#include <Wire.h>
#include <Adafruit_SSD1306.h>
#include <Adafruit_GFX.h>
#include <leituras.h>
#include <red_crystal.h>
#include <red_quartz.h>

#include <EEPROM.h>

#define BAT8_HEIGHT 8 
#define BAT8_WIDTH 16
static const unsigned char PROGMEM bat_6x16_bmp[] =
{ B00000000, B00000000,
  B00111111, B11111111,
  B00100000, B00000001,
  B11100000, B00000001,
  B11100000, B00000001,
  B00100000, B00000001,
  B00111111, B11111111,
  B00000000, B00000000
  };

#define BT9_HEIGHT 9
#define BT9_WIDTH 9
static const unsigned char PROGMEM BT_9_bmp[] =
{
  B00001100,B00000000,
  B01001010,B00000000,
  B00101001,B00000000,
  B00011010,B00000000,
  B00001100,B00000000,
  B00011010,B00000000,
  B00101001,B00000000,
  B01001110,B00000000,
  B00000000,B00000000
  };

#define BT2_HEIGHT 8
#define BT2_WIDTH 8
static const unsigned char PROGMEM BT2_bmp[] =
{
  B00000000,
  B00011000,
  B01010100,
  B00110010,
  B00011100,
  B00110010,
  B01010100,
  B00011000
};

red_beryl::red_beryl()
{
	Serial.println("Construtor basico red_beryl utilizado.");
	display.begin(SSD1306_SWITCHCAPVCC, 0x3C, true);
	Serial.println("display inicializado.");
	display.clearDisplay();
	display.display();
	display.setCursor(display.width()/2-(3*2*6/2),display.height()/2-(1*2*7/2)+2);
	display.setTextColor(WHITE);
	display.setTextSize(2);
	display.print("mbi");
	display.setTextSize(1);
	display.setCursor(1, 0);
	display.print("M.A.Engenharia");
	display.display();
	delay(1000);
	
	Serial.print("tamanho de uma leitura: ");
	Serial.println(sizeof(leitura));
	Serial.print("Tamanho da EEPROM:");
	Serial.println(EEPROM.length());
	if(EEPROM.read(EEPROM.length()-1)<1 || EEPROM.read(EEPROM.length()-1)>3)
	{
		EEPROM.write(EEPROM.length()-1, 1);
	}
	
	_notificationType = EEPROM.read(EEPROM.length()-1);
	if(EEPROM.read(EEPROM.length()-2)<1 || EEPROM.read(EEPROM.length()-2)>2)
	{
		EEPROM.write(EEPROM.length()-2, 1);
	}
	_pointGain = EEPROM.read(EEPROM.length()-2);
	
	Serial.print("Valor no ultimo endereço:");
	Serial.println(EEPROM.read(EEPROM.length()-1));
	Serial.print("Valor no penultimo endereço:");
	Serial.println(EEPROM.read(EEPROM.length()-2));
	Serial.print("status-wire");
	Serial.print(Wire.available());
	Serial.println(Wire.read());
	Serial.print("AD - ");
	
	adResetTest();	

	_pinUP = 23;
	_pinDOWN = 25;
	_pinYES = 24;
	_pinNO = 22;
	_pinBAT = A15;
	
	
	pinMode(_pinUP, INPUT);
	pinMode(_pinDOWN, INPUT);
	pinMode(_pinYES, INPUT);
	pinMode(_pinNO, INPUT);
	
	_up = false;
	_down = false;
	_yes = false;
	_no = false;
	BLE = true;
	persistentNotify = false;
	busyNotify = false;
	
	leitura0 = {0};
	
	Serial.print("versão: ");
	Serial.println(VERSION);
	//delay(1000);
	clock.init();
	crystal.init();
}
void red_beryl::adResetTest()
{
	while(!(crystal.reset()))
	{
		warning("Aguardando AD");
		display.display();
		Serial.print("Waiting");
		delay(500);
		display.print(".");
		display.display();
		Serial.print(".");
		delay(500);
	}
}

void red_beryl::checarPin()
{
	adResetTest();
	static bool first=true;
	if(first){
		Serial.println("Listening...");
		first=false;
	}
	static int tempButton = 0;    //botão temporario que vai receber o valor do ultimo botão apertado para impedir que a ação se repita.
	if(digitalRead(_pinUP)||digitalRead(_pinDOWN)||digitalRead(_pinYES)||digitalRead(_pinNO))
	{
		if(digitalRead(_pinUP) && tempButton != digitalRead(_pinUP)){
			tempButton = digitalRead(_pinUP);
			Serial.print("UP:");Serial.println(digitalRead(_pinUP));
			_up = true;
		}
		if(digitalRead(_pinDOWN) && tempButton != digitalRead(_pinDOWN)){
			tempButton = digitalRead(_pinDOWN);
			Serial.print("DOWN:");Serial.println(digitalRead(_pinDOWN));
			_down = true;
		}
		if(digitalRead(_pinYES) && tempButton != digitalRead(_pinYES)){
			tempButton = digitalRead(_pinYES);
			Serial.print("YES:");Serial.println(digitalRead(_pinYES));
			_yes = true;
		}
		if(digitalRead(_pinNO) && tempButton != digitalRead(_pinNO)){
			tempButton = digitalRead(_pinNO);
			Serial.print("NO:");Serial.println(digitalRead(_pinNO));
			_no = true;
		}
    delay(10);
	}
	else{
		tempButton = 0;
	}
}

int red_beryl::getBatteryPct()
{
	int pwr, pct;
	pwr = analogRead(_pinBAT);
	pct = map(pwr,0,1023,0,100);
	return pct;
}

void red_beryl::upperBar()    // barra superior.
{	
	static int pct = getBatteryPct();   //declara o inteiro estatico pct(PERCENTAGE)
	static int pwr = map(pct, 0, 100, 1, 12);   //declara o inteiro estatico pwr(POWER)
	static long mill = 0;
	static long tempMill = 0;
	static long tempMill2 = 0;
	static double temperature = crystal.temperatura();		//TRANSFERIR PARA RED_CRYSTAL
	mill = millis();
	static char* timeStr;// = clock.data_hora(false);
	
	if( (mill - tempMill2) > 50)
	{
		tempMill2 = mill;
		int tempct = getBatteryPct();
		if(!(pct==100 & tempct==99))
		{
			pct = tempct;
		}
		pwr = map(pct, 0, 100, 0, 12);
	}
	if( (mill - tempMill) > 250){
		temperature = crystal.temperatura();						//TRANSFERIR PARA RED_CRYSTAL
		free(timeStr);
		timeStr = clock.data_hora(false);
		tempMill = mill;
	}
	display.fillRect(display.width()-1-pwr, 2, pwr, 4, WHITE); //desenha a barra da bateria
	
	if(pct<10)
	{
		display.setCursor(display.width()-BAT8_WIDTH-12, 0);
	}
	else if(pct != 100)
	{
		display.setCursor(display.width()-BAT8_WIDTH-18, 0);
	}
	else
	{
		display.setCursor(display.width()-BAT8_WIDTH-24, 0);
	}

	display.setTextSize(1);
	display.setTextColor(WHITE);
	display.print(pct);
	display.print("%");  // printando a porcentagem da bateria que foi calculada anteriormente usando map a partir de pwr, dependendo da porcentagem alterando quando começa o cursor.

	display.setTextSize(1);
	display.setTextColor(WHITE);
	display.setCursor(display.width()/2-15, 0);
	
	display.print(timeStr);
		
	display.drawBitmap(display.width()-BAT8_WIDTH, 0, bat_6x16_bmp, BAT8_WIDTH, BAT8_HEIGHT, WHITE); // desenha o contorno da bateira no canto superior ESQUERDO. 6 de altura, 16 de largura
	
	if(BLE)		//LEMBRAR DE RETORNA ISSO A """IF(BLE)"""
	{
		display.drawBitmap(0, 0, BT2_bmp, BT2_WIDTH, BT2_HEIGHT, WHITE);
	}
	display.setCursor(BT2_WIDTH+5,0);

	
	display.setTextSize(1);
	display.setTextColor(WHITE);
	display.print((int) temperature);
	display.write((uint8_t) 247);
	display.print("C");
}

bool red_beryl::notificationTimer(bool inUse)
{
	static const long timeLimit = 2000;
	static long timer = 0;
	static long lockedTimer = millis();
	switch(_notificationType)			//1-Persistente 2-Temporizado 3-Desabilitado
	{
		case 1:
		{
			if(!busyNotify)
			{
				if(inUse)
				{
					busyNotify=true;
					if(persistentNotify)
					{
						persistentNotify = false;
					}
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				if(inUse)
				{
					if(persistentNotify)
					{
						lockedTimer = millis();
						persistentNotify = false;
					}
					return true;
				}
				else
				{
					if(!persistentNotify)
					{
						timer = millis();
						if(!(Serial1.available() > 0) && (timer-lockedTimer)>250)
						{
							persistentNotify = true;
							return true;
						}
						else
						{
							return true;
						}
					}
					else
					{
						checarPin();
						if(_yes || _no)
						{
							persistentNotify = false;
							busyNotify = false;
							_yes = false;
							_no = false;
							_up = false;
							_down = false;
							return false;
						}
						else
						{
							if(_up || _down)
							{
								_up = false;
								_down = false;
							}
							return true;
						}
					}
				}
			}
			break;
		}
		case 2:
		{
			if(!busyNotify)
			{
				if(inUse)
				{
					busyNotify = true;
					lockedTimer = millis();
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				if(!inUse)
				{
					timer = millis();
					if( (timer-lockedTimer) > timeLimit )
					{
						busyNotify = false;
						return false;
					}
				}
				else
				{
					lockedTimer = millis();
					return true;
				}
			}
			break;
		}
		case 3:
		{
			return false;
			break;
		}
		default:
		{
			if(inUse)
			{
				busyNotify = true;
				return true;
			}
			else
			{
				if(busyNotify)
				{
					busyNotify = false;
				}
				return false;
			}
			break;
		}
	}
}

void red_beryl::notification()
{
	if(busyNotify)
	{
		if(!persistentNotify)
		{
			warning("Sincronizando");
		}
		else
		{
			warning("Concluido.");
				
			display.fillRect(display.width()-25, display.height()-15, 2*6+2, lineSize+2, BLACK);
			display.drawRect(display.width()-25, display.height()-15, 2*6+2, lineSize+2, WHITE);
			display.setCursor(display.width()-23, display.height()-15+1 );
			display.setTextColor(WHITE);
			display.setTextSize(1);
			display.print("OK");
		}
	}
}
void red_beryl::menu()
{
	static int choice=1;
	static char* menu[] = { (char*)"0.default", (char*)"1.Leituras", (char*)"2.Sincronizar", (char*)"3.Ajustes" };
	switch(choice){
		case 11:		//Menu Leituras
		{
			if(!menu_leitura()){		//chama a função [bool] menu_leitura, se retornar [false], retorna a opção 1 do menu.
				choice = 1;
			}
			if(_up || _down || _yes || _no){
				_up=false;
				_down=false;
				_yes=false;
				_no=false;
			}
			break;
		}
		case 21:		//Menu Sincronização(bluetooth)
		{
			if(!menu_sinc()){		//chama a função [bool] menu_sinc, se retornar [false], retorna a opção 2 do menu.
				choice = 2;
			}
			break;
		}
		case 31:		//Menu Ajustes
		{
			if(!menu_ajuste()){		//chama a função [bool] menu_ajuste, se retornar [false], retorna a opção 3 do menu.
				choice = 3;
			}
			break;
		}
		case 1:			//Leituras
		{
			display.fillRect(1, lineSize, display.width()-5, lineSize, WHITE);  //desenha um quadrado em volta da opção 1 selecionada

			menuOption(menu[1], 1, true);
			menuOption(menu[2], 2, false);
			menuOption(menu[3], 3, false);

			if(_yes){
				choice=11;
			}
			break;
		}
		case 2:			//Sincronização(bluetooth)
		{
			menuOption(menu[1], 1, false);
			menuOption(menu[2], 2, true);
			menuOption(menu[3], 3, false);
			
			if(_yes){
				choice=21;
			}
			break;
		}
		case 3:			//Ajustes(opções)
		{
			menuOption(menu[1], 1, false);
			menuOption(menu[2], 2, false);
			display.fillRect(1, lineSize*3, display.width()-5, lineSize, WHITE);//desenha um quadrado em volta da opção 1 selecionada
			menuOption(menu[3], 3, true);
			
			if(_yes){
				choice=31;
			}
			break;
		}
		default:		//Se por alguma razão algo estiver diferente
		{
			break;
		}
	}
	if(_up){
		choice--;
		if(choice < 1){
			choice = 3;
		}
		_up = false;
	}
	if(_down){
		choice++;
		if(choice > 3){
			choice = 1;
		}
		_down = false;
	}
	if(_no){
		_no = false;
	}
	if(_yes){
		_yes = false;
	}
}
bool red_beryl::menu_leitura()
{
	static int choice=1;
	static char* menu[] = { (char*)"0.default", (char*)"1.Nova Leitura", (char*)"2.Historico" };
	switch(choice){
		case 11:		//Nova leitura
		{
			static bool done=false;
			static long frequencia = 50000;
			
			if(!done){
				display.fillRect(10, lineSize, display.width()-20, lineSize*3, BLACK);
				display.drawRect(10, lineSize, display.width()-20, lineSize*3, WHITE);
				display.setCursor(13, lineSize+2);
				display.setTextColor(WHITE);
				display.setTextSize(1);
				display.print("Frequencia?");
			
				display.drawRect(display.width()/3-2, lineSize*2+2, 3*6+4, 11, WHITE);
				display.setCursor(display.width()/3, lineSize*2+4);
				display.setTextColor(WHITE);
				if(frequencia<25000)
				{
					display.print("  ");
				}
				else if(frequencia<100000)
				{
					display.print(" ");
				}
				display.print(frequencia/1000);
				display.setTextColor(WHITE);
				display.print(" KHz");
				
				
				if(_up)
				{
					_up = false;
					switch(frequencia)
					{
						case 5000:
						{
							frequencia = 25000;
							break;
						}
						case 25000:
						{
							frequencia = 50000;
							break;
						}
						case 50000:
						{
							frequencia = 100000;
							break;
						}
						case 100000:
						{
							frequencia = 5000;
							break;
						}
					}
				}
				if(_down)
				{
					_down = false;
					switch(frequencia)
					{
						
						
						case 5000:
						{
							frequencia = 100000;
							break;
						}
						case 25000:
						{
							frequencia = 5000;
							break;
						}
						case 50000:
						{
							frequencia = 25000;
							break;
						}
						case 100000:
						{
							frequencia = 50000;
							break;
						}
					}
				}
			}
			else{
				display.setCursor(1, lineSize);
				
				display.setTextColor(WHITE);
				display.setTextSize(1);
				if(leitura0.dia<10){
					display.print("0");
				}
				display.print(leitura0.dia);
				display.print("/");
				if(leitura0.mes<10){
					display.print("0");
				}
				display.print(leitura0.mes);
				display.print(" ");
				if(leitura0.hora<10){
					display.print("0");
				}
				display.print(leitura0.hora);
				display.print(":");
				if(leitura0.minuto<10){
					display.print("0");
				}
				display.print(leitura0.minuto);
				display.print(" ");
				if(leitura0.freq/1000<10){
					display.setCursor(display.width()-2-6*4, lineSize);
				}
				else if(leitura0.freq/1000<100){
					display.setCursor(display.width()-2-6*5, lineSize);
				}
				else{
					display.setCursor(display.width()-2-6*6, lineSize);
				}
				display.print(leitura0.freq/1000);
				display.print("KHz");
				
				display.setCursor(1, lineSize*2);
				display.print("  R:");
				if(leitura0.real>=0)
				{
					display.print(" ");
				}
				display.print(leitura0.real);
				display.setCursor(1, lineSize*3);
				display.print("  J:");
				if(leitura0.imag>=0)
				{
					display.print(" ");
				}
				display.print(leitura0.imag);
			}
			
			if(_yes){
				if(!done){
					warning("Configurando", "frequencia.");
					upperBar();
					display.display();
					while(!crystal.configurar(frequencia)){
						Serial.println("Configurando...");
					}
					warning("Realizando", "leitura.");
					upperBar();
					display.display();
					if(!crystal.lerAD(getPoint(), leitura0))
					{
						_yes = false;
						done=false;
						choice = 1;
					}
					else
					{				
						leitura0.hora=clock.hora();
						leitura0.minuto=clock.minuto();
						leitura0.dia=clock.dia();
						leitura0.mes=clock.mes();
						leitura0.ano=clock.ano();
								
						Serial.println(leitura0.hora);
						Serial.println(leitura0.minuto);
						Serial.println(leitura0.dia);
						Serial.println(leitura0.mes);
						Serial.println(leitura0.ano);
						done=true;
					
						static int limit = ((EEPROM.length()-3)/sizeof(leitura));

						if(EEPROM.read(0)>=limit)												// Se o numero de leitura for superior ao limite de memoria.
						{
							int tempPos=EEPROM.read(0)-limit;									// Cria uma variavel temporaria que recebe o valor de posição.
							if(tempPos>=limit)
							{
								tempPos-=limit;
							}
							EEPROM.put((tempPos*sizeof(leitura))+1, leitura0);
							Serial.print("Sobreescreveu na posição ");
							Serial.print(tempPos+1);
							Serial.println(".");
							if(EEPROM.read(0)>=limit*2)
							{
								EEPROM.write(0, limit);
							}
							else
								EEPROM.write(0, EEPROM.read(0)+1);
						}
						else
						{
							EEPROM.put( ( ( EEPROM.read(0)*sizeof(leitura) )+1)  , leitura0);  		//salva a nova leitura na EEPROM.
							Serial.println("Salvo na EEPROM ");
							Serial.print(EEPROM.read(0)+1);
							EEPROM.write(0 , ( EEPROM.read(0)+1 ));    							//o valor da posição '0' recebe 'i'.
						}
						_yes=false;
						done=true;
					}
				}
				else{
					done=false;
					_yes=false;
					choice=1;
				}
			}
			if(_no)
			{
				if(done)
				{
					done=false;
				}
				choice=1;
			}
			if(_up || _down || _yes || _no){
				_up=false;
				_down=false;
				_yes=false;
				_no=false;
			}
			break;
		}
		case 21:		//Historico
		{
			if(historico())
			{
				choice = 2;
			}
			break;
		}
		case 1:			//Opção Nova leitura
		{
			display.fillRect(1, lineSize, display.width()-5, lineSize, WHITE);  //desenha um quadrado em volta da opção 1 selecionada
			menuOption(menu[1], 1, true);
			menuOption(menu[2], 2, false);
			
			if(_yes){
				choice=11;
				_yes=false;
				
				_up=false;
				_down=false;
				_no=false;
			
			}
			break;
		}
		case 2:			//Opção Historico
		{
			menuOption(menu[1], 1, false);
			
			display.fillRect(1, lineSize*2, display.width()-5, lineSize, WHITE);//desenha um quadrado em volta da opção 1 selecionada
			menuOption(menu[2], 2, true);
			
			if(_yes){
				choice=21;
				_yes=false;
				
				_up=false;
				_down=false;
				_no=false;
			}
			
			break;
		}
		default:		//Se por alguma razão algo estiver diferente.
		{
			choice=1;
			Serial.println("CUIDADO, algo deu errado, choice resetado para 1");
			break;
		}
	}
	if(_up){
		choice--;
		if(choice < 1){
			choice = 2;
		}
		_up=false;
	}
	if(_down){
		choice++;
		if(choice > 2){
			choice = 1;
		}
		_down=false;
	}
	if(_yes){
		_yes=false;
	}
	if(_no){
		_no=false;
		choice=1;
		return false;
	}
	return true;
}
bool red_beryl::menu_sinc()
{
	display.setCursor(2, lineSize);   //define a posição do cursor na primeira linha.
    display.setTextColor(BLACK,WHITE);    //define a cor do texto.(preto no fundo branco.)
    if(BLE)
	{
		display.print("Desativar Bluetooth.");
		if(_yes)
		{
			BLE=false;
			_yes=false;
			return false;
        }
	}
	else
	{
		display.print("Ativar Bluetooth.");
        if(_yes)
		{
			BLE=true;
			_yes=false;
			return false;
        }
	}
	if(_no)
	{
		_no=false;
		return false;
	}
	if(_up)
	{
		_up=false;
	}
	if(_down)
	{
		_down=false;
	}
	return true;
}

bool red_beryl::menu_ajuste()
{
	static int choice=1, select=1;
	static char* menu[] = { (char*)"0.default", (char*)"1- Ajustar Relogio", (char*)"2- Ajustar Avisos", (char*)"3- Ajustar Historico", (char*)"4-Ajustar Ganho", (char*)"5-Ajuster Range" };
	
	switch(choice)
	{
		case 1:
		{
			static bool rel = false;
			if(rel)
			{
				if(relogio())
				{
					rel=false;
				}
			}
			else
			{
				menuOption(menu[1], 1, true);
				menuOption(menu[2], 2, false);
				menuOption(menu[3], 3, false);
				
				if(_up)
				{
					choice--;
					select--;
					_up = false;
				}
				if(_down)
				{
					choice++;
					select++;
					_down = false;
				}
				if(_yes)
				{
					rel=true;
					_yes=false;
					_no=false;
				}
				if(_no)
				{
					_no=false;
					choice=1;
					select=1;
					return false;
				}
			}
			break;
		}
		case 2:
		{
			if(select==1)
			{
				menuOption(menu[2], 1, true);
				menuOption(menu[3], 2, false);
				menuOption(menu[4], 3, false);
			
				if(_up)
				{
					choice--;
					_up = false;
				}
				if(_down)
				{
					select++;
					choice++;
					_down = false;
				}
				if(_yes)
				{
					choice = 21;
					_yes=false;
					_no=false;
				}
				if(_no)
				{
				_no=false;
				return false;
				}
			}
			else if(select==2)
			{
				menuOption(menu[1], 1, false);
				menuOption(menu[2], 2, true);
				menuOption(menu[3], 3, false);
			
				if(_up)
				{
					choice--;
					select--;
					_up = false;
				}
				if(_down)
				{
					choice++;
					select++;
					_down = false;
				}
				if(_yes)
				{
					choice = 21;
					_yes=false;
					_no=false;
				}
				if(_no)
				{
				_no=false;
				return false;
				}
			}
			break;
		}
		case 21:
		{
			if(!menu_aviso())
			{
				choice = 2;
			}
			break;
		}
		case 3:
		{
			if(select==1)
			{
				menuOption(menu[3], 1, true);
				menuOption(menu[4], 2, false);
				menuOption(menu[5], 3, false);
				if(_up)												// Se UP for ativo.
				{
					choice--;										// Escolha anterior.
					_up = false;									// Desativa UP.
				}
				if(_down)											// Se DOWN for ativo.
				{
					choice++;										// Proxima escolha.
					select++;										// Proximo seletor.
					_down = false;									// Desativa DOWN.
				}
				if(_yes)											// Se YES for ativo.
				{
					choice=31;										// Muda escolha para o menu 41.
					_yes=false;										// Desativa YES.
					_no=false;										// Desativa NO.
				}
				if(_no)												// Se NO for ativo.
				{
					_no=false;										// Desativa NO.
					return false;									// Retorna negativo e desativa o menu de ajuste.
				}
			} else if(select==2)
			{
				menuOption(menu[2], 1, false);
				menuOption(menu[3], 2, true);
				menuOption(menu[4], 3, false);
				
				if(_up)
				{
					choice--;
					select--;
					_up = false;
				}
				if(_down)
				{
					choice++;
					select++;
					_down = false;
				}
				if(_yes)
				{
					choice=31;
					_yes=false;
					_no=false;
				}
				if(_no)
				{
				_no=false;
				return false;
				}
			}
			else if(select==3)
			{
				menuOption(menu[1], 1, false);
				menuOption(menu[2], 2, false);
				menuOption(menu[3], 3, true);
				if(_up)
				{
					choice--;
					select--;
					_up = false;
				}
				if(_down)
				{
					choice++;
					_down = false;
				}
				if(_yes)
				{
					choice=31;
					_yes=false;
					_no=false;
				}
				if(_no)
				{
				_no=false;
				return false;
				}
			}
			break;
		}
		case 31:
		{
			if(!menu_historico())
			{
				choice = 3;
			}
			break;
		}
		case 4:
		{
			if(select==2)
			{
				menuOption(menu[3], 1, false);
				menuOption(menu[4], 2, true);
				menuOption(menu[5], 3, false);
				if(_up)												// Se UP for ativo.
				{
					choice--;										// Escolha anterior.
					select--;										// Seletor anterior.
					_up = false;									// Desativa UP.
				}
				if(_down)											// Se DOWN for ativo.
				{
					choice++;										// Proxima escolha.
					select++;										// Proximo seletor.
					_down = false;									// Desativa DOWN.
				}
				if(_yes)											// Se YES for ativo.
				{
					choice=41;										// Muda escolha para o menu 41.
					_yes=false;										// Desativa YES.
					_no=false;										// Desativa NO.
				}
				if(_no)												// Se NO for ativo.
				{
					_no=false;										// Desativa NO.
					return false;									// Retorna negativo e desativa o menu de ajuste.
				}
			
			} else if(select==3)
			{
				menuOption(menu[2], 1, false);
				menuOption(menu[3], 2, false);
				menuOption(menu[4], 3, true);
				
				if(_up)
				{
					choice--;
					select--;
					_up = false;
				}
				if(_down)
				{
					choice++;
					_down = false;
				}
				if(_yes)
				{
					choice=41;
					_yes=false;
					_no=false;
				}
				if(_no)
				{
				_no=false;
				return false;
				}
			}
			break;
		}
		case 41:
		{
			if(!menu_point())
			{
				choice = 4;
			}
			break;
		}
		case 5:
		{
			if(select==3)
			{
				menuOption(menu[3], 1, false);
				menuOption(menu[4], 2, false);
				menuOption(menu[5], 3, true);
				if(_up)
				{
					choice--;
					select--;
					_up = false;
				}
				if(_down)
				{
					choice++;
					_down = false;
				}
				if(_yes)
				{
					choice = 51;
					_yes = false;
					_no = false;
				}
				if(_no)
				{
					_no = false;
					return false;
				}
			}
			break;
		}
		case 51:
		{
			if(!menu_range())
			{
				choice = 5;
			}
			break;
		}
		default:
		{
			if(choice<1)
			{	
				choice = 5;
				select = 3;
			}
			if(choice>5)
			{
				choice = 1;
				select = 1;
			}
			break;
		}
	}
	return true;
}

bool red_beryl::menu_range()
{
	static char* menu[] = { (char*)"  ", (char*)"Range 1", (char*)"Range 2", (char*)"Range 3", (char*)"Range 4"};
	static int choice = 1, select = 1;
	switch(choice)
	{
		case 1:
		{
			display.setCursor(2, lineSize);						// Definir a posição do cursor na primeira linha.
			display.setTextSize(1);								// Definir o tamanho do texto.
			display.setTextColor(BLACK, WHITE);					// Definir a cor do texto(Preto no Branco = selecionado).
			display.print(menu[0]);								// Imprimir espaço vazio do menu.
		
			if(crystal.getRange() == 1)							// Se o range for 1.
			{
				display.print("*");								// Imprime o asterisco para sinalizar.
			}
			display.print(menu[1]);								// Imprimir a opção 1 do menu.
				
			display.setCursor(2, lineSize*2);					// Definir a posição do cursor na segunda linha.
			display.setTextColor(WHITE);						// Definir a cor do texto(Branco = não selecionado).
			display.print(menu[0]);								// Imprimir espaço vazio do menu.
			if(crystal.getRange() == 2)							// Se o range for 2.
			{
				display.print("*");								// Imprime o asterisco para sinalizar.
			}
			display.print(menu[2]);								// Imprimir a opção 2 do menu.
				
			display.setCursor(2, lineSize*3);					// Definir a posição do cursor na terceira linha.
			display.setTextColor(WHITE);						// Definir a cor do texto(Branco = não selecionado).
			display.print(menu[0]);								// Imprimir espaço vazio do menu.
			if(crystal.getRange() == 3)							// Se o range for 3.
			{
				display.print("*");								// Imprime o asterisco para sinalizar.
			}
			display.print(menu[3]);								// Imprimir a opção 3 do menu.
			
			if(_up)												// Se UP for ativo.
			{
				choice--;										// Escolha anterior.
				_up = false;									// Desativa UP.
			}
			if(_down)											// Se DOWN for ativo.
			{
				choice++;										// Proxima escolha.
				select++;										// Proximo seletor.
				_down = false;									// Desativa DOWN.
			}
			if(_yes)											// Se YES for ativo.
			{
				if(crystal.getRange() != choice)				// Se o Range for diferente da escolha.
				{
					crystal.setRange(choice);					// Settar o Range na escolha.
					Serial.print("Range ");						//
					Serial.print(choice);						// Imprimir no Serial a escolha para debug.
					Serial.println(" selecionado.");			//
				}
				_yes=false;										// Desativa YES.
				_no=false;										// Desativa NO.
			}
			if(_no)												// Se NO for ativo.
			{
				_no=false;										// Desativa NO.
				return false;									// Retorna negativo para desativar esse menu.
			}
			break;												// switch-case break.
		}
		case 2:
		{
			if(select == 1)
			{
				display.setCursor(2, lineSize);					// Definir a posição do cursor na primeira linha.
				display.setTextSize(1);							// Definir o tamanho do texto.
				display.setTextColor(BLACK, WHITE);				// Definir a cor do texto(Preto no Branco = selecionado).
				display.print(menu[0]);							// Imprimir espaço vazio do menu.
				if(crystal.getRange() == 2)						// Se o range for 2.
				{
					display.print("*");							// Imprime o asterisco para sinalizar.
				}
				display.print(menu[2]);							// Imprimir a opção 2 do menu.
					
				display.setCursor(2, lineSize*2);				// Definir a posição do cursor na segunda linha.
				display.setTextColor(WHITE);					// Definir a cor do texto(Branco = não selecionado).
				display.print(menu[0]);							// Imprimir espaço vazio do menu.
				if(crystal.getRange() == 3)						// Se o range for 3.
				{
					display.print("*");							// Imprime o asterisco para sinalizar.
				}
				display.print(menu[3]);							// Imprimir a opção 3 do menu.
					
				display.setCursor(2, lineSize*3);				// Definir a posição do cursor na terceira linha.
				display.setTextColor(WHITE);					// Definir a cor do texto(Branco = não selecionado).
				display.print(menu[0]);							// Imprimir espaço vazio do menu.
				if(crystal.getRange() == 4)						// Se o range for 4.
				{
					display.print("*");							// Imprime o asterisco para sinalizar.
				}
				display.print(menu[4]);							// Imprimir a opção 4 do menu.
				
				if(_up)											// Se UP for ativo.
				{
					choice--;									// Escolha anterior.
					_up = false;								// Desativa UP.
				}
				if(_down)										// Se DOWN for ativo.
				{
					choice++;									// Proxima escolha.
					select++;									// Proximo seletor.
					_down = false;								// Desativa DOWN.
				}
				if(_yes)										// Se YES for ativo.
				{
					if(crystal.getRange() != choice)			// Se o Range for diferente da escolha.
					{
						crystal.setRange(choice);				// Settar o Range na escolha.
						Serial.print("Range ");					//
						Serial.print(choice);					// Imprimir no Serial a escolha para debug.
						Serial.println(" selecionado.");		//
					}
					_yes=false;									// Desativa YES.
					_no=false;									// Desativa NO.
				}
				if(_no)											// Se NO for ativo.
				{
					_no=false;									// Desativa NO.
					return false;								// Retorna negativo para desativar esse menu.
				}
			} else if(select == 2)
			{
				display.setCursor(2, lineSize);					// Definir a posição do cursor na primeira linha.
				display.setTextSize(1);							// Definir o tamanho do texto.
				display.setTextColor(WHITE);					// Definir a cor do texto(Branco = não selecionado).
				display.print(menu[0]);							// Imprimir espaço vazio do menu.
				if(crystal.getRange() == 1)						// Se o range for 1.
				{
					display.print("*");							// Imprime o asterisco para sinalizar.
				}
				display.print(menu[1]);							// Imprimir a opção 1 do menu.
					
				display.setCursor(2, lineSize*2);				// Definir a posição do cursor na segunda linha.
				display.setTextColor(BLACK, WHITE);				// Definir a cor do texto(Preto no Branco = selecionado).
				display.print(menu[0]);							// Imprimir espaço vazio do menu.
				if(crystal.getRange() == 2)						// Se o range for 2.
				{
					display.print("*");							// Imprime o asterisco para sinalizar.
				}
				display.print(menu[2]);							// Imprimir a opção 2 do menu.
					
				display.setCursor(2, lineSize*3);				// Definir a posição do cursor na terceira linha.
				display.setTextColor(WHITE);					// Definir a cor do texto(Branco = não selecionado).
				display.print(menu[0]);							// Imprimir espaço vazio do menu.
				if(crystal.getRange() == 3)						// Se o range for 3.
				{
					display.print("*");							// Imprime o asterisco para sinalizar.
				}
				display.print(menu[3]);							// Imprimir a opção 3 do menu.
				
				if(_up)											// Se UP for ativo.
				{
					choice--;									// Escolha anterior.
					select--;									// Seletor anterior.
					_up = false;								// Desativa UP.
				}
				if(_down)										// Se DOWN for ativo.
				{
					choice++;									// Proxima escolha.
					select++;									// Proximo seletor.
					_down = false;								// Desativa DOWN.
				}
				if(_yes)										// Se YES for ativo.
				{
					if(crystal.getRange() != choice)			// Se o Range for diferente da escolha.
					{
						crystal.setRange(choice);				// Settar o Range na escolha.
						Serial.print("Range ");					//
						Serial.print(choice);					// Imprimir no Serial a escolha para debug.
						Serial.println(" selecionado.");		//
					}
					_yes=false;									// Desativa YES.
					_no=false;									// Desativa NO.
				}
				if(_no)											// Se NO for ativo.
				{
					_no=false;									// Desativa NO.
					return false;								// Retorna negativo para desativar esse menu.
				}
			}
			break;												// switch-case break.
		}
		case 3:
		{
			if(select == 2)
			{
				display.setCursor(2, lineSize);					// Definir a posição do cursor na primeira linha.
				display.setTextSize(1);							// Definir o tamanho do texto.
				display.setTextColor(WHITE);					// Definir a cor do texto(Branco = não selecionado).
				display.print(menu[0]);							// Imprimir espaço vazio do menu.
				if(crystal.getRange() == 2)						// Se o range for 2.
				{
					display.print("*");							// Imprime o asterisco para sinalizar.
				}
				display.print(menu[2]);							// Imprimir a opção 2 do menu.
					
				display.setCursor(2, lineSize*2);				// Definir a posição do cursor na segunda linha.
				display.setTextColor(BLACK, WHITE);				// Definir a cor do texto(Preto no Branco = selecionado).
				display.print(menu[0]);							// Imprimir espaço vazio do menu.
				if(crystal.getRange() == 3)						// Se o range for 3.
				{
					display.print("*");							// Imprime o asterisco para sinalizar.
				}
				display.print(menu[3]);							// Imprimir a opção 3 do menu.
					
				display.setCursor(2, lineSize*3);				// Definir a posição do cursor na terceira linha.
				display.setTextColor(WHITE);					// Definir a cor do texto(Branco = não selecionado).
				display.print(menu[0]);							// Imprimir espaço vazio do menu.
				if(crystal.getRange() == 4)						// Se o range for 4.
				{
					display.print("*");							// Imprime o asterisco para sinalizar.
				}
				display.print(menu[4]);							// Imprimir a opção 4 do menu.
				
				if(_up)											// Se UP for ativo.
				{
					choice--;									// Escolha anterior.
					select--;									// Seletor anterior.
					_up = false;								// Desativa UP.
				}
				if(_down)										// Se DOWN for ativo.
				{
					choice++;									// Proxima escolha.
					select++;									// Proximo seletor.
					_down = false;								// Desativa DOWN.
				}
				if(_yes)										// Se YES for ativo.
				{
					if(crystal.getRange() != choice)			// Se o Range for diferente da escolha.
					{
						crystal.setRange(choice);				// Settar o Range na escolha.
						Serial.print("Range ");					//
						Serial.print(choice);					// Imprimir no Serial a escolha para debug.
						Serial.println(" selecionado.");		//
					}
					_yes=false;									// Desativa YES.
					_no=false;									// Desativa NO.
				}
				if(_no)											// Se NO for ativo.
				{
					_no=false;									// Desativa NO.
					return false;								// Retorna negativo para desativar esse menu.
				}
			} else if(select == 3)
			{
				display.setCursor(2, lineSize);					// Definir a posição do cursor na primeira linha.
				display.setTextSize(1);							// Definir o tamanho do texto.
				display.setTextColor(WHITE);					// Definir a cor do texto(Branco = não selecionado).
				display.print(menu[0]);							// Imprimir espaço vazio do menu.
				if(crystal.getRange() == 1)						// Se o range for 1.
				{
					display.print("*");							// Imprime o asterisco para sinalizar.
				}
				display.print(menu[1]);							// Imprimir a opção 1 do menu.
					
				display.setCursor(2, lineSize*2);				// Definir a posição do cursor na segunda linha.
				display.setTextColor(WHITE);					// Definir a cor do texto(Branco = não selecionado).
				display.print(menu[0]);							// Imprimir espaço vazio do menu.
				if(crystal.getRange() == 2)						// Se o range for 2.
				{
					display.print("*");							// Imprime o asterisco para sinalizar.
				}
				display.print(menu[2]);							// Imprimir a opção 2 do menu.
					
				display.setCursor(2, lineSize*3);				// Definir a posição do cursor na terceira linha.
				display.setTextColor(BLACK, WHITE);				// Definir a cor do texto(Preto no Branco = selecionado).
				display.print(menu[0]);							// Imprimir espaço vazio do menu.
				if(crystal.getRange() == 3)						// Se o range for 3.
				{
					display.print("*");							// Imprime o asterisco para sinalizar.
				}
				display.print(menu[3]);							// Imprimir a opção 3 do menu.
				
				if(_up)											// Se UP for ativo.
				{
					choice--;									// Escolha anterior.
					select--;									// Seletor anterior.
					_up = false;								// Desativa UP.
				}
				if(_down)										// Se DOWN for ativo.
				{
					choice++;									// Proxima escolha.
					_down = false;								// Desativa DOWN.
				}
				if(_yes)										// Se YES for ativo.
				{
					if(crystal.getRange() != choice)			// Se o Range for diferente da escolha.
					{
						crystal.setRange(choice);				// Settar o Range na escolha.
						Serial.print("Range ");					//
						Serial.print(choice);					// Imprimir no Serial a escolha para debug.
						Serial.println(" selecionado.");		//
					}
					_yes=false;									// Desativa YES.
					_no=false;									// Desativa NO.
				}
				if(_no)											// Se NO for ativo.
				{
					_no=false;									// Desativa NO.
					return false;								// Retorna negativo para desativar esse menu.
				}
			}
			break;												// switch-case break.
		}
		case 4:
		{
			display.setCursor(2, lineSize);						// Definir a posição do cursor na primeira linha.
			display.setTextSize(1);								// Definir o tamanho do texto.
			display.setTextColor(WHITE);						// Definir a cor do texto(Branco = não selecionado).
			display.print(menu[0]);								// Imprimir espaço vazio do menu.
			if(crystal.getRange() == 2)							// Se o range for 2.
			{
				display.print("*");								// Imprime o asterisco para sinalizar.
			}
			display.print(menu[2]);								// Imprimir a opção 2 do menu.
				
			display.setCursor(2, lineSize*2);					// Definir a posição do cursor na segunda linha.
			display.setTextColor(WHITE);						// Definir a cor do texto(Branco = não selecionado).
			display.print(menu[0]);								// Imprimir espaço vazio do menu.
			if(crystal.getRange() == 3)							// Se o range for 3.
			{
				display.print("*");								// Imprime o asterisco para sinalizar.
			}
			display.print(menu[3]);								// Imprimir a opção 3 do menu.
				
			display.setCursor(2, lineSize*3);					// Definir a posição do cursor na terceira linha.
			display.setTextColor(BLACK, WHITE);					// Definir a cor do texto(Preto no Branco = selecionado).
			display.print(menu[0]);								// Imprimir espaço vazio do menu.
			if(crystal.getRange() == 4)							// Se o range for 4.
			{
				display.print("*");								// Imprime o asterisco para sinalizar.
			}
			display.print(menu[4]);								// Imprimir a opção 4 do menu.
			
			if(_up)												// Se UP for ativo.
			{
				choice--;										// Escolha anterior.
				select--;										// Seletor anterior.
				_up = false;									// Desativa UP.
			}
			if(_down)											// Se DOWN for ativo.
			{
				choice++;										// Proxima escolha.
				_down = false;									// Desativa DOWN.
			}
			if(_yes)											// Se YES for ativo.
			{
				if(crystal.getRange() != choice)				// Se o Range for diferente da escolha.
				{
					crystal.setRange(choice);					// Settar o Range na escolha.
					Serial.print("Range ");						//
					Serial.print(choice);						// Imprimir no Serial a escolha para debug.
					Serial.println(" selecionado.");			//
				}
				_yes=false;										// Desativa YES.
				_no=false;										// Desativa NO.
			}
			if(_no)												// Se NO for ativo.
			{
				_no=false;										// Desativa NO.
				return false;									// Retorna negativo para desativar esse menu.
			}
			break;												// switch-case break.
		}
		default:
		{
			if(choice<1)
			{
				choice = 4;
				select = 3;
			}
			if(choice>4)
			{
				choice = 1;
				select = 1;
			}
			break;
		}
	}
	return true;
}

bool red_beryl::menu_point()
{
	static char* menu[] = { (char*)"0.default", (char*)"1-Modo 1Point", (char*)"1-Modo 2Point" };
	static int choice = 1;
	switch(choice)
	{
		case 1:
		{
			display.setCursor(2, lineSize);    //definir a posição do cursor na primeira linha.
			display.setTextSize(1);   //definir o tamanho do texto(por garantia)
			display.setTextColor(BLACK, WHITE);    //definir a cor do texto como: branco | não selecionado
			if(_pointGain==1)
			{
				display.print("* ");
			}
			display.print(menu[1]);    //imprimir opção 1.
			display.setCursor(2, lineSize*2);
			display.setTextColor(WHITE);
			if(_pointGain==2)
			{
				display.print("* ");
			}
			display.print(menu[2]);    //imprimir opção 1.
			if(_up)
			{
				choice--;
				_up = false;
			}
			if(_down)
			{
				choice++;
				_down = false;
			}
			if(_yes)
			{
				if(_pointGain != choice)
				{
					_pointGain=choice;
					EEPROM.write(EEPROM.length()-2, choice);
				}
				_yes=false;
				_no=false;
			}
			if(_no)
			{
				_no=false;
				return false;
			}
			
			break;
		}
		case 2:
		{
			display.setCursor(2, lineSize);    //definir a posição do cursor na primeira linha.
			display.setTextSize(1);   //definir o tamanho do texto(por garantia)
			display.setTextColor(WHITE);    //definir a cor do texto como: branco | não selecionado
			if(_pointGain==1)
			{
				display.print("* ");
			}
			display.print(menu[1]);    //imprimir opção 1.
			
			display.setCursor(2, lineSize*2);
			display.setTextColor(BLACK, WHITE);
			if(_pointGain==2)
			{
				display.print("* ");
			}
			display.print(menu[2]);    //imprimir opção 1.
			
			if(_up)
			{
				choice--;
				_up = false;
			}
			if(_down)
			{
				choice++;
				_down = false;
			}
			if(_yes)
			{
				if(_pointGain != choice)
				{
					_pointGain=choice;
					EEPROM.write(EEPROM.length()-2, choice);
				}
				_yes=false;
				_no=false;
			}
			if(_no)
			{
				_no=false;
				return false;
			}
			
			break;
		}
		default:
		{
			if(choice<1)
			{	
				choice = 2;
			}
			if(choice>2)
			{
				choice = 1;
			}
			break;
		}
	}
	return true;
}
bool red_beryl::menu_aviso()
{
	static char* menu[] = { (char*)"0.default", (char*)"1- Persistente", (char*)"2- Temporizado", (char*)"3- Desabilitado" };
	static int choice = 1;
	
	switch(choice)
	{
		case 1:
		{
			display.setCursor(2, lineSize);    //definir a posição do cursor na primeira linha.
			display.setTextSize(1);   //definir o tamanho do texto(por garantia)
			display.setTextColor(BLACK, WHITE);    //definir a cor do texto como: branco | não selecionado
			if(_notificationType==1)
			{
				display.print("* ");
			}
			display.print(menu[1]);    //imprimir opção 1.
			
			
			display.setCursor(2, lineSize*2);
			display.setTextColor(WHITE);
			if(_notificationType==2)
			{
				display.print("* ");
			}
			display.print(menu[2]);    //imprimir opção 1.
			
			
			display.setCursor(2, lineSize*3);
			display.setTextColor(WHITE);
			if(_notificationType==3)
			{
				display.print("* ");
			}
			display.print(menu[3]);    //imprimir opção 1.
			
			
			if(_up)
			{
				choice--;
				_up = false;
			}
			if(_down)
			{
				choice++;
				_down = false;
			}
			if(_yes)
			{
				if(_notificationType != choice)
				{
					_notificationType=choice;
					EEPROM.write(EEPROM.length()-1, choice);
				}
				_yes=false;
				_no=false;
			}
			if(_no)
			{
				_no=false;
				return false;
			}
			
			break;
		}
		case 2:
		{
			display.setCursor(2, lineSize);    //definir a posição do cursor na primeira linha.
			display.setTextSize(1);   //definir o tamanho do texto(por garantia)
			display.setTextColor(WHITE);    //definir a cor do texto como: branco | não selecionado
			if(_notificationType==1)
			{
				display.print("* ");
			}
			display.print(menu[1]);    //imprimir opção 1.
			
			display.setCursor(2, lineSize*2);
			display.setTextColor(BLACK, WHITE);
			if(_notificationType==2)
			{
				display.print("* ");
			}
			display.print(menu[2]);    //imprimir opção 1.
			
			display.setCursor(2, lineSize*3);
			display.setTextColor(WHITE);
			if(_notificationType==3)
			{
				display.print("* ");
			}
			display.print(menu[3]);    //imprimir opção 1.
			
			if(_up)
			{
				choice--;
				_up = false;
			}
			if(_down)
			{
				choice++;
				_down = false;
			}
			if(_yes)
			{
				if(_notificationType != choice)
				{
					_notificationType=choice;
					EEPROM.write(EEPROM.length()-1, choice);
				}
				_yes=false;
				_no=false;
			}
			if(_no)
			{
				_no=false;
				return false;
			}
			
			break;
		}
		case 3:
		{
			display.setCursor(2, lineSize);    //definir a posição do cursor na primeira linha.
			display.setTextSize(1);   //definir o tamanho do texto(por garantia)
			display.setTextColor(WHITE);    //definir a cor do texto como: branco | não selecionado
			if(_notificationType==1)
			{
				display.print("* ");
			}
			display.print(menu[1]);    //imprimir opção 1.
			
			display.setCursor(2, lineSize*2);
			display.setTextColor(WHITE);
			if(_notificationType==2)
			{
				display.print("* ");
			}
			display.print(menu[2]);    //imprimir opção 1.
			
			display.setCursor(2, lineSize*3);
			display.setTextColor(BLACK, WHITE);
			if(_notificationType==3)
			{
				display.print("* ");
			}
			display.print(menu[3]);    //imprimir opção 1.
			if(_up)
			{
				choice--;
				_up = false;
			}
			if(_down)
			{
				choice++;
				_down = false;
			}
			if(_yes)
			{
				if(_notificationType != choice)
				{
					_notificationType=choice;
					EEPROM.write(EEPROM.length()-1, choice);
				}
				_yes=false;
				_no=false;
			}
			if(_no)
			{
				_no=false;
				return false;
			}
			break;
		}
		default:
		{
			if(choice<1)
			{	
				choice = 3;
			}
			if(choice>3)
			{
				choice = 1;
			}
			break;
		}
	}
	return true;
}

bool red_beryl::menu_historico()
{
	static char* menu[] = { (char*)"0.default", (char*)"1- Limpar Historico", (char*)"2- Formatar Historico" };
	static int choice = 1;
	
	switch(choice)
	{
		case 1:
		{
			static bool clear = false;
			if(clear)
			{
				static bool reseter = false;
				if(!reseter)
				{
					display.setCursor(2, lineSize);
					display.setTextColor(WHITE);
					display.println("Limpar Historico?");
					
					display.setCursor(display.width()/2, lineSize*2);
					display.print("N|S");
					if(_yes)
					{
						reseter=true;
						_yes=false;
					}
					if(_no)
					{
						reseter=false;
						_no=false;
						clear=false;
					}
				}
				else
				{
					EEPROM.write(0,0);
					display.setCursor(display.width()/2-25, display.height()/2-4);    //define a posição do cursor.
					display.setTextColor(WHITE);    //define a fonte branca.
					display.print("Concluido!");    //imprime a frase que indica que completou a logica.
					if(_yes || _no || _up || _down)
					{    //se qualquer um dos botões for TRUE.
							
						reseter=false;    //reseta RESETER.
						_yes=false;    //reseta YES.
						_no=false;   //reseta NO.
						_up=false;   //reseta UP.
						_down=false;   //reseta DOWN.
							
						clear=false;
							
						return false;
					}
				}
			}
			else
			{
				display.setCursor(2, lineSize);    //definir a posição do cursor na primeira linha.
				display.setTextSize(1);   //definir o tamanho do texto(por garantia)
				display.setTextColor(BLACK, WHITE);    //definir a cor do texto como: branco | não selecionado
				display.print(menu[1]);    //imprimir opção 1.
				
				display.setCursor(2, lineSize*2);    //definir a posição do cursor na primeira linha.
				display.setTextColor(WHITE);    //definir a cor do texto como: branco | não selecionado
				display.print(menu[2]);    //imprimir opção 1.
				
				if(_up)
				{
					choice--;
					_up = false;
				}
				if(_down)
				{
					choice++;
					_down = false;
				}
				if(_yes)
				{
					clear=true;
					_yes=false;
					_no=false;
				}
				if(_no)
				{
					_no=false;
					return false;
				}
			}
			break;
		}
		case 2:
		{
			static bool wipe = false;
			if(wipe)
			{
				static bool reseter = false;    //declara e inicia como falsa uma 
				if(!reseter)
				{   //se o reseter for falso, faz a logica para perguntar se o usuario deseja apagar o historico.
					display.setCursor(2, lineSize);    //reseta a posição do cursor
					display.setTextColor(WHITE);    //define as fonte branca.
					display.println("Formatar historico?");
        
					display.setCursor(display.width()/2, lineSize*2);    //define a posição do cursor
					display.print("N|S");
					if(_yes)
					{    //se o botão YES for true.
						reseter=true;   //define reseter como true para começar a logica de limpar o historico
						_yes=false;       //reseta YES.
					}
					if(_no)
					{   //se o botão NO for true.
						reseter=false;    //reseta o reseter por garantia.
						_no=false;   //reseta NO.
						wipe = false;
					}
				}
				else
				{   //se o valor de RESETER for true.
					static int i=0;   //declara variavel int com valor 0 de modo estatico para percorrer os endereços da EEPROM
					display.setCursor(display.width()/2-30, display.height()/2-4);    //define posição do cursor
					display.setTextColor(WHITE);    //define a fonte branca.
					if(i < EEPROM.length()-1)
					{    //se i for menor que o tamanho da memoria da EEPROM
						EEPROM.write(i,0);    //o valor da posição 'i' recebe '0'.
						Serial.println(i);    //imprime no serial o endereço atual para acomapnhar.
						int exp = map(i,0,4095,0,100);    //mapeia em uma variavel int de 0 a 100 o espelho do endereço da EEPROM, de forma que o valor da variavel seja a porcentagem da memoria ja percorrida e 'limpa'.
						display.print("Limpando...");
						display.setCursor(display.width()/2-10, display.height()/2+4);    //define posição do cursor
						display.setTextColor(WHITE);    //define a fonte branca.
						display.print(exp);   //imprime na tela esse valor.
						display.print("%");   //completa com o simbolo de porcentagem.
						i++;    //incrementa 'i' para começar no proximo endereço.
					}
					else
					{   //se i for maior que o tamanho da memoria da EEPROM, ou seja, se terminar de limpar a memoria.
						display.setCursor(display.width()/2-25, display.height()/2-4);    //define a posição do cursor.
						display.setTextColor(WHITE);    //define a fonte branca.
						display.print("Concluido!");    //imprime a frase que indica que completou a logica.
						if(_yes || _no || _up || _down)
						{    //se qualquer um dos botões for TRUE.
							reseter=false;    //reseta RESETER.
							i=0;    //reseta o valor de i;
							_yes=false;    //reseta YES.
							_no=false;   //reseta NO.
							_up=false;   //reseta UP.
							_down=false;   //reseta DOWN.
							wipe=false;
							
							return false;
						}
					}
				}
			}
			else
			{
				display.setCursor(2, lineSize);    //definir a posição do cursor na primeira linha.
				display.setTextSize(1);   //definir o tamanho do texto(por garantia)
				display.setTextColor(WHITE);    //definir a cor do texto como: branco | não selecionado
				display.print(menu[1]);    //imprimir opção 1.
				
				display.setCursor(2, lineSize*2);    //definir a posição do cursor na primeira linha.
				display.setTextColor(BLACK, WHITE);    //definir a cor do texto como: branco | não selecionado
				display.print(menu[2]);    //imprimir opção 1.
				
				if(_up)
				{
					choice--;
					_up = false;
				}
				if(_down)
				{
					choice++;
					_down = false;
				}
				if(_yes)
				{
					wipe=true;
					_yes=false;
					_no=false;
				}
				if(_no)
				{
					_no=false;
					return false;
				}
			}
			break;
		}
		default:
		{
			if(choice<1)
			{	
				choice = 2;
			}
			if(choice>2)
			{
				choice = 1;
			}
			break;
		}
	}
	return true;
}

bool red_beryl::nova_leitura()
{
	
}
bool red_beryl::historico()
{	
	static int i = 0;   //declara a variavel i referente aos numeros do historico(+1), por padrão usaremos apenas 10 valores, mas como o arduino Mega oferece muito mais espaço é possivel liberar mais espaço para salvar as leituras.
	static int l = 1;   //declara a variavel l referente as linhas do historico, estou testando seu uso para um menu mais dinamico e inteligente.
    static bool detalhar = false;   //declara a variavel bool detalhar que define se os detalhes de uma leitura escolhida deverão ser mostrados ou não.
	static int limit = ((EEPROM.length()-3)/sizeof(leitura))-1;
		if(EEPROM.read(0)!=0)
		{    //primeiro testa se tem algo no historico para apresentar.
			if(i>limit)
			{
				i-=limit;
			}
			if(detalhar)
			{
				static bool recebeu=false;			/*inicializa uma variavel bool que informa se a leitura ja foi recebida da EEPROM*/
				static bool perguntaDelete=false;   //inicializa uma variavel bool que decide se uma caixa de texto perguntando se o usuario quer deletar uma leitura aparece ou não.
				static leitura leituraTemp;			//inicializa uma struct leitura temporaria para receber a struct leitura da EEPROM, feita static para que não se repita.
				if(!recebeu)
				{   //se não tiver recebido a leitura da EEPROM
					EEPROM.get((sizeof(leitura)*i)+1,leituraTemp);    //leituraTemp recebe a leitura da EEPROM.
					recebeu=true;   //recebeu recebe valor true.
					Serial.println("recebeu leitura");    //imprime a confirmação no serial
				}
				display.setCursor(25,lineSize);    //define a posição do cursor.
				display.setTextColor(WHITE);    //define a cor da fonte(branca).
				display.print(leituraTemp.dia);   //imprime o valor dia.
				display.print("/");   //separador de data.
				display.print(leituraTemp.mes);   //imprime o valor mes.
				display.print("/");   //separador de data.
				display.print(leituraTemp.ano);   //imprime o valor ano.
				display.print("  ");    //espaço vazio.
				display.print(leituraTemp.hora);    //imprime o valor hora.
				display.print(":");   //separador de hora.
				if(leituraTemp.minuto<10)
				{    //se o minuto for menor que 10, imprime 0 para manter a estetica.
					display.print("0");
				}
				display.print(leituraTemp.minuto);    //imprime o valor minuto.
				display.setCursor(2,lineSize*2);   //define a posição do cursor
				display.print("R:");   //real
				if(leituraTemp.real>=0)
				{
					display.print(" ");
				}
				display.print(leituraTemp.real);    //imprime o valor real
				display.setCursor(2,lineSize*3);   //define a posição do cursor
				display.print("I:");    //imaginario
				if(leituraTemp.imag>=0)
				{
					display.print(" ");
				}
				display.print(leituraTemp.imag);    //imprime o valor imaginario

				display.setCursor(display.width()-(6*7), lineSize*2+4);
				display.print(leituraTemp.freq/1000);
				display.print("KHz");

				if(perguntaDelete)
				{
					warning("Deletar? N/S");
					if(_up)
					{
						_up=false;
					}
					if(_down)
					{
						_down=false;
					}
					if(_yes)
					{
						deletaLeitura(i);
						detalhar=false;
						recebeu=false;
						perguntaDelete=false;
						_yes=false;
						i=0;
						l=1;
						_up=true;
						_down=true;
					}
					if(_no)
					{
						perguntaDelete=false;
						_no=false;
					}
				}
				if(_yes)
				{    //se YES for true.
					perguntaDelete=true;
					_yes=false;    //reseta YES.
				}
				if(_up)
				{   //se UP for true.
					if(i!=0)
					{   //se i não estiver na posição 0
						i--;    //i-1
						if(l!=1)
						{   //se não estiver selecionando a primeira linha.
							l--;    //seleciona a linha acima da atual.
						}
					}
					else if(EEPROM.read(0)>1)
					{    //se i for 0 e haver mais de uma leitura na EEPROM
						if((EEPROM.read(0)-1)>limit)
						{
							i=limit;
						}
						else
						{
							i=EEPROM.read(0)-1;   //i recebe o valor equivalente a ultima leitura valida.
						}
						if(EEPROM.read(0)>2)
						{   //se tiver mais de duas leituras validas
							l=3;    //seleciona a terceira linha para quando retornar ao menu anterior
						}
						else if(EEPROM.read(0)==2)
						{   //se tiverem extamente duas leituras validas.
							l=2;    //seleciona a segunda linha para quando retornar ao menu anterior.
						}
					}
					recebeu=false;    //reseta RECEBEU para que o valor em leituraTemp e a tela sejam atualizados com a nova posição de i.
					_up=false;   //reseta UP.
				}
				if(_down)
				{   //se DOWN for true.
					if(i!=EEPROM.read(0)-1 && i!=limit)
					{    //se i não estiver na ultima posição valida a partir da EEPROM.
						i++;    //i+1
						if(l!=3)
						{   //se não for a terceira linha
							l++;
						}
					}
					else if(EEPROM.read(0)>1)
					{    //se i estiver na ultima posição valida e não for a unica leitura valida
						i=0;    //i recebe o valor 0 e volta a primeira posição.
						l=1;    //seleciona a primeira linha quando voltar ao menu de historicos.
					}
					recebeu=false;    //reseta RECEBEU para que o valor em leituraTemp e a tela sejam atualizados com a nova posição de i.
					_down=false;   //reseta DOWN.
				}
				if(_no)
				{
					recebeu=false;    //reseta RECEBEU
					detalhar=false;   //reseta DETALHAR
					_no=false;   //reseta NO
				} 
			}
			else 
			{
				static leitura L1,L2,L3;
				static bool ler = false;
				if(l==1)
				{   //se estiver na primeira linha.
					if(!ler)
					{   //se a variavel ler for false: ou seja, se os valores de leitura não tiverem sido recebidos ainda.
						EEPROM.get(((i*sizeof(leitura))+1), L1);   //L1 recebe o valor salvo no historico referente a posição i;
						if((i+1)<EEPROM.read(0) && (i+1)<=limit)
						{    //se o proximo valor ainda estiver dentro do limite de leituras validas.
							EEPROM.get((((i+1)*sizeof(leitura))+1), L2);   //L2 recebe o valor salvo no historico referente a posição i+1.
							if((i+2)<EEPROM.read(0) && (i+2)<=limit)
							{    //se o proximo valor ainda estiver dentro do limite de leituras validas.
								EEPROM.get((((i+2)*sizeof(leitura))+1), L3);   //L3 recebe o valor salvo no historico referente a posição i+2.
							}
						}
						ler=true;   //ler recebe true.
					}
					imprimeEscolha( i+1, l, L1, true);
					if((i+1)<EEPROM.read(0) && (i+1)<=limit)
					{   //se o proximo valor ainda estiver dentro do limite de leituras validas.
						imprimeEscolha( i+2, l+1, L2, false);
						if((i+2)<EEPROM.read(0) && (i+2)<=limit)
						{   //se o proximo valor ainda estiver dentro do limite de leituras validas.
							imprimeEscolha( i+3, l+2, L3, false);
						}
					}
				}
				if(l==2)
				{   //se estiver na segunda linha.
					if(EEPROM.read(0)<2 || i==0)
					{   //se tiver menos de dois endereços no historico ou se o i for 0, imediatamente retorna a primeira linha.
						l=1;
					}
					else 
					{    //se tiver pelo menos dois endereços e i for diferente de 0;
						if(!ler)
						{   //se a variavel ler for false: ou seja, se os valores de leitura não tiverem sido recebidos ainda.
							EEPROM.get((((i-1)*sizeof(leitura))+1), L1);   //L1 recebe o valor salvo no historico referente a posição i-1;
							EEPROM.get((((i)*sizeof(leitura))+1), L2);   //L2 recebe o valor salvo no historico referente a posição i.
							if((i+1)<EEPROM.read(0) && (i+1)<=limit)
							{    //se o proximo valor ainda estiver dentro do limite de leituras validas.
								EEPROM.get((((i+1)*sizeof(leitura))+1), L3);   //L3 recebe o valor salvo no historico referente a posição i+1.
							}
							ler=true;   //ler recebe true.
						}
						imprimeEscolha( i, l-1, L1, false);           
						//final da logica das opções na linha 1 para quando a linha 2 estiver selecionada, a proxima parte conta com a linha 2.
						imprimeEscolha( i+1, l, L2, true);          
						//final da logica das opções na linha 2 quando selecionada, a proxima parte conta com a linha 3, usando 'if' para verificar se ela deve existir.
						if((i+1)<EEPROM.read(0) && (i+1)<=limit)
						{   //se o numero de leituras for maior que i+1(ou seja, se i=1(primeira linha 0), a terceira linha seria(i+1)=2, nesse caso, tivermos 3 leituras EEPROM.read(0)=[3]>[2]
							//portanto, nesse caso a terceira linha existe.
							imprimeEscolha( i+2, l+1, L3, false);
						}
					}
				}
				if(l==3)
				{   //se estiver na terceira(e ultima) linha.
					if(EEPROM.read(0)<3 || i==0 || i==1)
					{   //se tiver menos de tres endereços no historico ou se o i for 0 ou 1, imediatamente retorna a primeira linha.
						l=1;
					}
					else 
					{    //se tiver pelo menos tres endereços e i for diferente de 0 e 1;
						if(!ler)
						{   //se a variavel ler for false: ou seja, se os valores de leitura não tiverem sido recebidos ainda.
							EEPROM.get((((i-2)*sizeof(leitura))+1), L1);   //L1 recebe o valor salvo no historico referente a posição i-2;
							EEPROM.get((((i-1)*sizeof(leitura))+1), L2);   //L2 recebe o valor salvo no historico referente a posição i-1.
							EEPROM.get(((i*sizeof(leitura))+1), L3);   //L3 recebe o valor salvo no historico referente a posição i.
							ler=true;   //ler recebe true.
						}
						imprimeEscolha( i-1, l-2, L1, false);
						//Final da logica da linha 1.
						imprimeEscolha( i, l-1, L2, false);
						//Final da logica da linha 2.
						imprimeEscolha( i+1, l, L3, true);
					}
				}
				if(_up)
				{   //se UP for true
					if(l==1)
					{   //se a linha 1 estiver selecionada.
						if(i!=0)
						{   //se i não for 0.
							i--;    //i-1;    
						}
						else if(EEPROM.read(0)>1)
						{    //se i for 0 e houver mais de uma leitura salva no historico.
							if((EEPROM.read(0)-1)>limit)
							{
								i=limit;
							}
							else
								i=EEPROM.read(0)-1;   //i recebe o valor da ultima posição valida do historico.
							if(i>1)
							{      //se i for maior que 1.
								l=3;    //seleciona a terceira linha.
							}
							else if(i==1)
							{    //se i for igual a 1.
								l==2;   //seleciona a segunda linha.
							}
						}
					}
					else 
					{    //para as linhas 2 e 3, sempre que UP for true, apenas decresce os valores de i e l.
						i--;
						l--;
					}
					ler=false;    //reseta LER
					_up=false;   //reseta UP.
				}
				if(_down)
				{   //se DOWN for true.
					if(l==3)
					{   //se a linha 3 estiver selecionada.
						if(i==EEPROM.read(0)-1 || i>=limit)
						{    //se i for igual a ultima leitura possivel.
							i=0;    //volta a primeira leitura.
							l=1;    //seleciona a primeira linha.
						}
						else
						{   //se i não for a ultima leitura possivel.
							i++;    //incrementa o valor de i.
						}
					}
					else 
					{    //se a linha 1 ou 2 estiver selecionada.
						if(!(i==EEPROM.read(0)-1 || i==limit))
						{    //se i NÃO for igual a ultima leitura possivel.
							i++;  //incremente o valor de i.
							l++;    //incrementa o valor l(indo para a segunda ou terceira linha).
						}
						else
						{    //se i for igual a ultima leitura possivel.
							i=0;    //volta a primeira leitura.
							l=1;    //seleciona a primeira linha.
						}
					}
					ler=false;    //reseta LER
					_down=false;   //reset DOWN
				}
				if(_yes)
				{
					detalhar=true;
					ler=false;
					_yes=false;    //reseta YES
				}
				if(_no)
				{   //se NO for true.
					//choice=12;   //reseta choice.
					i=0;
					l=1;
					ler=false;
					_no=false;   //reseta NO.
					return true;
				}
				scrollBar(i);
			}
		}
		else
		{   //se o historico estiver vazio.
			display.setCursor(0, lineSize*2);    //define a posição do cursor
			display.setTextColor(WHITE);    //define a cor da fonte(branca);
			display.print(" Historico Vazio.");
			if(_yes)
			{
				_yes=false;    //reseta YES
			}
			if(_up)
			{
				_up=false;   //reseta UP.
			}
			if(_down)
			{
				_down=false;   //reseta DOWN.
			}
			if(_no)
			{
				//choice=12;   //retorna ao menu anterior.
				_no=false;   //reseta NO.
				return true;
			}
		}
	return false;
}
bool red_beryl::relogio()
{
	/////////////////////////////////////////////////////////////////////////////////////
	static bool doing = false, blinker = true;
	static int track = 0; //declarar e inicializar a variavel track, que será usada para definir o foco da função e o que será alterado(0=hora;1=minuto;2=dia;3=mes;4=ano)
	static int tempH, tempM, tempD, tempMn, tempY;  //declarando as variaveis temporarias responsaveis por receber os valor do rtc.
	static long timeTemp = 0;  static long tempTemp = 0;
  
	if( doing == false )  //se for a primeira vez rodando essa função, receber os valores do rtc para as variaveis.
	{
		tempH = clock.hora();
		tempM = clock.minuto();
		tempD = clock.dia();
		tempMn = clock.mes();
		tempY = clock.ano();
    
		doing = true;
	}
	if(blinker)
	{
		timeTemp = millis();    //variavel temporario recebe tempo em millis.
		if((timeTemp-tempTemp) > 500)
		{    //se a diferença entre as duas variaveis temporarias for de 1/2 segundos.
			blinker = false;    //blinker recebe valor false.
			tempTemp = timeTemp;    //A variavel tempTemp recebe o valor da timeTemp para resetar a diferença.
		}
		if(track!=0)
		{   //se NÃO for HORA.
			display.setTextSize(1);   //Definir tamanho do texto(1).
			display.setTextColor(WHITE);    //Definir cor do texto(BRANCO).
			display.setCursor(display.width()/2-15, lineSize+4);    //Definir a posição do cursor(metade da largura da tela menos 2 caracteres e meio, meia linha abaixo da barra superior).
			if(tempH<10)
			{
				display.print("0");   //Se o valor de HORA for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
			}
			display.print(tempH);   //Imprime valor Temporario de HORA.
		}
		display.setTextSize(1);   //Definir tamanho do texto(1).
		display.setTextColor(WHITE);    //Definir cor do texto(BRANCO).
		display.setCursor(display.width()/2-3, lineSize+4);    //Definir a posição do cursor(metade da largura da tela menos meio caractere, meia linha abaixo da barra superior).
		display.print(":");   //Imprime separador de tempo.
		
		if(track!=1)
		{   //se NÃO for MINUTO.
			display.setTextSize(1);   //Definir tamanho do texto(1).
			display.setTextColor(WHITE);    //Definir cor do texto(BRANCO).
			display.setCursor(display.width()/2+3, lineSize+4);    //Definir a posição do cursor(metade da largura da tela mais meio caractere, meia linha abaixo da barra superior).
			if(tempM<10)
			{
				display.print("0");   //Se o valor de MINUTO for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
			}
			display.print(tempM);   //Imprime valor Temporario de MINUTO.
		}
    
		if(track!=2)
		{   //se NÃO for DIA.
			display.setTextSize(1);   //Definir tamanho do texto(1).
			display.setTextColor(WHITE);    //Definir cor do texto(BRANCO).
			display.setCursor(display.width()/2-25, lineSize*2+6);   //Definir a posição do cursor(metade da largura da tela menos 4 caracteres, uma linha e meia abaixo da barrar superior).
			if(tempD<10)
			{
				display.print(" ");   //Se o valor de DIA for menor que 10(e portante, apenas um caractere), imprime [ ] na posição.
			}
			display.print(tempD);   //Imprime valor Temporario de DIA.
		}
		display.setTextSize(1);   //Definir tamanho do texto(1).
		display.setTextColor(WHITE);    //Definir cor do texto(BRANCO).
		display.setCursor(display.width()/2-13, lineSize*2+6);   //Definir a posição do cursor(metade da largura da tela menos 2 caracteres, uma linha e meia abaixo da barra superior).
		display.print("/");   //Imprime separador de data.
    
		if(track!=3)
		{   //se NÃO for MES.
			display.setTextSize(1);   //Definir tamanho do texto(1).
			display.setTextColor(WHITE);    //Definir a cor do texto(BRANCO).
			display.setCursor(display.width()/2-7, lineSize*2+6);   //Definir a posição do cursor(metade da largura da tela menos 1 caractere, uma linha e meia abaixo da barra superior).
			if(tempMn<10)
			{
				display.print("0");   //Se o valor de MES for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
			}
			display.print(tempMn);    //Imprime valor Temporario de MES.
		}
		display.setTextSize(1);   //Definir tamanho do texto(1).
		display.setTextColor(WHITE);    //Definir cor do texto(BRANCO).
		display.setCursor(display.width()/2+5, lineSize*2+6);    //Definir a posição do cursor(metade da largura da tela mais 1 caractere, uma linha e meia abaixo da barra superior).
		display.print("/");   //Imprime separador de data.
    
		if(track!=4)
		{   //se NÃO for ANO.
			display.setTextSize(1);   //Definir tamanho do texto(1).
			display.setTextColor(WHITE);    //Definir a cor do texto(BRANCO).
			display.setCursor(display.width()/2+11, lineSize*2+6);   //Definir a posição do cursor(metade da largura da tela mais 2 caracteres, uma linha e meia abaixo da barra superior).
			if(tempY<10)
			{
				display.print("0");   //Se o valor de ano for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
			}
			display.print(tempY);   //Imprime valor Temporario de ANO.
		}
	}
	else
	{
		timeTemp = millis();    //variavel temporario recebe tempo em millis.
		if((timeTemp-tempTemp) > 500)
		{    //se a diferença entre as duas variaveis temporarias for de 1/2 segundos.
			blinker = true;    //blinker recebe valor true e é ativado.
			tempTemp = timeTemp;    //A variavel tempTemp recebe o valor da timeTemp para resetar a diferença.
		}
		display.setTextSize(1);   //Definir tamanho do texto(1).
		display.setTextColor(WHITE);    //Definir a cor do texto(BRANCO).
		display.setCursor(display.width()/2-15, lineSize+4);   //Definir a posição do cursor(metade da largura da tela menos 2 caracteres e meio).
		if(tempH<10)
		{
			display.print("0");   //Se o valor de HORA for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
		}
		display.print(tempH);   //Imprime valor Temporario de HORA.
		display.print(":");   //Imprime separador de hora.
		if(tempM<10)
		{
			display.print("0");   //Se o valor de MINUTE for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
		}
		display.print(tempM);   //Imprime valor Temporario de MINUTE.

		display.setCursor(display.width()/2-25, lineSize*2+6);   //Definir a posição do cursor(metade da largura da tela menos 4 caracteres).
		if(tempD<10)
		{
			display.print(" ");   //Se o valor de DIA for menor que 10(e portanto, apenas um caractere), imprime [ ] na posição.
		}
		display.print(tempD);   //Imprime valor Temporario de DIA.
		display.print("/");   //Imprime separador de data.
		if(tempMn<10)
		{
			display.print("0");   //Se o valor de MES for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
		}
		display.print(tempMn);    //Imprime valor Temporario de MES.
		display.print("/");   //Imprime separador de data.
		if(tempY<10)
		{
			display.print("0");   //Se o valor de ANO for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
		}
		display.print(tempY);   //Imprime valor Temporario de ANO.
	}
	switch(track)
	{
		case 0: //hora: de 0 a 23 horas.
		{
			if(_up)  //se o botão UP tiver valor true.
			{
				if(tempH<23)
				{ //se a hora for menor que 23 horas
					tempH++;  //adiciona uma hora a mais.
				}
				else
				{ //se a hora for 23 horas.
					tempH = 0;  //volta a hora 0(equivalente as 24 horas)
				}
				_up=false; //reseta o valor do botão UP para false.
			}
			if(_down)  //se o botão DOWN tiver valor true.
			{
				if(tempH>0)
				{  //se a hora for maior que 0 horas.
					tempH--;  //diminui uma hora.
				}
				else
				{ //se a hora tiver valor 0.
					tempH = 23; //volta a hora 23.
				}
				_down=false; //reseta o valor do botão DOWN para false.
			}
			if(_yes) //se o botão YES tiver valor true.
			{
				//time.setHour(tempH);  //setta o minuto do rtc com o valor de tempH;
				clock.set_hora(tempH);
				_yes=false;  //reseta o valor do botão YES para false. Melhor fazer isso antes de avançar a track.
				doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
				track++;  //track avança para a proxima.
			}
			if(_no)  //se o botão NO tiver valor true.
			{
				doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
				_no=false;  //resetar o valor de YES para false.
				track = 0; //retorna a track 0 representando a hora.
				return true;
			}
			break;  //fim da logica da track 0 representando as horas.
		}
		case 1: //minuto
		{     
			if(_up)  //se o botão UP tiver valor true.
			{
				if(tempM<59)  //se o minuto for menor que 59.
				{
					tempM++; //adiciona um minuto a mais.
				}
				else  //se o minuto for 59.
				{
					tempM = 0;  //retornar ao minuto 0.
				}
				_up=false; //reseta o valor do botão UP para false.
			}
			if(_down)  //se o botão DOWN tiver valor true.
			{
				if(tempM>0)
				{  //se o minuto for maior que 0.
					tempM--;  //minuto diminui por um.
				}
				else
				{ //se o minuto for 0.
					tempM=59; //minuto retornar ao valor 59.
				}
				_down=false; //reseta o valor do botão DOWN para false.
			}
			if(_yes) //se o botão YES tiver valor true.
			{
				clock.set_minuto(tempM);
				_yes=false;  //reseta o valor do botão YES para false.
				doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
				track++;  //avança para a proxima track.
			}
			if(_no)  //se o botão NO tiver valor true.
			{
				doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
				_no=false; //reseta o valor do botão NO para false.
				track--;  //retorna a track anterior.
			}
			break;  //fim da logica da track 1 representando os minutos.
      
		}
		case 2: //dia
		{ 
			if(_up)
			{  //se o botão UP tiver valor true.  
				if(tempMn==2)
				{  //se o mes for fevereiro
					if(tempD<29)
					{ //se o dia for menor que 29
						tempD++;  //adiciona um dias a mais.
					}
					else
					{ //se o dia for 29(ou mais).
						tempD = 1;  //volta ao primeiro dia do mes.
					}
				}
				else if(tempMn<8)
				{  //se o mes for antes de agosto
					if(tempMn % 2 != 0)
					{  //se o mes for impar(meses impares antes de agosto tem 31 dias)
						if(tempD<31)
						{ //se o dia for menor que 31.
							tempD++;  //adiciona um dia a mais.
						}
						else
						{ //se o dia for 31.
							tempD = 1;  //volta ao primeiro dia do mes.
						}
					}
					else
					{ //se o mes for par(meses pares antes de agosto tem 30 dias exceto por fevereiro.)
						if(tempD<30)
						{ //se o dia for menor que 30.
							tempD++;  //adiciona um dia a mais.
						}
						else
						{ //se o dia for 30.
							tempD = 1;  //volta ao primeiro dia do mes.
						}
					}
				}
				else
				{ //se o mes for pelo menos agosto.
					if(tempMn % 2 == 0)
					{ //se o mes for par(mese pares a partir de agosto tem 31 dias)
						if(tempD<31)
						{ //se o dia for menor que 31.
							tempD++;  //adiciona um dia a mais.
						}
						else
						{ //se o dia for 31.
							tempD = 1;  //volta ao primeiro dia do mes.
						}
					}
					else
					{ //se o mes for impar(mese impares a partir de agosto tem 30 dias.
						if(tempD<30)
						{ //se o dia for menor que 30.
							tempD++;  //adiciona um dias a mais.
						}
						else
						{ //se o dia for 30.
							tempD = 1;  //volta ao primeiro dias do mes.
						}
					}
				}
				_up=false; //reseta o valor do botão UP para false.
			}
			if(_down)
			{  //se o valor do botão DOWN for true.
				if(tempD>1)
				{  //se o dia for maior que 1.
					tempD--;
				}
				else
				{ //se o dia for 1.
					if(tempMn==2)
					{  //se o mes for fevereiro.
						tempD = 28; //dia retornar a 28.
					}
					else if(tempMn<8)
					{  //se o mes não for fevereiro e for antes de agosto.
						if(tempMn % 2 == 0)
						{  //se o numero do mes for par.(meses pares antes de agosto tem 30 dias exceto por fevereiro)
							tempD = 30; //dia retorna a 30.
						}
						else
						{ //se o numero do mes for impar(31 dias).
							tempD = 31; //dia retorna a 31.
						}
					}
					else
					{ //se o mes não for vereiro e for pelo menos agosto.
						if(tempMn % 2 == 0)
						{  //se o numero do mes for par.(meses pares a partir de agosto tem 31 dias)
							tempD = 31; //dia retorna a 31.
						}
						else
						{ //se o numero do mes for impar.(30 dias)
							tempD = 30; //dia retorna a 30.
						}
					}
				}
				_down=false; //reseta o valor do botão DOWN para false.
			}
			if(_yes) //se o valor do botão YES for true.
			{
				_yes=false;  //reseta o valor do botão YES para false.
				clock.set_dia(tempD, tempMn);
				doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
				track++;  //avança ao proximo track.
			}
			if(_no)  //se o valor do botão NO for true.
			{
				doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
				_no=false; //reseta o valor do botão NO para false.
				track--;  //retorna a track anterior.
			}
			break;  //final da track 2 do dia.
		}
		case 3: //mes
		{
			if(_up)  //se o valor do botão UP for true.
			{
				if(tempMn <12)
				{ //se o mes for antes de dezembro.
					tempMn++; //adiciona um mes.
				}
				else
				{ //se o mes for dezembro.
					tempMn = 1; //retorna ao mes 1
				}
				_up=false; //reseta o valor do botão UP para false.
			}
			if(_down)  //se o valor do botão DOWN for true.
			{
				if(tempMn>1)
				{ //se o mes for maior que 1.
					tempMn--; //diminuit um mes.
				}
				else
				{ //se o mes for 1;
					tempMn = 12;  //retorna ao mes 12.
				}
				_down=false; //reseta o valor do botão DOWN para false.
			}
			if(_yes) //se o valor do botão YES for true.
			{
				_yes=false;  //reseta o valor do botão YES para false.
				clock.set_mes(tempMn);
				if(tempD>28)
				{  //se o dia for maior ou igual a 28 quando o mes for mudado.
					if(tempMn==2)
					{  //se o mes for fevereiro
						tempD=28; //tempD muda para dia 28.
						clock.set_dia(tempD, tempMn);
					}
					else if(tempD>30)
					{  //se o mes não for fevereiro e o dia for maior que 31.
						if(tempMn < 8)
						{ //se o mes for antes de agosto.
							if(tempMn % 2 == 0)
							{ //se o mes for par(meses pares antes de agosto tem 30 dias).
								tempD = 30; //tempD muda para dia 30.
								clock.set_dia(tempD, tempMn);
							}
						}
						else if(tempMn % 2 != 0)
						{ //se o mes for pelo menos agosto e impar(meses impares a partir de agosto tem 30 dias).
							tempD = 30; //tempD muda para dia 30.
							clock.set_dia(tempD, tempMn);
						}
					}
				}
				doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.        
				track++;  //avança para a proxima track.
			}
			if(_no)  //se o valor do botão NO for true.
			{
				doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
				_no=false; //reseta o valor do botão NO para false.
				track--;  //retorna a track anterior.
			}      
			break;  //final da track 3.
		}
		case 4: //ano
		{
			if(_up)  //se o valor do botão UP for true.
			{
				tempY++;  //adiciona um numero ao valor de ano.
				_up=false; //reseta o valor do botão UP para false.
			}
			if(_down)  //se o valor do botão DOWN for true.
			{
				tempY--;  //diminui o valor de ano.
				_down=false; //reseta o valor do botão DOWN para false.
			}
			if(_yes) //se o valor do botão YES for true.
			{
				clock.set_ano(tempY);
				doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
				_yes=false;  //resetar o valor de YES para false.
				track = 0; //retorna a track 0 representando a hora.
				return true;
			}
			if(_no)  //se o valor do botão NO for true.
			{
				doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
				_no=false; //resetar o valor do botão NO para false.
				track--;  //retornar a track anterior.
			}
			break;  //fim da track 4 representando o ano
		}
	}
	return false;
}

int red_beryl::getPoint()
{
	return _pointGain;
}
bool red_beryl::deletaLeitura(int delPos)
{   /* Função deletaLeitura, recebe como paramento um int delPos(deleta posição) que será a posição da leitura na EEPROM a ser deletada. */
	if(delPos>EEPROM.read(0) || delPos<0 )
	{    //verificar se o numero recebido esta dentro do numero de leituras possiveis.
		Serial.println("Numero de posição recebido superior ao numero de leituras reconhecidas na EEPROM, ou Negativo. Retornando 'false'");
		return false;
	}
	else
	{   //se o numero recebido estiver dentro do numero de leituras possiveis
		leitura lTemp;    //inicializa uma leitura temporaria para receber o valor de leitura do proximo valor e substituir no valor atual.
		int limit = ((EEPROM.length()-3)/sizeof(leitura));
		
		warning("Deletando...");
		
		upperBar();
		display.display();
		
		for(int i=delPos;(i<EEPROM.read(0) && i<limit);i++)
		{   //EEPROM.get((22*i)+1,leituraTemp);    //leituraTemp recebe a leitura da EEPROM.
                                              //EEPROM.put( ((EEPROM.read(0)*22)+1)  , leitura0);   //salva a nova leitura na EEPROM.
			EEPROM.get( 1+ (sizeof(leitura)*(i+1)) ,lTemp );   //lTemp recebe o valor da proxima leitura.
			EEPROM.put( 1+ (sizeof(leitura)*i), lTemp );       //endereço EEPROM selecionado atual[i] recebe lTemp.
			Serial.print("Posição ");Serial.print(i);Serial.print(" substituida por leitura na posição ");Serial.println(i+1);
		}
		if(EEPROM.read(0)<=limit)
		{
			for(int i=1+(EEPROM.read(0)*sizeof(leitura)); i<=(EEPROM.read(0)+1)*sizeof(leitura); i++)
			{    //logica de apagar o ultimo endereço.
				EEPROM.write(i,0);
				Serial.println("Endereço final apagado.");
			}
			EEPROM.write(0, EEPROM.read(0)-1);    //diminui o valor do endereço 0 da EEPROM.
		}
		else
		{
			for(int i=1+(limit*sizeof(leitura)); i<=(limit)*sizeof(leitura); i++)
			{
				EEPROM.write(i,0);
				Serial.println("Endereço final apagado, alterando valor total.");
			}
			EEPROM.write(0, limit-1);    //diminui o valor do endereço 0 da EEPROM.
		}
		
		Serial.println("DeletaLeitura concluido.");
		return true;
	}
}

void red_beryl::imprimeEscolha(int i, int l, leitura lt, bool s)
{    //função imprimeEscolha, que recebe o i da posição, a struct leitura com os valores e o bool s se for selecionado ou não.
	display.setCursor(2, lineSize*l);    //reseta a posição do cursor, multiplicando o tamanho de uma linha pelo numero de linhas
	if(s)
	{    //se a linha for selecionada
		display.setTextColor(BLACK,WHITE);    //Define a fonte na cor preta com fundo branco, selecionado.
	}
	else
	{
		display.setTextColor(WHITE);    //Define a fonta na cor branca, selecionado.
	}
	display.print(i);   //posição da leitura no historico.
	display.print("- ");
	display.print(lt.dia);   //imprime o valor dia.
	display.print("/");    //separador
	display.print(lt.mes);   //imprime o valor mes.
	display.print("/");    //separador
	display.print(lt.ano);    //imprime o valor ano.
	display.print(" ");   //espaço.
	display.print(lt.hora);   //imprime valor hora.
	display.print(":");   //separador de horario.
	if(lt.minuto<10)
	{
		display.print("0");
	}
	display.print(lt.minuto);   //imprime valor minuto.
}

void red_beryl::scrollBar(int j)
{
    //CONSERTAR O MOVIMENTO DE LAGARTA QUE A SCROLL BAR ESTA FAZENDO NO MOMENTO MAS NÃO RETIRAR O MOVIMENTO DE EXPANSÃO.
    int offset = 100*(3*8)/(EEPROM.read(0)*8);
    //Inicializando um int offset que vai receber um a divisão do tamanho de uma tela pelo numero de opções multiplicadas pelo tamanho de uma linha, tudo multiplicado por 100.
    offset = map(offset,1,100,(3*8)-1,0);
    
    //mapeando o valor de offset de 1 a 100 para o tamanho da tela até 1, ou seja, quanto mais proximo de 100 offset for, menor o offset será, em relação ao tamanho livre na tela,
    // desaparecendo em 100 ou mais. de forma que, quando tiver apenas tres opções ou menos, a barra de scroll não aparecerá, mas a partir de quatro opções, a barra cobrira 75% do espaço livre
    //na tela, dividindo os 25% restantes entre o [numero de opções -1], no caso [4-1=(3)], cada opção alem da selecionada contara com aproximadamente 8,333% para fazer offset relevante a posição
    //da opção selecionada(j)

    offset/=(EEPROM.read(0)-1);   //dividindo o offset pelo numero de opções -1.
    
    if(offset==0){
      offset=1;
    }
    display.drawLine(display.width()-1, (lineSize+(j*offset)/2), display.width()-1,display.height()-1-((EEPROM.read(0)-(j+1))*offset)/2, WHITE);
}

void red_beryl::warning(const char *s)
{
	display.fillRect(20, lineSize+4, display.width()-40, lineSize+4, BLACK);
	display.drawRect(20, lineSize+4, display.width()-40, lineSize+4, WHITE);
	if (strlen(s)*6 < display.width()-40 )
	{
		display.setCursor((display.width()/2)-strlen(s)*6/2, lineSize*2-2);
		display.setTextColor(WHITE);
		display.setTextSize(1);
		display.print(s);
	}
	else
	{
		display.setCursor((display.width()/2)-7*6/2, lineSize*2-2);
		display.setTextColor(WHITE);
		display.setTextSize(1);
		display.print("Ocupado");
	}
}
void red_beryl::warning(const char *s, const char *s2)
{
	display.fillRect(20, lineSize, display.width()-40, lineSize*2+2, BLACK);
	display.drawRect(20, lineSize, display.width()-40, lineSize*2+2, WHITE);
	if (strlen(s)*6 < display.width()-40 && strlen(s2)*6 < display.width()-40)
	{
		display.setCursor((display.width()/2)-strlen(s)*6/2, lineSize+1);
		display.setTextColor(WHITE);
		display.setTextSize(1);
		display.print(s);
		
		display.setCursor((display.width()/2)-strlen(s2)*6/2, lineSize*2+1);
		display.print(s2);
	}
	else
	{
		display.setCursor((display.width()/2)-7*6/2, lineSize+5);
		display.setTextColor(WHITE);
		display.setTextSize(1);
		display.print("Ocupado");
	}
}

void red_beryl::menuOption(const char *s, int pos, bool ch)
{
	display.setCursor(2, lineSize*pos);
	if(ch)
	{
		display.setTextColor(BLACK, WHITE);
	}
	else
	{
		display.setTextColor(WHITE);
	}
	display.print(s);
}
