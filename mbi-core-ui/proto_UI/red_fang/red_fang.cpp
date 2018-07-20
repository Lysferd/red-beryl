/*
	red_fang.h - Biblioteca criada com a função de assistir na programação do medidor de bioimpedancia
	Criado por Vitor H. Cardoso. 02 de março, 2018
*/

#include "red_fang.h"
#include <Wire.h>
#include <leituras.h>
#include <EEPROM.h>
#include <red_beryl.h>

red_fang::red_fang()
{
	Serial.begin(19200);
	Serial.println("Construtor basico red_fang utilizado.");
	_Get=false;
	_Req=false;
	_complex=false;
	_isBeingUsed=false;
	_freq = 1010;
	_num = 0;
	Serial1.begin(9600);
	Serial.end();
}

void red_fang::ler_serial()
{	

	if(_Get)
	{
		get(_num, _complex);
	}
	else if(_Req)
	{
		static bool done = false;
		static leitura lt;
		Serial.println("before reading");
		if(!done)
		{
			Serial.println("Começar leitura");
			
			lt = beryl->crystal.lerAD(beryl->getPoint());
			/*
			int h = beryl->clock.hora();
			int	m = beryl->clock.minuto();
			int d = beryl->clock.dia();
			int mn = beryl->clock.mes();
			int a = beryl->clock.ano();
			*/
			
			lt.hora = beryl->clock.hora();
			lt.minuto = beryl->clock.minuto();
			lt.dia = beryl->clock.dia();
			lt.mes = beryl->clock.mes();
			lt.ano = beryl->clock.ano();
						
			Serial.println("Leitura concluida.");
			if((EEPROM.length()-2)-(EEPROM.read(0)*sizeof(leitura))>=sizeof(leitura))
			{
				EEPROM.put( ( ( EEPROM.read(0)*sizeof(leitura) )+1)  , lt);  //salva a nova leitura na EEPROM.
				Serial.println("Salvo na EEPROM.");
				EEPROM.write(0 , ( EEPROM.read(0)+1 ));    //o valor da posição '0' recebe 'i'.
			}
			else
			{
				int limit = ((EEPROM.length()-3)/sizeof(leitura));
				Serial.println("EEPROM cheia, subtituindo endereços endereço");
				EEPROM.put( ( ((EEPROM.read(0)-limit)*sizeof(leitura) )+1) , lt);
				EEPROM.write(0 , ( EEPROM.read(0)+1 ));
			}
			
			done=true;
		}
		else
		{
			/*static int inf = 0;
			if(!serialLeitura(lt, inf))
			{
				if(inf!=3)
				{
					inf++;
					delay(20);
				}
			}
			else if(inf==3)
			{
				inf++;
			}
			else
			{
				inf=0;
				_Req = false;
				done = false;
			}*/
			static int inf=0;
			if(!serialLeitura(lt, inf))
			{
				inf++;
			}
			else
			{
				inf=0;
				_Req = false;
				done = false;
				_isBeingUsed = false;
			}
		}
	}
	else if(Serial1.available()!=-1 && Serial1.available()!=  0 && Serial1.available()>=3)		//Se tiver algo na serial1.
	{
		char comStr[4];
		int i=0;
		Serial.print("Serial1 enviou algo: "); Serial.print(Serial1.available()); Serial.println(" caracteres.");
		while(Serial1.available()>0 && i<3 )
		{
			Serial.print(i);
			comStr[i]=Serial1.read();
			Serial.print(comStr[i]);
			i++;
			comStr[i]= '\0';
		}
		Serial.println("");
		Serial.println(comStr);
		check_string(comStr);
	}
}

