/*
	red_beryl.h - Biblioteca criada com a função de assistir na programação do medidor de bioimpedancia
	Criado por Vitor H. Cardoso. 20 de fevereiro, 2018
*/

#include "red_beryl.h"
#include <Wire.h>
#include <Adafruit_SSD1306.h>
#include <Adafruit_GFX.h>
#include <leituras.h>
#include <red_crystal.h>

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
	Wire.begin();

	display.begin(SSD1306_SWITCHCAPVCC, 0x3C, false);
	Serial.println("display inicializado.");
	display.display();
	delay(500);
	display.clearDisplay();
	
	display.setCursor(display.width()/2-(3*2*6/2),display.height()/2-(1*2*7/2)+2);
	display.setTextColor(WHITE);
	display.setTextSize(2);
	display.print("mbi");
	display.setTextSize(1);
	display.setCursor(1, 0);
	display.print("M.A.Engenharia");
	display.display();

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
	
	leitura0 = {0,0,0,0,0,0,0,0};
	/*struct leitura leitura0;
	
	
	
	Serial.println(leitura0.freq);
	Serial.println(leitura0.real);
	Serial.println(leitura0.imag);
	Serial.println(leitura0.hora);
	Serial.println(leitura0.minuto);
	Serial.println(leitura0.dia);
	Serial.println(leitura0.mes);
	Serial.println(leitura0.ano);
	
	Serial.println("now the crystal reading:");
	*/
}

void red_beryl::checarPin()
{
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
	static int pwr;   //declara o inteiro estatico pwr(POWER)
	static int pct;   //declara o inteiro estatico pct(PERCENTAGE)
  
	/*display.fillRect(0, 0, display.width(), barSize, BLACK); // desenha a barra em preto, mantendo permanentemente a barrar acima de tudo.
  
	pwr = analogRead(potPin);   //pwr le o valor analogico do potenciometro, recebendo o valor 'raw' da bateria.
	pct = map(pwr,0,1023,0,100);    //pct recebe o valor mapeado de pwr entre 0-100.
	pwr = map(pwr, 0, 1023, 0, 12);   //pwr recebe o valor mapeado entre0-12
	*/
	pct = getBatteryPct();
	pwr = map(pct, 0, 100, 0, 12);
  
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

	//clock(); //chama o relogio, A FAZER: alterar coordenadas de impressão do relogio para canto superior DIREITO
	display.drawBitmap(display.width()-BAT8_WIDTH, 0, bat_6x16_bmp, BAT8_WIDTH, BAT8_HEIGHT, WHITE); // desenha o contorno da bateira no canto superior ESQUERDO. 6 de altura, 16 de largura
	//display.drawBitmap(0, 0, BT_9_bmp, BT9_WIDTH, BT9_HEIGHT, WHITE); // desenha o simbolo de bluetooth depois da bateria. 9 de altura, 8 de largura.
	
	if(true)		//LEMBRAR DE RETORNA ISSO A """IF(BLE)"""
	{
		display.drawBitmap(0, 0, BT2_bmp, BT2_WIDTH, BT2_HEIGHT, WHITE);
	}
	/*display.setCursor(BT2_WIDTH+5,0);

	static unsigned long mill = 0;
	static unsigned long tempMill = 0;
	
	
				static double temperature = AD5933::getTemperature();		//TRANSFERIR PARA RED_CRYSTAL

	mill = millis();
	if( (mill - tempMill) > 1000){
				temperature = AD5933::getTemperature();						//TRANSFERIR PARA RED_CRYSTAL
		tempMill = mill;
	}
	display.setTextSize(1);
	display.setTextColor(WHITE);
	display.print((int) temperature);
	display.print("C");
	display.write((uint8_t) 247);
	*/
}

void red_beryl::menu()
{
	display.clearDisplay();
	checarPin();
	upperBar();
	static int choice=1;
	static char* menu[] = { "0.default", "1.Leituras", "2.Sincronizar", "3.Ajustes" };
	switch(choice){
		case 11:		//Menu Leituras
		{
			if(!menu_leitura()){		//chama a função [bool] menu_leitura, se retornar [false], retorna a opção 1 do menu.
				choice = 1;
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
			display.setCursor(2, lineSize);   		 							//define a posição do cursor
			display.setTextColor(BLACK);    									//define a cor do texto como preto.
			display.print(menu[1]);    											//imprime a string previamente inicializada.
      
			display.setCursor(2, lineSize*2);   								//define a posição do cursor para a proxima linha
			display.setTextColor(WHITE);    									//define a cor do texto como branca
			display.println(menu[2]);    										//imprime a string previamente inicializada.
      
			display.setCursor(2, lineSize*3);  									//define a posição do cursor para a proxima linha
			display.setTextColor(WHITE);    									//define a cor do texto como branca.
			display.println(menu[3]);    										//imprime a string previamente inicializada.

			if(_yes){
				choice=11;
			}
			break;
		}
		case 2:			//Sincronização(bluetooth)
		{
			display.setCursor(2, lineSize);   									//define a posição do cursor para a proxima linha
			display.setTextColor(WHITE);    									//define a cor do texto como branca
			display.println(menu[1]);    										//imprime a string previamente inicializada.
			
			display.fillRect(1, lineSize*2, display.width()-5, lineSize, WHITE);//desenha um quadrado em volta da opção 1 selecionada
			display.setCursor(2, lineSize*2);   		 						//define a posição do cursor
			display.setTextColor(BLACK);    									//define a cor do texto como preto.
			display.print(menu[2]);    											//imprime a string previamente inicializada.
			
			display.setCursor(2, lineSize*3);   								//define a posição do cursor para a proxima linha
			display.setTextColor(WHITE);    									//define a cor do texto como branca
			display.println(menu[3]);    										//imprime a string previamente inicializada.
			
			if(_yes){
				choice=21;
			}
			break;
		}
		case 3:			//Ajustes(opções)
		{
			display.setCursor(2, lineSize);   									//define a posição do cursor para a proxima linha
			display.setTextColor(WHITE);    									//define a cor do texto como branca
			display.println(menu[1]);    										//imprime a string previamente inicializada.
			
			display.setCursor(2, lineSize*2);   								//define a posição do cursor para a proxima linha
			display.setTextColor(WHITE);    									//define a cor do texto como branca
			display.println(menu[2]);    										//imprime a string previamente inicializada.
			
			display.fillRect(1, lineSize*3, display.width()-5, lineSize, WHITE);//desenha um quadrado em volta da opção 1 selecionada
			display.setCursor(2, lineSize*3);   		 						//define a posição do cursor
			display.setTextColor(BLACK);    									//define a cor do texto como preto.
			display.print(menu[3]);    											//imprime a string previamente inicializada.
			
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
	display.display();
}
bool red_beryl::menu_leitura()
{
	
}
bool red_beryl::menu_sinc()
{
	
}
bool red_beryl::menu_ajuste()
{
	
}
bool red_beryl::nova_leitura()
{
	
}
bool red_beryl::historico()
{
	
}
bool red_beryl::relogio()
{
	
}