void red_fang::check_string(char str[])
{
	_isBeingUsed = true;
	if(strcmp(str, "VER")==0)
	{
		serialEnviar(VERSION);
		Serial.print("versão: ");
		Serial.println(VERSION);
	}
	else if(strcmp(str, "CHK")==0)
	{
		char num[4];
		itoa (EEPROM.read(0),num, 10);
		
		serialEnviar(num);
	}
	else if(strcmp(str, "BAT")==0)		//Se o comando recebido for BAT, retorna o valor da bateria.
	{    
		char bat[4];
		itoa (beryl->getBatteryPct(), bat, 10);
		serialEnviar(bat);
		Serial.print("Bateria em : ");
		Serial.println(bat);
    }
	else if(strcmp(str, "CLR")==0)
	{    //Se o comando recebido for CLR, realiza a logica de Fast Clear, limpando o primeiro endereço da EEPROM.
		if(Serial1.available()!=-1 && Serial1.available()!=0)    //checa se recebeu mais alguma coisa por bluetooth.
		{
			char inStr[30];
			int i=0;
			while(Serial1.available()!=-1 && Serial1.available()!=0)
			{
				inStr[i]=Serial1.read();
				Serial.print(inStr[i]);
				i++;
				inStr[i]= '\0';
			}
			Serial.print("|");
			Serial.println(inStr);
			char *ptr;
			_num = strtol(inStr, &ptr, 10);
			Serial.print("NUM=");
			Serial.println(_num);
			Serial.print("PTR='");
			Serial.print(ptr);
			Serial.println("'");
			if(deletaLeitura(_num-1))
			{
				Serial.println("Concluido.");
				serialEnviar("OK");
			}
			else
			{
				Serial.println("ERRO, não foi possivel deletar a leitura.");
				Serial.print("ERR");
				_isBeingUsed = false;
			}
		}
		else
		{
			//FAST CLEAR = APENAS MARCAR A POSIÇÃO 0 DA EEPROM COMO 0.
			EEPROM.write(0,0);
			Serial.println("Limpeza rapida concluida.");
			serialEnviar("OK");
		}
    }
	else if(strcmp(str, "WIP")==0)
	{    //Se o comando recebido for WIP, realiza a logica de limpar os endereços da EEPROM que estão sendo usados.
		//WIPE MEMORY = LIMPAR OS ENDEREÇOS DA EEPROM RECONHECIDOS PELA POSIÇÃO 0(INDEX).
		if(EEPROM.read(0)>0)
		{
			int i=1;
			while(i<1+(EEPROM.read(0)*(sizeof(leitura))))
			{
				EEPROM.write(i,0);
				i++;
			}
			EEPROM.write(0,0);
			Serial.println("Wipe realizado com sucesso");
			serialEnviar("OK");
		}
		else
		{
			Serial.println("Wipe impossivel, historico ja limpo");
			serialEnviar("OK");
		}
    }
	else if(strcmp(str, "TMP")==0)
	{    //Se o comando recebido for TMP, retorna o valor de temperature na AD.
		Serial.println("Enviando temperatura.");
		double temperature = beryl->crystal.temperatura();
		char tempChar[30];
		dtostrf(temperature, 6, 2, tempChar);
		serialEnviar(tempChar);      
    }
	else if(strcmp(str, "CLK")==0)
	{    //Se o comando recebido for CLK, realiza a logica de relogio.
		delay(10);
		char inStr[30];
		if(Serial1.available()!=-1 && Serial1.available()!=0)
		{//checa se recebeu mais alguma coisa por bluetooth,.
			int dia,mes,ano,hora,minuto,segundo;                //inicializa as variaveis tmeporarias para receber os valores de dat e hora
			while(Serial1.available()<12)
			{                      //enquanto o buffer não estiver com todos os caracteres prontos, fazer delay.
				Serial.print("Aguardando o buffer receber todos os caracteres antes de avançar. ");
				Serial.print(Serial1.available());
				Serial.println(" Recebidos.");
				delay(10);
			}
			int n=0;    //inicializa um i temporario.
			char *ptr;
			Serial.println("Atualizando Hora e Data.");
			while(n<12)
			{                                        //enquanto n for menor que 12.
				delay(1);
				if(n<2)
				{    //primeira dupla de valores: DIA
					inStr[n]=Serial1.read();
				}
				else if(n<4)
				{   //segunda dupla de valores: MES
					inStr[n-2]=Serial1.read();
				}
				else if(n<6)
				{   //terceira dupla de valores: ANO
					inStr[n-4]=Serial1.read();
				}
				else if(n<8)
				{   //quarta dupla de valores: HORA
					inStr[n-6]=Serial1.read();
				}
				else if(n<10)
				{    //quinta dupla de valores: MINUTO
					inStr[n-8]=Serial1.read();
				}
				else if(n<12)
				{    //sexta dupla de valores: SEGUNDO
					inStr[n-10]=Serial1.read();
				}

          //VERIFICAR O CODIGO, VER SE TODOS OS 'i' FORAM MUDADOS PARA 'n', DAR UMA OLHADA NO CODIGO DE 'inStr' para ver se esta funcionando corretamente.
          
				n++;    //incrementa i;
				inStr[2]='\0';  //finalizador de string na terceira posição
          
				if(n==2)
				{   //primeiro valor: DIA
					delay(1);
					Serial.print(inStr);
					dia = strtol(inStr, &ptr, 10);
					/*time.setDate(dia);    //alterar DIA no RTC    //comentado por enquanto para que o sistema possa primeiro verificar se os valores recebidos são validos.
					* não vai ser possivel testar imediatamente no dia, testar no mes
					* cria uma função testarDia que recebe os valores de diae mes e retorne se são validos...
					* talvez seja melhor criar uma função testarData, [bool testarData(int dia, int mes, int ano, int hora, int minuto, int segundo)]
					* retorna false se invalido, true se valido.
					*/
             
					Serial.println(" - dia atualizado.");
				}
				if(n==4)
				{   //segundo valor: MES
					delay(1);
					Serial.print(inStr);
					mes = strtol(inStr, &ptr, 10);
					//time.setMonth(mes);   //alterar MES no RTC
					Serial.println(" - mes atualizado.");
				}
				if(n==6)
				{   //terceiro valor: ANO
					delay(1);
					Serial.print(inStr);
					ano = strtol(inStr, &ptr, 10);
					//time.setYear(ano);    //alterar ANO no RTC
					Serial.println(" - ano atualizado.");
				}
				if(n==8)
				{   //quarto valor: HORA
					delay(1);
					Serial.print(inStr);
					hora = strtol(inStr, &ptr, 10);
					//time.setHour(hora);   //alterar HORA no RTC
					Serial.println(" - hora atualizada.");
				}
				if(n==10)
				{  //quinto valor: MINUTO
					delay(1);
					Serial.print(inStr);
					minuto = strtol(inStr, &ptr, 10);
					//time.setMinute(minuto);   //alterar MINUTO no RTC
					Serial.println(" - minuto atualizado.");
				}
				if(n==12)
				{  //sexto valor: SEGUNDO
					delay(1);
					Serial.print(inStr);
					segundo = strtol(inStr, &ptr, 10);
					//time.setSecond(segundo);    //alterar SEGUNDO no RTC
					Serial.println(" - segundo atualizado");
				}
			}
			if( beryl->clock.testa_segundo(segundo) &&
				beryl->clock.testa_minuto(minuto) &&
				beryl->clock.testa_hora(hora) &&
				beryl->clock.testa_dia(dia, mes) &&
				beryl->clock.testa_mes(mes) &&
				beryl->clock.testa_ano(ano) )
			{
				beryl->clock.set_segundo(segundo);
				beryl->clock.set_minuto(minuto);
				beryl->clock.set_hora(hora);
				beryl->clock.set_dia(dia, mes);
				beryl->clock.set_mes(mes);
				beryl->clock.set_ano(ano);
					
				Serial.println("Data e Hora Atualizados");
				serialEnviar("OK");
			}
			else
			{                                               //se o valor recebido for invalido.
				Serial1.print("ERR");                             //retorna um erro.
				_isBeingUsed = false;
			}
		}
		else
		{                                                 //se não receber mais nada depois de CLK.
			char clk[30], filler[5];                            //inicializa os arrays clk para montar o array com as informações de hora e data, e filler para ajudar a construir clk
			itoa(beryl->clock.dia(), filler, 10);                   //filler recebe o valor traduzido de date.
			if(beryl->clock.dia()<10)
			{                              //se o valor de date for inferior a 10, clk recebe 0 e depois o valor de date.
				strcpy (clk, "0");                                //clk recebe [0].
				strcat( clk, filler );                            //adiciona o conteudo de filler(date) ao final da string.
			}
			else
			{                                               //se o valor de date for maior que 10, apenas recebe o valor de date.
				strcpy (clk, filler );                            //recebe o valor da string(date).
			}
			strcat (clk, "/");                                  //adiciona o separador de data '/' ao final da string.
			itoa(beryl->clock.mes(), filler, 10);           //filler recebe o valor traduzido de month.
			if(beryl->clock.mes()<10)
			{                      //se o valor de month for inferior a 10, '0' é adicionado ao final da string.
				strcat( clk, "0");                                //adiciona o valor '0' ao final da string.
			}
			strcat(clk, filler);                                //adiciona o conteudo de filler(month) ao final da string.
			strcat(clk, "/");                                   //adiciona o separador de data '/' ao final da string.
			itoa(beryl->clock.ano(), filler, 10);                   //filler recebe o valor traduzido de year.
			if(beryl->clock.ano()<10)
			{                              //se o valor de year for inferior a 10, '0' é adicionado ao final da string.
				strcat (clk, "0");                                //adiciona o valor '0' ao final da string.
			}
			strcat(clk, filler);                                //adiciona o conteudo de filler(year) ao final da string.
			strcat(clk, " ");                                   //adiciona um espaço de separação entre data e hora ao final da string.
			itoa(beryl->clock.hora(), filler, 10);                //filler recebe o valor traduzido de hour.
			if(beryl->clock.hora()<10)
			{                       //se o valor de hour for inferior a 10, '0' é adicionado ao final da string.
				strcat (clk, "0");                                //adiciona o valor '0' ao final da string.
			}
			strcat(clk, filler);                                //adiciona o conteudo de filler(hour) ao final da string.
			strcat(clk, ":");                                   //adiciona o separador de hora ':' ao final da string.
			itoa(beryl->clock.minuto(), filler, 10);                     //filler recebe o valor traduzido de minute.
			if(beryl->clock.minuto()<10)
			{                            //se o valor de minute for inferior a 10, '0' é adicionado ao final da string.
				strcat (clk, "0");                                //adiciona o valor '0' ao final da string.
			}
			strcat(clk, filler);                                //adiciona o conteudo de filler(minute) ao final da string.
			serialEnviar(clk);                                  //envia a string construido a função serialEnviar() para ser enviada ao bluetooth.
			Serial.println("Data e Hora enviados.");            //envia confirmação ao serial monitor(debug).
		}
    }
	else if(strcmp(str, "GET")==0 || strcmp(str, "GTX")==0)
	{    //Se o comando recebido for GET, realiza logica para 'pegar' e retornar uma leitura salva.
		delay(10);
		char inStr[30];
		while(Serial1.available()!=-1 && Serial1.available()!=0){
			if(Serial1.available()>=1){
				int i=0;
				while(Serial1.available()!=-1 && Serial1.available()!=0){
					inStr[i]=Serial1.read();
					Serial.print(inStr[i]);
					i++;
					inStr[i]= '\0';
				}
			}
		}
		Serial.print("|");
		Serial.println(inStr);
		char *ptr;
		_num = strtol(inStr, &ptr, 10);
		Serial.print("INDEX=");
		Serial.println(_num);
		Serial.print("PTR='");
		Serial.print(ptr);
		Serial.println("'");
		_Get=true;
		if(!strcmp(str, "GTX")==0)
		{
			_complex=false;
		}
		else
		{
			_complex=true;
		}
    }
	else if(strcmp(str, "REQ")==0)
	{    //Se o comando recebido for REQ, realiza a logica de realizar uma nova leitura com a frequencia indicada.

		//SE A FREQUENCIA REQUISITA FOR INVALIDA(ABAIXO DE 1K OU ACIMA DE 100K) DEVOLVER UM ERRO/AVISO/ETC... A fazer
		delay(10);
		char inStr[30];
		while(Serial1.available()!=-1 && Serial1.available()!=0)
		{
			if(Serial1.available()>=4)
			{
				int i=0;
				while(Serial1.available()!=-1 && Serial1.available()!=0)
				{
					inStr[i]=Serial1.read();
					Serial.print(inStr[i]);
					i++;
					inStr[i]= '\0';
				}
			}
		}
		Serial.print("|");
		Serial.println(inStr);
		char *ptr;
		long frq = strtol(inStr, &ptr, 10);
		Serial.print("INDEX=");
		Serial.println(frq);
		Serial.print("PTR='");
		Serial.print(ptr);
		Serial.println("'");
		
		if(frq>=1000 && frq <=100000)
		{
			if(beryl->crystal.configurar(frq))
			{
				Serial.println("Configuração da AD concluida com sucesso.");
				_Req = true;
			}
			else
			{
				Serial.println("Configuração da AD falhou.");
				Serial1.print("ERR");
				_isBeingUsed = false;
			}
			
			//beryl->crystal.lerAD();
			/*
			if(frequencySweepCustom(index, 10 ))
			{
				Serial.print("Sweep usando frequencia ");
				Serial.print(index);
				Serial.println(" completa.");
				EEPROM.put( ((EEPROM.read(0)*22)+1)  , leitura0);  //salva a nova leitura na EEPROM.
				Serial.println("Salvo na EEPROM.");
				EEPROM.write(0,(EEPROM.read(0)+1));    //o valor da posição 'i' recebe '0'.
          
				Req = true;
			}	
			else
			{
				Serial.println("Sweep falhou, enviando erro.");
				Serial1.print("ERR");
			}*/
		}
		else
		{
			Serial.print("Valor de frequencia requerido não esta dentro dos limites validos, retornando ERRO.");
			Serial1.print("ERR");
			_isBeingUsed = false;
		}
    }
	else
	{
		Serial.println("Algo inesperado foi recebido, limpando o serial. Enviando ERRO");
		Serial1.print("ERR");
		_isBeingUsed = false;
		for (int i=0; i<10; i++){
			Serial1.read();
			if(Serial1.available()==0){
				i=10;
			}
		}
	}
}
void red_fang::serialEnviar(char message[])
{
	Serial1.print("S");
    Serial.println("[S] enviado.");
	Serial1.print(message);
    Serial.print("[");
    Serial.print(message);
    Serial.println("] enviado.");
	Serial1.print("E");
    Serial.println("[E] enviado.");
    delay(100);
	_isBeingUsed = false;
	//Serial1.flushRX();
}
bool red_fang::deletaLeitura(int delPos)

{   /* Função deletaLeitura, recebe como paramento um int delPos(deleta posição) que será a posição da leitura na EEPROM a ser deletada. */
	Serial.print("deletaleitura chamado com posição:");Serial.println(delPos);
	if(delPos>EEPROM.read(0) || delPos<0 )
	{    //verificar se o numero recebido esta dentro do numero de leituras possiveis.
		Serial.println("Numero de posição recebido superior ao numero de leituras reconhecidas na EEPROM, ou Negativo. Retornando 'false'");
		return false;
	}
	else
	{   //se o numero recebido estiver dentro do numero de leituras possiveis
		leitura lTemp;    //inicializa uma leitura temporaria para receber o valor de leitura do proximo valor e substituir no valor atual.
		for(int i=delPos;i<EEPROM.read(0);i++)
		{   //EEPROM.get((22*i)+1,leituraTemp);    //leituraTemp recebe a leitura da EEPROM.
                                              //EEPROM.put( ((EEPROM.read(0)*22)+1)  , leitura0);   //salva a nova leitura na EEPROM.
			EEPROM.get( 1+ ( sizeof(leitura)*(i+1) ) ,lTemp );   //lTemp recebe o valor da proxima leitura.
			EEPROM.put( 1+ ( sizeof(leitura)*i ), lTemp );       //endereço EEPROM selecionado atual[i] recebe lTemp.
			Serial.print("Posição ");Serial.print(i);Serial.print(" substituida por leitura na posição ");Serial.println(i+1);
		}
		for(int i= 1+ ( (EEPROM.read(0)-1)*sizeof(leitura)) ; i<=(EEPROM.read(0))*sizeof( leitura); i++)
		{    //logica de apagar o ultimo endereço.
			EEPROM.write(i,0);
			Serial.print("Apagando ");
			Serial.print(i);
			Serial.print("/");
			Serial.println((EEPROM.read(0))*sizeof( leitura));
		}
		EEPROM.write(0, EEPROM.read(0)-1);    //diminui o valor do endereço 0 da EEPROM.
		Serial.println("DeletaLeitura concluido.");
		return true;
	}
}

bool red_fang::serialLeitura(leitura lt, int i)
{    //função serialLeitura que retorna true quando completa para enviar uma leitura em pacotes divididos em ciclos.

	char lStr[30], filler[30];
	//strcpy (lStr, "Z");
	/*
	switch(i)
	{
		case 0:
		{
			strcpy (lStr, "S");
			strcat (lStr, "D");
			if(lt.dia<10){  strcat (lStr, "0"); }
			itoa (lt.dia,filler, 10);
			strcat (lStr, filler);
			strcat( lStr, "/");
			
			if(lt.mes<10){    strcat (lStr, "0"); }
			itoa ( lt.mes, filler, 10);    //filler recebe os caracteres traduzidos do valor mes.
			strcat ( lStr, filler );   //filler(mes) adicionado a string.
			strcat( lStr, "/" );    //Separador de data adicionado a string.
			
			if(lt.ano<10){   strcat(lStr, "0" );  }   //se o valor de ano for inferior a 10, a string recebe um 0.

			itoa (lt.ano, filler, 10);    //filler recebe os caracteres traduzidos do valor ano.
			strcat( lStr, filler);    //filler(ano) adicionado a string.
			strcat ( lStr, " ");    //espaço adicionado a string.
				
			if(lt.hora<10){   strcat(lStr, "0" );  }   //se o valor de hora for inferior a 10, a string recebe um 0.

			itoa (lt.hora, filler, 10);   //filler recebe os caracteres traduzidos do valor hora.
			strcat( lStr, filler);    //filer(hora) adicionado a string.
			strcat( lStr, ":");   //separador de hora adicionado a string.
				
			if(lt.minuto<10){   strcat(lStr, "0" );  }   //se o valor de minuto for inferior a 10, a string recebe um 0.

			itoa (lt.minuto, filler, 10);   //filler recebe os caracteres traduzidos do valor hora.
			strcat( lStr, filler);    //filler(minuto) adicionado a string.
			
			strcat (lStr, "|");
			
			strcat (lStr, "F");
			int n = snprintf(filler, 30, "%lu", lt.freq);   //PODE NÃO FUNCIONAR! filler recebe os caracteres traduzidos do valor frequencia.
			strcat( lStr, filler);    //filler(frequencia) adicionado a string.
			//serialEnviar(lStr);
			strcat (lStr, "|");

			strcat (lStr, "R"); 
			dtostrf(lt.real, 2, 2, &lStr[strlen(lStr)]);

			strcat (lStr, "J");   //Recebe o tag inicial do tipo de informação a ser enviada, J para Imaginario.
			dtostrf(lt.imag, 2, 2, &lStr[strlen(lStr)]); 
			
			Serial1.print(lStr);
			return false;
		}
		case 1:
		{
			//serialEnviar(lStr);
			
			//strcat (lStr, "|");
			
			//strcat (lStr, "Z");
			strcpy (lStr, "");

			
			for(int x=0; x<6; x++)
			{
				strcat (lStr, "|");
				strcat (lStr, "R");
				dtostrf(lt.arrayR[x], 2, 2, &lStr[strlen(lStr)]);
				strcat (lStr, "J");
				dtostrf(lt.arrayJ[x], 2, 2, &lStr[strlen(lStr)]);
			}
			//strcat (lStr, "E"); 
			//serialEnviar(lStr);
			Serial1.print(lStr);
			return false;
		}
		case 2:
		{
			strcpy (lStr, "");
			for(int x=6;x<11;x++)
			{
				strcat (lStr, "|");
				strcat (lStr, "R");
				dtostrf(lt.arrayR[x], 2, 2, &lStr[strlen(lStr)]);
				strcat (lStr, "J");
				dtostrf(lt.arrayJ[x], 2, 2, &lStr[strlen(lStr)]);
			}
			strcat (lStr, "E");
			Serial1.print(lStr);
			return true;
		}
	}
	*/
  
	switch(i)
	{    //usa-se switch case para dividir o que cada ciclo diferente deve fazer.
		case 0:
		{    //0 é referente ao primeiro ciclo referente a DATA e HORA da leitura.
			//char lStr[30], filler[30];    //Inicializar um char lStr para receber tudo e passar a proxima função e um filler para ajudar a construir lStr.
			strcpy (lStr, "S");
			strcat (lStr, "D");   //Recebe o tag inicial do tipo de informação a ser enviada, D para data.
      
			if(lt.dia<10)
			{
				strcat (lStr, "0"); 
			}              //se o valor de dia for inferior a 10, a string recebe um 0.
        
			itoa (lt.dia,filler, 10);   //filler recebe os caracteres traduzidos do valor dia.
			strcat (lStr, filler);    //filler(dia) adicionado a string
			strcat( lStr, "/");   //Separador de data adicionado a string.
        
			if(lt.mes<10)
			{
				strcat (lStr, "0");
			}    //se o valor de mes for inferior a 10, a string recebe um 0.
      
			itoa ( lt.mes, filler, 10);    //filler recebe os caracteres traduzidos do valor mes.
			strcat ( lStr, filler );   //filler(mes) adicionado a string.
			strcat( lStr, "/" );    //Separador de data adicionado a string.
        
			if(lt.ano<10)
			{
				strcat(lStr, "0" );
			}   //se o valor de ano for inferior a 10, a string recebe um 0.

			itoa (lt.ano, filler, 10);    //filler recebe os caracteres traduzidos do valor ano.
			strcat( lStr, filler);    //filler(ano) adicionado a string.
			strcat ( lStr, " ");    //espaço adicionado a string.
        
			if(lt.hora<10)
			{
				strcat(lStr, "0" );
			}   //se o valor de hora for inferior a 10, a string recebe um 0.

			itoa (lt.hora, filler, 10);   //filler recebe os caracteres traduzidos do valor hora.
			strcat( lStr, filler);    //filer(hora) adicionado a string.
			strcat( lStr, ":");   //separador de hora adicionado a string.
        
			if(lt.minuto<10)
			{
				strcat(lStr, "0" );
			}   //se o valor de minuto for inferior a 10, a string recebe um 0.

			itoa (lt.minuto, filler, 10);   //filler recebe os caracteres traduzidos do valor hora.
			strcat( lStr, filler);    //filler(minuto) adicionado a string.

			//serialEnviar(lStr);   //a string construida até aqui é enviada a função serialEnviar() para ser enviada ao bluetooth dentro do pacote S||E.
      
			Serial1.print(lStr);
			return false;   //retorna false
			break;
		}
		case 1:
		{    //1 é referente ao segundo ciclo referente ao valor REAL da leitura.
			//char lStr[30];    //Inicializar um char lStr para receber tudo e passar a proxima função.
			strcpy (lStr, "|");
			strcat (lStr, "R");   //Recebe o tag inicial do tipo de informação a ser enviada, R para Real.
			dtostrf(lt.real, 2, 2, &lStr[strlen(lStr)]);    //Recebe o valor real.
			//serialEnviar(lStr);   //chama a função serialEnviar.
			Serial1.print(lStr);
			return false;   //retorna false
			break;	
		}
		case 2:
		{    //2 é referente ao terceiro ciclo referente ao valor IMAGINARIO da leitura.
			//char lStr[30];    //Inicializar um char lStr para receber tudo e passar a proxima função.
			strcpy (lStr, "J");   //Recebe o tag inicial do tipo de informação a ser enviada, J para Imaginario.
			dtostrf(lt.imag, 2, 2, &lStr[strlen(lStr)]);    //Recebe o valor imaginario.
			//serialEnviar(lStr);   //chama a função serialEnviar.
			Serial1.print(lStr);
			return false;   //retorna false
			break;
		}
		case 3:
		{
			//char lStr[30], filler[30];    //Inicializar um char lStr para recebe tudo e passar a proxima função e um filler para ajudar a construir a string.
			strcpy (lStr, "|");
			strcat (lStr, "F");   //Recebe o tag inicial do tipo de informação a ser enviada, F para Frequencia.
			int n = snprintf(filler, 30, "%lu", lt.freq);   //PODE NÃO FUNCIONAR! filler recebe os caracteres traduzidos do valor frequencia.
			strcat( lStr, filler);    //filler(frequencia) adicionado a string.

			//serialEnviar(lStr);   //chama a função serialEnviar.
			strcat (lStr, "E");
			Serial1.print(lStr);
			return false;
			break;
		}
		default:
		{
			Serial.println("SUCESSO.");
			_isBeingUsed = false;
			return true;
			break;
		}
	}
}

bool red_fang::getComplex(leitura lt, int n)
{
	char string[60], filler[30];
	switch(n)
	{
		case 0:
		{		//data e hora.
			strcpy (string, "S");
			strcat (string, "D");
			if(lt.dia<10)
				{
					strcat (string, "0"); 
				}		
				itoa (lt.dia, filler, 10);
				strcat (string, filler);
				strcat( string, "/");
			
			if(lt.mes<10)
				{
					strcat (string, "0"); 
				}		
				itoa (lt.mes, filler, 10);
				strcat (string, filler);
				strcat( string, "/");
			
			if(lt.ano<10)
				{
					strcat (string, "0"); 
				}		
				itoa (lt.ano, filler, 10);
				strcat (string, filler);
				strcat( string, " ");
			
			if(lt.hora<10)
				{
					strcat (string, "0"); 
				}		
				itoa (lt.hora, filler, 10);
				strcat (string, filler);
				strcat( string, ":");
			
			if(lt.minuto<10)
				{
					strcat (string, "0"); 
				}		
				itoa (lt.minuto, filler, 10);
				strcat (string, filler);
			
			//serialEnviar(string);
			Serial1.print(string);
			return false;
			break;
		}
		case 1:				//real
		{
			strcpy (string, "|");
			strcat (string, "R");   //Recebe o tag inicial do tipo de informação a ser enviada, R para Real.
			dtostrf(lt.real, 2, 2, &string[strlen(string)]);    //Recebe o valor real.
			//serialEnviar(string);   //chama a função serialEnviar.
			Serial1.print(string);
			return false;   //retorna false
			break;
		}
		case 2:				//imaginario
		{
			strcpy (string, ":");
			dtostrf(lt.imag, 2, 2, &string[strlen(string)]);
			//serialEnviar(string);
			Serial1.print(string);
			return false;
			break;
		}
		case 3:				//pares de leitura
		{
			static int x=0;
			if(x<11)
			{
				strcpy (string, "|");
				strcat (string, "R");
				dtostrf(lt.arrayR[x], 2, 2, &string[strlen(string)]);
				strcat (string, ":");
				dtostrf(lt.arrayJ[x], 2, 2, &string[strlen(string)]);
				//serialEnviar(string);
				Serial.println(string);
				Serial1.print(string);
				x++;
				return false;
			}
			else
			{
				x=0;
				return true;
			}
			break;
		}
		case 4:
		{
			strcpy (string, "|");
			strcat (string, "F");   //Recebe o tag inicial do tipo de informação a ser enviada, F para Frequencia.
			int x = snprintf(filler, 30, "%lu", lt.freq);   //PODE NÃO FUNCIONAR! filler recebe os caracteres traduzidos do valor frequencia.
			strcat( string, filler);    //filler(frequencia) adicionado a string.
			//serialEnviar(string);   //chama a função serialEnviar.
			strcat ( string, "E");		//trocar isso para o proximo caso quando tudo estiver pronto.
			Serial1.print(string);
			return false;
			break;
		}
		
		/*case 5:
		{
			static int x = 0;
			if(x<11)
			{
				Serial.print("gain[");
				Serial.print(x);
				Serial.print("]=");
				Serial.println(lt.arrayG[x]);
				strcpy (string, "G");
				dtostrf(lt.arrayG[x], 2, 15, &string[strlen(string)]);
				Serial.println(string);
				Serial1.print(string);
				x++;
				return false;
			}
			else
			{
				Serial.println("Pronto");
				x=0;
				return true;
			}
			break;
		}*/
		
		default:{
			Serial.println("SUCESSO.");
			return true;
			break;
		}
	}
}
bool red_fang::get(int n, bool complex)
{
    static int inf = 0;
    static leitura lt;
    if(n==0){
		static int z=0;
		EEPROM.get(1+(sizeof(leitura)*(z)), lt);
		while(z<EEPROM.read(0)-1)
		{
			if(!complex)
			{
				if(!serialLeitura(lt, inf)){
					inf++;
					delay(20);
				}
				else
				{
					inf=0;
					z++;
					Serial.print("Z=");
					Serial.println(z);
					EEPROM.get(1+(sizeof(leitura)*(z)), lt);
					delay(200);
				}
			}
			else
			{
				if(!getComplex(lt, inf))
				{
					if(inf!=3)
					{
						inf++;
						delay(20);
					}
				}
				else if(inf==3)
				{
					inf++;
				}
				else
				{
					inf=0;
					z++;
					Serial.print("Z=");
					Serial.println(z);
					EEPROM.get(1+(sizeof(leitura)*(z)), lt);
					delay(200);
				}
			}
        }
        z = 0;
        _Get=false;
		return true;
    }
    else if(n>EEPROM.read(0))
	{
		Serial.println("Index recebido superior ao numero de leituras, retornando ERRO");
		Serial1.print("ERR");
		_Get=false;
		return true;
    }
    else 
	{
		EEPROM.get( 1+ (sizeof(leitura)*(n-1) ), lt);
		if(!complex)
		{
			if(!serialLeitura(lt, inf))
			{
				inf++;
			}
			else
			{
				_Get = false;
				inf=0;
				return true;
			}
		}
		else
		{
			if(!getComplex(lt, inf))
			{
				if(inf!=3)
				{
					inf++;
				}
			}
			else if(inf==3)
			{
				inf++;
			}
			else
			{
				_Get = false;
				inf=0;
				_isBeingUsed = false;
				return true;
			}
		}
		/*if(!serialLeitura(lt, inf))
		{
			if(inf!=3)
				{
					inf++;
					delay(20);
				}
		}
		else if(inf==3)
		{
			inf++;
		}
		else
		{
			inf = 0;
			_Get = false;
			return true;
		}*/
    }
}

bool red_fang::isBeingUsed()
{
	return _isBeingUsed;
}