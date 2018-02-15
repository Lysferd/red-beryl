//#include <SoftwareSerial.h>
//#include <BLESerial.h>



// ADICITONAR UM COPYRIGHT NO SPLASHSCREEN. substituir Red Beryl por mbi (medidor de bio impedancia).
// Encontrar de alguma forma um modo de fazer os acentos aparecerem.

//Primeira iteração de um codigo de UI para o protótipo usando uma placa arduino nano e uma tela OLED azul 128x32 i2c

//#include <SPI.h>
#include <DS3231.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Math.h>
#include <EEPROM.h>



#include <AD5933.h> //incluir a library da AD.
#define START_FREQ  (50000) // frequencia inicial padrão.
#define FREQ_INCR   (START_FREQ/100) // incremento de frequencia padrão.
#define NUM_INCR    (10)  // numero padrão de incrementos.
#define REF_RESIST  (10000) // valor de referencia de resistor.
double gain[NUM_INCR+1];  // vetor double para conter o valor de ganho.
int phase[NUM_INCR+1];  // vetor int para conter o valor de fase.

//int real[NUM_INCR+1], imag[NUM_INCR+1]; // vetores do tipo int para conter os valores reais e imaginarios da impedancia.
double medReal, medImag; //variaveis int para receber os valores médios dos vetores.

#define OLED_RESET 4
Adafruit_SSD1306 display(OLED_RESET);
DS3231 time;
AD5933 AD;

struct leitura {
  unsigned long freq;
  double real,imag;
  int hora, minuto, dia, mes, ano;
};
struct leitura leitura0 = {93517,1.23,2,3,45,5,1,8};
int eeLimit;


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

bool h12, PM;
const int buttonUP = 23;    //declarar e inicializar o botão UP(para cima)
const int buttonDOWN = 25;    //declarar e inicializar o botão DOWN(para baixo)
const int buttonConfirm = 24;   //declarar e inicializar o botão YES(confirma)
const int buttonCancel = 22;    //declarar e inicializar o botão NO(cancela)
const int potPin = A15;   //declarar e inicializar(a partir do valor pre-programado na Arduino-Board) o PIN conectado ao potenciometro usado para simular a bateria.

int addr=0;   //declara a variavel int responsavel por percorrer os endereços da EEPROM

int selector = 1;
int screen = 0;
const int barSize = 8;
static bool up=false,down=false,yes=false,no=false, BLE;
static String temptime = "0:0";

//Inicialização.

void setup() {
  // put your setup code here, to run once:
  Serial.begin(19200);
  Serial1.begin(9600);
  BLE=true;
  
  Serial.println("starting");
  
  //display.setRotation(2); // mudando a rotação da tela
  Wire.begin(); //Inicializar o Wire
  Wire.setClock(400000);  //Definir a velocidade de clock do Wire para conversar com a AD.

  while(!defaultConfig());
  Serial.println("configurado?");
    //calibrar.
    if (AD5933::calibrate(gain, phase, REF_RESIST, (NUM_INCR+1)))
    {
      Serial.println("Calibrado!");
    }
    else
    {
      Serial.println("Calibrar falhou...");
    }
  frequencySweepEasy();
  display.begin(SSD1306_SWITCHCAPVCC, 0x3C); // inicializando o OLED.

  pinMode(buttonUP, INPUT);
  pinMode(buttonDOWN, INPUT);
  pinMode(buttonConfirm, INPUT);
  pinMode(buttonCancel, INPUT);

  randomSeed(analogRead(0));
  
  Serial.println(display.width());
  Serial.println(display.height());
  //display.display();
  //delay(1000);
  display.clearDisplay();
  //Limpando tela.

  display.setCursor(display.width()/2-(3*2*6/2),display.height()/2-(1*2*7/2)+2);
  display.setTextColor(WHITE);
  display.setTextSize(2);
  display.print("mbi");
  display.setTextSize(1);
  display.setCursor(1, 0);
  display.print("M.A.Engenharia");
  display.display();
  delay(1500);
  display.clearDisplay();
  delay(100);

  selector = 1;

  int lSize = sizeof(struct leitura);   //verifica o tamanho da struct criada para conter os dados de cada leitura e imprime esse valor no Serial.
  Serial.print("Tamanho da struct leitura: ");
  Serial.println(lSize);

    Serial.print(leitura0.freq/1000);  Serial.print("KHz = "); Serial.println(sizeof(leitura0.freq));
    Serial.print(leitura0.real);  Serial.print("= "); Serial.println(sizeof(leitura0.real));
    Serial.print(leitura0.imag);  Serial.print("= "); Serial.println(sizeof(leitura0.imag));
    Serial.print(leitura0.hora);  Serial.print(":");  Serial.print(leitura0.minuto);  Serial.print("= "); Serial.print(sizeof(leitura0.hora)); Serial.print("+");Serial.print(sizeof(leitura0.minuto));Serial.println(sizeof(leitura0.hora)+sizeof(leitura0.minuto));
    Serial.print(leitura0.dia); Serial.print("/");  Serial.print(leitura0.mes); Serial.print("/");  Serial.print(leitura0.ano);
    Serial.print("= ");Serial.println(sizeof(leitura0.dia)+sizeof(leitura0.mes)+sizeof(leitura0.ano));

  eeLimit = (EEPROM.length()-1)/sizeof(struct leitura);
  Serial.print("limite de leituras possiveis:");
  Serial.println(eeLimit);
  delay(500);
  
}

void loop() {
  // put your main code here, to run repeatedly:
  
 
  
  display.clearDisplay();
  //clock();
  checkPins();
  //menu();  // ALTERAR MENU COMEÇAR TUDO ABAIXO DA BARRA SUPERIOR
  menu1();
  upperBar(); // desenha a barra superior com bateria, bluetooth e relogio.
  if(BLE){
    serialTalk();
  }
  display.display();
  delay(1);  

}
//DEPOIS DE COMPLETAR OS MENUS, COMEÇAR A PENSAR EM UM MODO SLEEP/IDLE DENTRO DA OPÇÃO DE AJUSTES, PENSAR EM UM MODO DE CRIAR UM SLEEP/WAKE, CONTAR TEMPO IDLE, ACORDAR USANDO CHECKPIN(MUDAR A FUNÇÃO PARA BOOL QUE RETORNA TRUE SE UM BOTÃO FOR APERTADO.


void menu1(){   //segunda versão do menu principal
  static int choice=1;    //declara e inicializa a variavel estatica responsavel pelo seletor

  static char* menu1[] = { "1.Leituras", "2.Sincronizar", "3.Ajustes" };    //declara e inicializa as opções em vetores para facilidade de repetição.

  /*Ordem:
    1-"Leituras." **
      11-"Nova Leitura" **
        111-"Confirma leitura."(realizar) **
          1111-"Mostrar resultado da leitura e salvar no historico. **
      12-"Historico" **
        121-"Detalhes." **
    2-"Sincronizar." --
      21-"Dispositivo Bluetooth." --
    3-"Ajustes." *
      31-"Relogio." 
      32-"Apagar historico."
  */
  switch(choice){   //inicio da logica de switch case usada para peercorrer os menus
    case 1:{    //caso 1:Leituras selecionado
      display.fillRect(1, barSize, display.width()-5, barSize, WHITE);    //desenha um quadrado em volta da opção 1 selecionada
      display.setCursor(2, barSize);    //define a posição do cursor
      display.setTextColor(BLACK);    //define a cor do texto como preto.
      display.print(menu1[0]);    //imprime a string previamente inicializada.
      
      display.setCursor(2, barSize*2);   //define a posição do cursor para a proxima linha
      display.setTextColor(WHITE);    //define a cor do texto como branca
      display.println(menu1[1]);    //imprime a string previamente inicializada.
      
      display.setCursor(2, barSize*3);  //define a posição do cursor para a proxima linha
      display.setTextColor(WHITE);    //define a cor do texto como branca.
      display.println(menu1[2]);    //imprime a string previamente inicializada.

      if(yes){    //se YES
        choice=11;    //nova leitura
        yes=false;
      }
      if(no){
        no=false;
      }
      if(up){
        choice--;;
        up=false;
      }
      if(down){
        choice++;
        down=false;
      }
      break;
    }
    case 11:{   //1-Nova Leitura.     
      display.setTextSize(1); //define tamanho do texto.
      display.setCursor(2,barSize); //define a posição do cursor.
      display.setTextColor(BLACK,WHITE);  //define a cor do texto, preta com fundo branco, selecionado.
      display.println("1-Nova Leitura."); //imprime a opção 1.

      display.setCursor(2,barSize*2);   //define a posição do cursor na linha 2.
      display.setTextColor(WHITE);  //define a cor do texto, letras brancas, não selecionado.
      display.print("2-Historico.");   //imprime a opção 2.
      
      if(up){ //se UP for true.
        choice=12;    //seleciona a opção 2
        up=false; //reseta UP.
      }
      if(down){  //se DOWN for true
        choice++; //seleciona a opção 2 do menu.
        down=false; //reseta DOWN.
      }
      if(yes){  //se YES for true.
        choice=111; //Confirma leitura.(Realizar e mostrar)
        yes = false;  //reseta YES.
      }
      if(no){  //se NO for true.
        choice = 1; //reseta choice para a opção anterior do menu.
        no = false; //reseta NO.
      }
      break;    //fim da logica da opção 11 - Nova leitura.
    }
    case 111:{    //Confirma Leitura.(realizar)
      static bool freq=false;   //inicializa variavel bool freq que define se o usuario esta escolhendo a frequencia.
      static unsigned long f = 50000;
      if(!freq){    //tela normal.
        display.setCursor(2,barSize); //define a posição do cursor.
        display.setTextColor(WHITE);  //letras brancas.
        display.println("Realizar sweep?");   //imprime questão
        
        display.setCursor(display.width()/2,barSize*2);   //define a posição do cursor
        display.print("NAO | SIM");   //exige confirmação
      
        if(up){ //se UP for true.
          up=false; //reseta UP.
        }
        if(down){ //se DOWN for true.
          down=false; //reseta DOWN.
        }
        if(yes){  //se YES for true.
          //frequencySweepCustom(f, 10);          
          //choice=1111;
          freq=true;
          yes = false;
        }
        if(no){  //se NO for true
          choice=11; //retornar a tela anterior.
          no=false; //reseta NO.
        }
      }
      else{   //tela de escolher frequencia.
        display.setCursor(2,barSize*2);
        display.setTextColor(WHITE);
        display.print("Frequencia: ");
        display.setTextColor(BLACK,WHITE);
        display.print(f/1000);
        display.print(" KHz");
        if(yes){
          frequencySweepCustom(f, 10);
          choice=1111;
          freq=false;
          yes=false;
        }
        if(no){
          freq=false;
          no=false;
        }
        if(up){
          switch(f){
            case 5000:{
              f=25000;
              break;
            }
            case 25000:{
              f=50000;
              break;
            }
            case 50000:{
              f=100000;
              break;
            }
            case 100000:{
              f=5000;
              break;
            }
          }
          up=false;
        }
        if(down){
          switch(f){
            case 5000:{
              f=100000;
              break;
            }
            case 25000:{
              f=5000;
              break;
            }
            case 50000:{
              f=25000;
              break;
            }
            case 100000:{
              f=50000;
              break;
            }
          }
          down=false;
        }
      }
      break;
    }
    case 1111:{   //Mostrar leitura
            static unsigned int f = 50000;
            //trocar isso por algo melhor
      display.setCursor(2,barSize); //define a posição do cursor
      display.setTextColor(WHITE);  //define o texto em cor branca.
      display.print(leitura0.freq/1000);    //imprime valor da frequencia em khz.
      display.println("KHz");

      display.setCursor(2,barSize*2);   //define a posição do cursor na linha 2.
      display.print("R: ");   //Aguarda valor real.
      display.println(medReal);   //imprime valor real.

      display.setCursor(2,barSize*3);   //define a posição do cursor na linha 3.
      display.print("I:");    //Aguarda valor imaginario.
      display.print(medImag);   //imprime valor imaginario.

      static bool done = false;   //inicializa uma variavel bool DONE que marca se a leitura ja foi salva na EEPROM.
      if(!done){    //se DONE for false;
        if(EEPROM.read(0)<eeLimit){   //se o numero de leituras presentes na EEPROM estiver dentro dos limites.
          EEPROM.put( ((EEPROM.read(0)*22)+1)  , leitura0);   //salva a nova leitura na EEPROM.
          EEPROM.write(0, (EEPROM.read(0)+1));    //incrementa o numero na posição 0 da EEPROM, referente a quantas leituras foram salvas.
        }
        else{   //se o numero de leituras presentes estiver no limite.
          Serial.println("ERRO:LIMITE DE LEITURAS ATINGIDO, FAVOR LIMPAR O HISTORICO");
        }
        done=true;    //DONE recebe true para que a logica não se repita.
      }
      if(up){ //se UP for true.
        up=false; //reseta UP.
      }
      if(down){ //se DOWN for true.
        down=false; //reseta DOWN;.
      }
      if(yes){  //se YES for true.
        choice=12; //retorna ao menu, com a opção indo diretamente para a opção de historico.
        done=false;   //reseta DONE para que se repita da proxima vez que for chamada.
        yes=false;  //reseta YES.
      }
      if(no){ //se NO for true.
        choice=11; //retorna ao menu, voltando para a opçãod e nova leitura.
        done=false;   //reseta DONE para que se repita da proxima vez que for chamada.
        no=false; //reseta NO.
      }
      break;
    }
    case 12:{   //Historico.
      display.setTextSize(1); //define tamanho do texto.
      display.setCursor(2,barSize); //define a posição do cursor.
      display.setTextColor(WHITE);  //define a cor do texto, branco, não selecionado.
      display.println("1-Nova Leitura."); //imprime a opção 1.

      display.setCursor(2,barSize*2);   //define a posição do cursor na linha 2.
      display.setTextColor(BLACK,WHITE);  //define a cor do texto, letras pretas com fundo branco, selecionado.
      display.print("2-Historico.");   //imprime a opção 2.
      
      if(up){ //se UP for true.
        choice--;    //seleciona a opção 1
        up=false; //reseta UP.
      }
      if(down){  //se DOWN for true
        choice=11; //seleciona a opção 2 do menu.
        down=false; //reseta DOWN.
      }
      if(yes){  //se YES for true.
        choice=121; //Confirma Historico
        yes = false;  //reseta YES.
      }
      if(no){  //se NO for true.
        choice = 1; //reseta choice para a opção anterior do menu.
        no = false; //reseta NO.
      }
      break;
    }
    case 121:{
      static int i = 0;   //declara a variavel i referente aos numeros do historico(+1), por padrão usaremos apenas 10 valores, mas como o arduino Mega oferece muito mais espaço é possivel liberar mais espaço para salvar as leituras.
      static int l = 1;   //declara a variavel l referente as linhas do historico, estou testando seu uso para um menu mais dinamico e inteligente.
      static bool detalhar = false;   //declara a variavel bool detalhar que define se os detalhes de uma leitura escolhida deverão ser mostrados ou não.
      if(EEPROM.read(0)!=0){    //primeiro testa se tem algo no historico para apresentar.
        if(detalhar){
          static bool recebeu=false;   //inicializa uma variavel bool que informa se a leitura ja foi recebida da EEPROM
          static struct leitura leituraTemp;    //inicializa uma struct leitura temporaria para receber a struct leitura da EEPROM, feita static para que não se repita.
          if(!recebeu){   //se não tiver recebido a leitura da EEPROM
            EEPROM.get((22*i)+1,leituraTemp);    //leituraTemp recebe a leitura da EEPROM.
            recebeu=true;   //recebeu recebe valor true.
            Serial.println("recebeu leitura");    //imprime a confirmação no serial
          }
          display.setCursor(25,barSize);    //define a posição do cursor.
          display.setTextColor(WHITE);    //define a cor da fonte(branca).
          display.print(leituraTemp.dia);   //imprime o valor dia.
          display.print("/");   //separador de data.
          display.print(leituraTemp.mes);   //imprime o valor mes.
          display.print("/");   //separador de data.
          display.print(leituraTemp.ano);   //imprime o valor ano.
          display.print("  ");    //espaço vazio.
          display.print(leituraTemp.hora);    //imprime o valor hora.
          display.print(":");   //separador de hora.
          if(leituraTemp.minuto<10){    //se o minuto for menor que 10, imprime 0 para manter a estetica.
            display.print("0");
          }
          display.print(leituraTemp.minuto);    //imprime o valor minuto.
          display.setCursor(2,barSize*2);   //define a posição do cursor
          display.print("R: ");   //real
          display.print(leituraTemp.real);    //imprime o valor real
          display.setCursor(2,barSize*3);   //define a posição do cursor
          display.print("I:");    //imaginario
          display.print(leituraTemp.imag);    //imprime o valor imaginario

          display.setCursor(display.width()-(6*7), barSize*2+4);
          display.print(leituraTemp.freq/1000);
          display.print("KHz");
          if(yes){    //se YES for true.
            yes=false;    //reseta YES.
          }
          if(up){   //se UP for true.
            if(i!=0){   //se i não estiver na posição 0
              i--;    //i-1
              if(l!=1){   //se não estiver selecionando a primeira linha.
                l--;    //seleciona a linha acima da atual.
              }
            }
            else if(EEPROM.read(0)>1){    //se i for 0 e haver mais de uma leitura na EEPROM
              i=EEPROM.read(0)-1;   //i recebe o valor equivalente a ultima leitura valida.
              if(EEPROM.read(0)>2){   //se tiver mais de duas leituras validas
                l=3;    //seleciona a terceira linha para quando retornar ao menu anterior
              }
              else if(EEPROM.read(0)==2){   //se tiverem extamente duas leituras validas.
                l=2;    //seleciona a segunda linha para quando retornar ao menu anterior.
              }
            }
            recebeu=false;    //reseta RECEBEU para que o valor em leituraTemp e a tela sejam atualizados com a nova posição de i.
            up=false;   //reseta UP.
          }
          if(down){   //se DOWN for true.
            if(i!=EEPROM.read(0)-1){    //se i não estiver na ultima posição valida a partir da EEPROM.
              i++;    //i+1
              if(l!=3){   //se não for a terceira linha
                l++;
              }
            }
            else if(EEPROM.read(0)>1){    //se i estiver na ultima posição valida e não for a unica leitura valida
              i=0;    //i recebe o valor 0 e volta a primeira posição.
              l=1;    //seleciona a primeira linha quando voltar ao menu de historicos.
            }
            recebeu=false;    //reseta RECEBEU para que o valor em leituraTemp e a tela sejam atualizados com a nova posição de i.
            down=false;   //reseta DOWN.
          }
          if(no){
            recebeu=false;    //reseta RECEBEU
            detalhar=false;   //reseta DETALHAR
            no=false;   //reseta NO
          }
        }
        else {
          static struct leitura L1,L2,L3;
          static bool ler = false;
          if(l==1){   //se estiver na primeira linha.
            if(!ler){   //se a variavel ler for false: ou seja, se os valores de leitura não tiverem sido recebidos ainda.
              EEPROM.get(((i*22)+1), L1);   //L1 recebe o valor salvo no historico referente a posição i;
              if((i+1)<EEPROM.read(0)){    //se o proximo valor ainda estiver dentro do limite de leituras validas.
                EEPROM.get((((i+1)*22)+1), L2);   //L2 recebe o valor salvo no historico referente a posição i+1.
                if((i+2)<EEPROM.read(0)){    //se o proximo valor ainda estiver dentro do limite de leituras validas.
                  EEPROM.get((((i+2)*22)+1), L3);   //L3 recebe o valor salvo no historico referente a posição i+2.
                }
              }
              ler=true;   //ler recebe true.
            }
            imprimeEscolha( i+1, l, L1, true);
            if((i+1)<EEPROM.read(0)){   //se o proximo valor ainda estiver dentro do limite de leituras validas.
              imprimeEscolha( i+2, l+1, L2, false);
              if((i+2)<EEPROM.read(0)){   //se o proximo valor ainda estiver dentro do limite de leituras validas.
                imprimeEscolha( i+3, l+2, L3, false);
              }
            }
          }
          if(l==2){   //se estiver na segunda linha.
            if(EEPROM.read(0)<2 || i==0){   //se tiver menos de dois endereços no historico ou se o i for 0, imediatamente retorna a primeira linha.
              l=1;
            }
            else {    //se tiver pelo menos dois endereços e i for diferente de 0;
              if(!ler){   //se a variavel ler for false: ou seja, se os valores de leitura não tiverem sido recebidos ainda.
                EEPROM.get((((i-1)*22)+1), L1);   //L1 recebe o valor salvo no historico referente a posição i-1;
                EEPROM.get((((i)*22)+1), L2);   //L2 recebe o valor salvo no historico referente a posição i.
                if((i+1)<EEPROM.read(0)){    //se o proximo valor ainda estiver dentro do limite de leituras validas.
                  EEPROM.get((((i+1)*22)+1), L3);   //L3 recebe o valor salvo no historico referente a posição i+1.
                }
                ler=true;   //ler recebe true.
              }
              imprimeEscolha( i, l-1, L1, false);           
              //final da logica das opções na linha 1 para quando a linha 2 estiver selecionada, a proxima parte conta com a linha 2.
              imprimeEscolha( i+1, l, L2, true);          
              //final da logica das opções na linha 2 quando selecionada, a proxima parte conta com a linha 3, usando 'if' para verificar se ela deve existir.
              if(EEPROM.read(0)>i+1){   //se o numero de leituras for maior que i+1(ou seja, se i=1(primeira linha 0), a terceira linha seria(i+1)=2, nesse caso, tivermos 3 leituras EEPROM.read(0)=[3]>[2]
                //portanto, nesse caso a terceira linha existe.
                imprimeEscolha( i+2, l+1, L3, false);
              }
            }
          }
          if(l==3){   //se estiver na terceira(e ultima) linha.
            if(EEPROM.read(0)<3 || i==0 || i==1){   //se tiver menos de tres endereços no historico ou se o i for 0 ou 1, imediatamente retorna a primeira linha.
              l=1;
            }
            else {    //se tiver pelo menos tres endereços e i for diferente de 0 e 1;
              if(!ler){   //se a variavel ler for false: ou seja, se os valores de leitura não tiverem sido recebidos ainda.
                EEPROM.get((((i-2)*22)+1), L1);   //L1 recebe o valor salvo no historico referente a posição i-2;
                EEPROM.get((((i-1)*22)+1), L2);   //L2 recebe o valor salvo no historico referente a posição i-1.
                EEPROM.get(((i*22)+1), L3);   //L3 recebe o valor salvo no historico referente a posição i.
                ler=true;   //ler recebe true.
              }
              imprimeEscolha( i-1, l-2, L1, false);
              //Final da logica da linha 1.
              imprimeEscolha( i, l-1, L2, false);
              //Final da logica da linha 2.
              imprimeEscolha( i+1, l, L3, true);
            }
          }
          if(up){   //se UP for true
            if(l==1){   //se a linha 1 estiver selecionada.
              if(i!=0){   //se i não for 0.
                i--;    //i-1;    
              }
              else if(EEPROM.read(0)>1){    //se i for 0 e houver mais de uma leitura salva no historico.
                i=EEPROM.read(0)-1;   //i recebe o valor da ultima posição valida do historico.
                if(i>1){      //se i for maior que 1.
                  l=3;    //seleciona a terceira linha.
                }
                else if(i==1){    //se i for igual a 1.
                  l==2;   //seleciona a segunda linha.
                }
              }
            }
            else {    //para as linhas 2 e 3, sempre que UP for true, apenas decresce os valores de i e l.
              i--;
              l--;
            }
            ler=false;    //reseta LER
            up=false;   //reseta UP.
          }
          if(down){   //se DOWN for true.
            if(l==3){   //se a linha 3 estiver selecionada.
              if(i==EEPROM.read(0)-1){    //se i for igual a ultima leitura possivel.
                i=0;    //volta a primeira leitura.
                l=1;    //seleciona a primeira linha.
              }
              else{   //se i não for a ultima leitura possivel.
                i++;    //incrementa o valor de i.
              }
            }
            else {    //se a linha 1 ou 2 estiver selecionada.
              if(!(i==EEPROM.read(0)-1)){    //se i NÃO for igual a ultima leitura possivel.
                i++;  //incremente o valor de i.
                l++;    //incrementa o valor l(indo para a segunda ou terceira linha).
              }
              else {    //se i for igual a ultima leitura possivel.
                i=0;    //volta a primeira leitura.
                l=1;    //seleciona a primeira linha.
              }
            }
            ler=false;    //reseta LER
            down=false;   //reset DOWN
          }
          if(yes){
            detalhar=true;
            yes=false;    //reseta YES
          }
          if(no){   //se NO for true.
            choice=12;   //reseta choice.
            i=0;
            l=1;
            ler=false;
            no=false;   //reseta NO.
          }
          scrollBar(i);
        }
      }
      else{   //se o historico estiver vazio.
        display.setCursor(0, barSize*2);    //define a posição do cursor
        display.setTextColor(WHITE);    //define a cor da fonte(branca);
        display.print(" Historico Vazio.");
        if(yes){
          yes=false;    //reseta YES
        }
        if(up){
          up=false;   //reseta UP.
        }
        if(down){
          down=false;   //reseta DOWN.
        }
        if(no){
          choice=12;   //retorna ao menu anterior.
          no=false;   //reseta NO.
        }
      }
      break;
    }
    case 2:{
      display.setCursor(2, barSize);   //define a posição do cursor na primeira linha
      display.setTextColor(WHITE);    //define a cor do texto como branca
      display.println(menu1[0]);    //imprime a string previamente inicializada.
      
      display.fillRect(1, barSize*2, display.width()-5, barSize, WHITE);    //desenha um quadrado em volta da opção 1 selecionada
      display.setCursor(2, barSize*2);    //define a posição do cursor
      display.setTextColor(BLACK);    //define a cor do texto como preto.
      display.print(menu1[1]);    //imprime a string previamente inicializada.
      
      display.setCursor(2, barSize*3);  //define a posição do cursor para a proxima linha
      display.setTextColor(WHITE);    //define a cor do texto como branca.
      display.println(menu1[2]);    //imprime a string previamente inicializada.

      if(yes){    //se YES
        choice=21;    //Menu Sincronizar(temporariamente desabilitado até termos algo em que isso possa ser usado.)        
        yes=false;
      }
      if(no){
        no=false;
      }
      if(up){
        choice--;;
        up=false;
      }
      if(down){
        choice++;
        down=false;
      }
      break;
    }
    case 21:{   //menu dentro do sincronizar, usaremos isso para ativar e desativar o bluetooth.
      display.setCursor(2, barSize);   //define a posição do cursor na primeira linha.
      display.setTextColor(BLACK,WHITE);    //define a cor do texto.(preto no fundo branco.)
      if(BLE){
        display.print("Desativar Bluetooth.");
        if(yes){
          Serial1.end();
          BLE=false;
          choice=2;
          yes=false;
        }
      }
      else{
        display.print("Ativar Bluetooth.");
        if(yes){
          Serial1.begin(9600);
          BLE=true;
          choice=2;
          yes=false;
        }
      }
      if(no){
        choice=2;
        no=false;
      }
      if(up){
        up=false;
      }
      if(down){
        down=false;
      }
      break;
    }
    case 3:{
      display.setCursor(2, barSize);    //define a posição do cursor na primeira linha.
      display.setTextColor(WHITE);    //define a cor do texto como branca.
      display.print(menu1[0]);    //imprime a string previamente inicializada.
      
      display.setCursor(2, barSize*2);   //define a posição do cursor na segunda linha.
      display.setTextColor(WHITE);    //define a cor do texto como branca.
      display.println(menu1[1]);    //imprime a string previamente inicializada.
      
      display.fillRect(1, barSize*3, display.width()-5, barSize, WHITE);    //desenha um quadrado em volta da opção 3 selecionada
      display.setCursor(2, barSize*3);  //define a posição do cursor na terceira linha.
      display.setTextColor(BLACK);    //define a cor do texto como branca.
      display.println(menu1[2]);    //imprime a string previamente inicializada.

      if(yes){    //se YES
        choice=31;    //Menu de ajustes.
        yes=false;
      }
      if(no){
        no=false;
      }
      if(up){
        choice--;;
        up=false;
      }
      if(down){
        choice++;
        down=false;
      }
      break;
    }
    case 31:{
      display.setCursor(2, barSize);    //definir a posição do cursor na primeira linha.
      display.setTextSize(1);   //definir o tamanho do texto(por garantia)
      display.setTextColor(BLACK, WHITE);    //definir a cor do texto como: preto com fundo branco | selecionado
      display.println("1- Relogio");    //imprimir opção 1.

      display.setCursor(2, barSize*2);    //definir a posição do cursor na segunda linha.
      display.setTextColor(WHITE);    //definir a cor do texto como: branco | não selecionado
      display.println("2- APAGAR HISTORICO");   //imprimir opção 2.

      if(up){   //se UP.
        choice=32;    //ultima opção do menu(no momento opção 32, ou segunda opção).
        up=false;   //reseta UP.
      }
      if(down){   //se DOWN.
        choice++;   //proxima opção do menu.
        down=false;   //reseta DOWN.
      }
      if(yes){    //se YES.
        choice=311;   //proximo menu: 3-1-1.
        yes=false;
      }
      if(no){   //se NO.
        choice=3;   //retorna ao menu anterior: 3
        no=false;
      }
      
      break;
    }
    case 311:{    //ajuste de relogio
      clockAdjust();    //chama função clockAdjust onde tudo deve funcionar, teoricamente
      if(no){   //se NO, e se a função clockAdjust estiver funcionando corretamente NO só vai ser true nesse estagio se NO for true e o track do clock estiver nas horas.
        choice=31;    //retorna ao menu anterior, dentro da função de ajustes.
        no=false;
      }
      break;
    }
    case 32:{
      display.setCursor(2, barSize);    //definir a posição do cursor na primeira linha.
      display.setTextSize(1);   //definir o tamanho do texto(por garantia)
      display.setTextColor(WHITE);    //definir a cor do texto como: branco | não selecionado
      display.println("1- Relogio");    //imprimir opção 1.

      display.setCursor(2, barSize*2);    //definir a posição do cursor na segunda linha.
      display.setTextColor(BLACK, WHITE);    //definir a cor do texto como: preto com fundo branco | selecionado
      display.println("2- APAGAR HISTORICO");   //imprimir opção 2.

      if(up){   //se UP.
        choice--;    //opção anterior do menu.
        up=false;   //reseta UP.
      }
      if(down){   //se DOWN.
        choice=31;   //como ja é a ultima opção do menu, retorna a primeira, no caso 31.
        down=false;   //reseta DOWN.
      }
      if(yes){    //se YES.
        choice=321;   //proximo menu: 3-2-1.
        yes=false;
      }
      if(no){   //se NO.
        choice=3;   //retorna ao menu anterior: 3
        no=false;
      }
      
      break;
    }
    case 321:{    //apagar historico.
      static bool reseter = false;    //declara e inicia como falsa uma 
      if(!reseter){   //se o reseter for falso, faz a logica para perguntar se o usuario deseja apagar o historico.
        display.setCursor(2, barSize);    //reseta a posição do cursor
        display.setTextColor(WHITE);    //define as fonte branca.
        display.println("Limpar historico?");
        
        display.setCursor(display.width()/2, barSize*2);    //define a posição do cursor
        display.print("N|S");
        if(yes){    //se o botão YES for true.
          reseter=true;   //define reseter como true para começar a logica de limpar o historico
          yes=false;       //reseta YES.
        }
        if(no){   //se o botão NO for true.
          choice=32;   //retorna para o menu inicial
          reseter=false;    //reseta o reseter por garantia.
          no=false;   //reseta NO.
        }
      }
      else{   //se o valor de RESETER for true.
        static int i=0;   //declara variavel int com valor 0 de modo estatico para percorrer os endereços da EEPROM
        display.setCursor(display.width()/2-30, display.height()/2-4);    //define posição do cursor
        display.setTextColor(WHITE);    //define a fonte branca.
        if(i < EEPROM.length()){    //se i for menor que o tamanho da memoria da EEPROM
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
        else{   //se i for maior que o tamanho da memoria da EEPROM, ou seja, se terminar de limpar a memoria.
          display.setCursor(display.width()/2-25, display.height()/2-4);    //define a posição do cursor.
          display.setTextColor(WHITE);    //define a fonte branca.
          display.print("Concluido!");    //imprime a frase que indica que completou a logica.
          if(yes || no || up || down){    //se qualquer um dos botões for TRUE.
            choice=3;   //retorna ao menu inicial.
            reseter=false;    //reseta RESETER.
            i=0;    //reseta o valor de i;
            yes=false;    //reseta YES.
            no=false;   //reseta NO.
            up=false;   //reseta UP.
            down=false;   //reseta DOWN.
          }
        }
      }
      break;
    }
    default:{
      if(choice<=0){
        choice=3;
      }
      else{
        choice=1;
      }
      break;
    }
  }
}

void imprimeEscolha(int i, int l, struct leitura lt, bool s){    //função imprimeEscolha, que recebe o i da posição, a struct leitura com os valores e o bool s se for selecionado ou não.
  display.setCursor(2, barSize*l);    //reseta a posição do cursor, multiplicando o tamanho de uma linha pelo numero de linhas
  if(s){    //se a linha for selecionada
    display.setTextColor(BLACK,WHITE);    //Define a fonte na cor preta com fundo branco, selecionado.
  }
  else{
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
  if(lt.minuto<10){
    display.print("0");
  }
  display.print(lt.minuto);   //imprime valor minuto.
}

int getBatteryPct(){
  int pwr, pct;
  pwr = analogRead(potPin);
  pct = map(pwr,0,1023,0,100);
  return pct;
}

void upperBar() // barra superior.
{
  static int pwr;   //declara o inteiro estatico pwr(POWER)
  static int pct;   //declara o inteiro estatico pct(PERCENTAGE)
  
  display.fillRect(0, 0, display.width(), barSize, BLACK); // desenha a barra em preto, mantendo permanentemente a barrar acima de tudo.
  
  pwr = analogRead(potPin);   //pwr le o valor analogico do potenciometro, recebendo o valor 'raw' da bateria.
  pct = map(pwr,0,1023,0,100);    //pct recebe o valor mapeado de pwr entre 0-100.
  pwr = map(pwr, 0, 1023, 0, 12);   //pwr recebe o valor mapeado entre0-12

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
  
  clock(); //chama o relogio, A FAZER: alterar coordenadas de impressão do relogio para canto superior DIREITO
  display.drawBitmap(display.width()-BAT8_WIDTH, 0, bat_6x16_bmp, BAT8_WIDTH, BAT8_HEIGHT, WHITE); // desenha o contorno da bateira no canto superior ESQUERDO. 6 de altura, 16 de largura
  //display.drawBitmap(0, 0, BT_9_bmp, BT9_WIDTH, BT9_HEIGHT, WHITE); // desenha o simbolo de bluetooth depois da bateria. 9 de altura, 8 de largura.
  if(BLE)
  {
    display.drawBitmap(0, 0, BT2_bmp, BT2_WIDTH, BT2_HEIGHT, WHITE);
  }
  display.setCursor(BT2_WIDTH+5,0);

  static unsigned long mill = 0;
  static unsigned long tempMill = 0;
  static double temperature = AD5933::getTemperature();

  mill = millis();
  if( (mill - tempMill) > 1000){
    temperature = AD5933::getTemperature();
    tempMill = mill;
    //Serial.println("Temperatura atualizada");
  }
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.print((int) temperature);
  display.print("C");
  //uint8_t i=247;
  display.write((uint8_t) 247);
  
  
  //scrollBar();


}
void serialEnviar(char message[]){
  Serial1.print("S");
    Serial.println("[S] enviado.");
  Serial1.print(message);
    Serial.print("[");
    Serial.print(message);
    Serial.println("] enviado.");
  Serial1.print("E");
    Serial.println("[E] enviado.");
    delay(50);
}

bool serialLeitura(leitura lt, int i){    //função serialLeitura que retorna true quando completa para enviar uma leitura em pacotes divididos em ciclos.
  switch(i){    //usa-se switch case para dividir o que cada ciclo diferente deve fazer.
    case 0:{    //0 é referente ao primeiro ciclo referente a DATA e HORA da leitura.
      char lStr[30], filler[30];    //Inicializar um char lStr para receber tudo e passar a proxima função e um filler para ajudar a construir lStr.
      strcpy (lStr, "D");   //Recebe o tag inicial do tipo de informação a ser enviada, D para data.
      
      if(lt.dia<10){  strcat (lStr, "0"); }              //se o valor de dia for inferior a 10, a string recebe um 0.
        
      itoa (lt.dia,filler, 10);   //filler recebe os caracteres traduzidos do valor dia.
      strcat (lStr, filler);    //filler(dia) adicionado a string
        strcat( lStr, "/");   //Separador de data adicionado a string.
        
      if(lt.mes<10){    strcat (lStr, "0"); }    //se o valor de mes for inferior a 10, a string recebe um 0.
      
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

      serialEnviar(lStr);   //a string construida até aqui é enviada a função serialEnviar() para ser enviada ao bluetooth dentro do pacote S||E.
      
      return false;   //retorna false
      break;
    }
    case 1:{    //1 é referente ao segundo ciclo referente ao valor REAL da leitura.
      char lStr[30];    //Inicializar um char lStr para receber tudo e passar a proxima função.
      strcpy (lStr, "R");   //Recebe o tag inicial do tipo de informação a ser enviada, R para Real.
      dtostrf(lt.real, 2, 2, &lStr[strlen(lStr)]);    //Recebe o valor real.
      serialEnviar(lStr);   //chama a função serialEnviar.
      
      return false;   //retorna false
      break;
    }
    case 2:{    //2 é referente ao terceiro ciclo referente ao valor IMAGINARIO da leitura.
      char lStr[30];    //Inicializar um char lStr para receber tudo e passar a proxima função.
      strcpy (lStr, "J");   //Recebe o tag inicial do tipo de informação a ser enviada, J para Imaginario.
      dtostrf(lt.imag, 2, 2, &lStr[strlen(lStr)]);    //Recebe o valor imaginario.
      serialEnviar(lStr);   //chama a função serialEnviar.
      
      return false;   //retorna false
      break;
    }
    case 3:{    //3 é referente ao quarto ciclo referente ao valor de FREQUENCIA da leitura.
      char lStr[30], filler[30];    //Inicializar um char lStr para recebe tudo e passar a proxima função e um filler para ajudar a construir a string.
      strcpy (lStr, "F");   //Recebe o tag inicial do tipo de informação a ser enviada, F para Frequencia.
      int n = snprintf(filler, 30, "%lu", lt.freq);   //PODE NÃO FUNCIONAR! filler recebe os caracteres traduzidos do valor frequencia.
      strcat( lStr, filler);    //filler(frequencia) adicionado a string.

      serialEnviar(lStr);   //chama a função serialEnviar.
      return false;
      break;
    }
    default:{
      Serial.println("SUCESSO.");
      return true;
      break;
    }
  }
}
/*
if(Req){
    static int inf = 0;
    static leitura lt;
    static bool first=true;
    if(first){
      Serial.print("Req ");
      Serial.println(index);
      lt = leitura0;
      first=false;
    }
    switch(inf){
      case 0:{
        Serial.println("Enviando DATA e HORA.");
        Serial1.print("S");
        Serial1.print("D");
        if(lt.dia<10){
          Serial1.print("0");
        }
        Serial1.print(lt.dia);
        Serial1.print("/");
        if(lt.mes<10){
          Serial1.print("0");
        }
        Serial1.print(lt.mes);
        Serial1.print("/");
        if(lt.ano<10){
          Serial1.print("0");
        }
        Serial1.print(lt.ano);
        Serial1.print(" ");
        if(lt.hora<10){
          Serial1.print("0");
        }
        Serial1.print(lt.hora);
        Serial1.print(":");
        if(lt.minuto<10){
          Serial1.print("0");
        }
        Serial1.print(lt.minuto);
        Serial1.print("E");
        //Serial1.flush();
        inf++;
        break;
      }
      case 1:{
        Serial.println("Enviando valor REAL.");
        Serial1.print("S");
        Serial1.print("R");
        Serial1.print(lt.real);
        Serial1.print("E");
        //Serial1.flush();
        inf++;
        break;
      }
      case 2:{
        Serial.println("Enviando valor IMAGINARIO.");
        Serial1.print("S");
        Serial1.print("J");
        Serial1.print(lt.imag);
        Serial1.print("E");
        //Serial1.flush();
        inf++;
        break;
      }
      case 3:{
        Serial.println("Enviando valor de FREQUENCIA.");
        Serial1.print("S");
        Serial1.print("F");
        Serial1.print(lt.freq);
        Serial1.print("E");
        //Serial1.flush();
        inf++;
        break;
      }
      case 4:{
        inf = 0;
        first=true;
        Req = false;
        break;
      }
    }
  }

*/

void serialTalk(){
  //String input, output;
  //static bool waiting = false, sending = false, getter = false;
  //static int i=0, x;





  /*CRIAR FUNÇÕES WRAP-SEND-RECEIVE(?) E SIMILARES PARA DIMINUIR SERIALTALK()
   * E TRANSFERIR PARA UMA LIBRARY PERSONALIZADA('Red_Beryl'?) 
   * PARA QUE O CODIGO FIQUE MAIS LIMPO E FACIL DE NAVEGAR
   * E PARA SIMPLIFICAR O PROCESSO DE ALTERAR O CODIGO.
   */

  /*Fazer as funções de deletar leitura do historico
   * fazer a logica de receber CLR[n] para pagar a leitura [n] do historico usando a função de delete anterior.
   * modificar a logica de get para que ao invez de GET[0], enviar todas as leituras esteja presente em GET[], assim como apagar tudo é CLR[]
   * 
   * NO MEIO DE ALTERAR TODAS AS RESPOSTAS DE OK PARA USAR SERIALENVIAR.
   */


  
  
  char comStr[4], inStr[30], debugStr[30];
  static long index;
  static bool Get=false, Req=false;
  if(Req){
    static int inf = 0;
    static leitura lt;
    static bool first=true;
    if(first){
      Serial.print("Req ");
      Serial.println(index);
      lt = leitura0;
      first=false;
    }
    if(!serialLeitura(lt, inf)){
      inf++;
      delay(20);
    }
    else{
      inf=0;
      first=true;
      Req=false;
      
    }
  }
  if(Get){
    //Serial.print("Get ");
    //Serial.println(index);
    
    static int inf = 0;
    static leitura lt;
    if(index==0){
      static int z=0;
      EEPROM.get(1+(sizeof(struct leitura)*(z)), lt);
      while(z<EEPROM.read(0)-1){
        /*if(z==EEPROM.read(0)-1){
            break;
          }*/
        if(!serialLeitura(lt, inf)){
          inf++;
          delay(20);
        }
        else{
          inf=0;
          z++;
          Serial.print("Z=");
          Serial.println(z);
          EEPROM.get(1+(sizeof(struct leitura)*(z)), lt);
          delay(200);
        }
        /*if(z==EEPROM.read(0)-1){
          z=0;
          Get=false;
          break;
        }*/
      }
      {
        z=0;
        Get=false;
      }
    }
    else if(index>EEPROM.read(0)){
      Serial.println("Index recebido superior ao numero de leituras, retornando ERRO");
      Serial1.print("ERR");
      Get=false;
    }
    else {
      EEPROM.get(1+(sizeof(struct leitura)*(index-1)), lt);

      if(!serialLeitura(lt, inf)){
        inf++;
      }
      else{
        inf=0;
        Get=false;
      }

      /*
      switch(inf){
        case 0:{
          Serial.println("Enviando DATA e HORA.");
          Serial1.print("S");
          Serial1.print("D");
          if(lt.dia<10){
            Serial1.print("0");
          }
          Serial1.print(lt.dia);
          Serial1.print("/");
          if(lt.mes<10){
            Serial1.print("0");
          }
          Serial1.print(lt.mes);
          Serial1.print("/");
          if(lt.ano<10){
            Serial1.print("0");
          }
          Serial1.print(lt.ano);

          Serial1.print(" ");
          if(lt.hora<10){
            Serial1.print("0");
          }
          Serial1.print(lt.hora);
          Serial1.print(":");
          if(lt.minuto<10){
            Serial1.print("0");
          }
          Serial1.print(lt.minuto);
          Serial1.print("E");
          //Serial1.flush();
          inf++;
          break;
        }
        case 1:{
          Serial.println("Enviando valor REAL.");
          Serial1.print("S");
          Serial1.print("R");
          Serial1.print(lt.real);
          Serial1.print("E");
          //Serial1.flush();
          inf++;
          break;
        }
        case 2:{
          Serial.println("Enviando valor IMAGINARIO.");
          Serial1.print("S");
          Serial1.print("J");
          Serial1.print(lt.imag);
          Serial1.print("E");
          //Serial1.flush();
          inf++;
          break;
        }
        case 3:{
          Serial.println("Enviando valor de FREQUENCIA.");
          Serial1.print("S");
          Serial1.print("F");
          Serial1.print(lt.freq);
          Serial1.print("E");
          //Serial1.flush();
          inf++;
          break;
        }
        
        case 4:{
          inf = 0;
          Get = false;
          break;
        }
      }
    */}
    
  }
  if(Serial1.available()!=-1 && Serial1.available()!=  0 && Serial1.available()>=3){
    Serial.print("Serial1 enviou algo:");
    Serial.print(Serial1.available());
    Serial.println(" caracteres.");
    int i=0;
    while(Serial1.available()>0 && i<3 ){
      //static int i=0;
      Serial.print(i);
      comStr[i]=Serial1.read();
      Serial.print(comStr[i]);
      i++;
      comStr[i]= '\0';
    }
    Serial.println("");
    Serial.println(comStr);

    delay(10);

    if(strcmp(comStr, "CHK")== 0){
      char num[4];
      itoa (EEPROM.read(0),num, 10);
      serialEnviar(num);
    }
    else if(strcmp(comStr, "BAT")==0){
      char bat[4];
      itoa (getBatteryPct(), bat, 10);
      serialEnviar(bat);
    }
    else if(strcmp(comStr, "CLR")==0){
      //FAST CLEAR = APENAS MARCAR A POSIÇÃO 0 DA EEPROM COMO 0.
      EEPROM.write(0,0);
      Serial.println("Limpeza rapida concluida.");
      
      serialEnviar("OK");
    }
    else if(strcmp(comStr, "WIP")==0){
      //WIPE MEMORY = LIMPAR OS ENDEREÇOS DA EEPROM RECONHECIDOS PELA POSIÇÃO 0(INDEX).
      if(EEPROM.read(0)>0){
        int i=1;
        while(i<1+(EEPROM.read(0)*(sizeof(struct leitura)))){
          EEPROM.write(i,0);
          i++;
        }
        EEPROM.write(0,0);
        Serial.println("Wipe realizado com sucesso");
        serialEnviar("OK");
      }
      else{
        Serial.println("Wipe impossivel, historico ja limpo");
        serialEnviar("OK");
      }
    }
    else if(strcmp(comStr, "CLK")==0){    //Se o comando recebido for CLK, realiza a logica de relogio.
      delay(10);
      if(Serial1.available()!=-1 && Serial1.available()!=0){    //checa se recebeu mais alguma coisa por bluetooth,.
        int dia,mes,ano,hora,minuto,segundo;    //inicializa as variaveis tmeporarias para receber os valores de dat e hora
        
        while(Serial1.available()<12){    //enquanto o buffer não estiver com todos os caracteres prontos, fazer delay.
          Serial.print("Aguardando o buffer receber todos os caracteres antes de avançar. ");
          Serial.print(Serial1.available());
          Serial.println(" Recebidos.");
          delay(10);
        }
        int n=0;    //inicializa um i temporario.
        char *ptr;

        Serial.println("Atualizando Hora e Data.");
        
        while(n<12){    //enquanto i for menor que 12.
          delay(1);
          if(n<2){    //primeira dupla de valores: DIA
            inStr[n]=Serial1.read();
          }
          else if(n<4){   //segunda dupla de valores: MES
            inStr[n-2]=Serial1.read();
          }
          else if(n<6){   //terceira dupla de valores: ANO
            inStr[n-4]=Serial1.read();
          }
          else if(n<8){   //quarta dupla de valores: HORA
            inStr[n-6]=Serial1.read();
          }
          else if(n<10){    //quinta dupla de valores: MINUTO
            inStr[n-8]=Serial1.read();
          }
          else if(n<12){    //sexta dupla de valores: SEGUNDO
            inStr[n-10]=Serial1.read();
          }

          //VERIFICAR O CODIGO, VER SE TODOS OS 'i' FORAM MUDADOS PARA 'n', DAR UMA OLHADA NO CODIGO DE 'inStr' para ver se esta funcionando corretamente.
          
          n++;    //incrementa i;
          inStr[2]='\0';  //finalizador de string na terceira posição
          if(n==2){   //primeiro valor: DIA
            delay(1);
            Serial.print(inStr);
            dia = strtol(inStr, &ptr, 10);
            time.setDate(dia);    //alterar DIA no RTC
            Serial.println(" - dia atualizado.");
          }
          if(n==4){   //segundo valor: MES
            delay(1);
            Serial.print(inStr);
            mes = strtol(inStr, &ptr, 10);
            time.setMonth(mes);   //alterar MES no RTC
            Serial.println(" - mes atualizado.");
          }
          if(n==6){   //terceiro valor: ANO
            delay(1);
            Serial.print(inStr);
            ano = strtol(inStr, &ptr, 10);
            time.setYear(ano);    //alterar ANO no RTC
            Serial.println(" - ano atualizado.");
          }
          if(n==8){   //quarto valor: HORA
            delay(1);
            Serial.print(inStr);
            hora = strtol(inStr, &ptr, 10);
            time.setHour(hora);   //alterar HORA no RTC
            Serial.println(" - hora atualizada.");
          }
          if(n==10){
            delay(1);
            Serial.print(inStr);
            minuto = strtol(inStr, &ptr, 10);
            time.setMinute(minuto);   //alterar MINUTO no RTC
            Serial.println(" - minuto atualizado.");
          }
          if(n==12){
            delay(1);
            Serial.print(inStr);
            segundo = strtol(inStr, &ptr, 10);
            time.setSecond(segundo);    //alterar SEGUNDO no RTC
            Serial.println(" - segundo atualizado");
          }
        }
        Serial.println("Data e Hora atualizados(eu acho)");
        //Serial1.print("OK");
      }
      else{

        char clk[30], filler[5];
        
        
        Serial1.print("S");
        if(time.getDate()<10){
          Serial1.print("0");
        }
        Serial1.print(time.getDate());
        Serial1.print("/");

        bool century;   //cria uma bool temporaria simplesmente para que a função getMonth funcione.
        
        if(time.getMonth(century)<10){
          Serial1.print("0");
        }
        Serial1.print(time.getMonth(century));
        Serial1.print("/");
        if(time.getYear()<10){
          Serial1.print("0");
        }
        Serial1.print(time.getYear());
        
        Serial1.print(" ");
        
        if(time.getHour(h12, PM)<10){
          Serial1.print("0");
        }
        Serial1.print(time.getHour(h12, PM));
        Serial1.print(":");
        if(time.getMinute()<10){
          Serial1.print("0");
        }
        Serial1.print(time.getMinute());
        Serial1.print("E");
        Serial.println("Data e Hora enviados.");
      }
      //Serial1.flush();
    }
    else if(strcmp(comStr, "REQ")==0){

      //SE A FREQUENCIA REQUISITA FOR INVALIDA(ABAIXO DE 1K OU ACIMA DE 100K) DEVOLVER UM ERRO/AVISO/ETC... A fazer
      delay(10);
      while(Serial1.available()!=-1 && Serial1.available()!=0){
        if(Serial1.available()>=4){
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
      index = strtol(inStr, &ptr, 10);
      Serial.print("INDEX=");
      Serial.println(index);
      Serial.print("PTR='");
      Serial.print(ptr);
      Serial.println("'");
      if(index>=1000 && index <=100000){
        if(frequencySweepCustom(index, 10 )){
          Serial.print("Sweep usando frequencia ");
          Serial.print(index);
          Serial.println(" completa.");
          EEPROM.put( ((EEPROM.read(0)*22)+1)  , leitura0);  //salva a nova leitura na EEPROM.
          Serial.println("Salvo na EEPROM.");
          EEPROM.write(0,(EEPROM.read(0)+1));    //o valor da posição 'i' recebe '0'.
          
          Req = true;
        }
        else{
          Serial.println("Sweep falhou, enviando erro.");
          Serial1.print("ERR");
        }
      }
      else{
        Serial.print("Valor de frequencia requerido não esta dentro dos limites validos, retornando ERRO.");
        Serial1.print("ERR");
      }
      //Serial1.flush();
    }
    else if(strcmp(comStr, "TMP")==0){
      Serial.println("Enviando temperatura.");
      
      double temperature = AD5933::getTemperature();
      Serial1.print("S");
      Serial1.print(temperature);
      Serial1.print("E");
      //Serial1.flush();
      
    }
    else if(strcmp(comStr, "GET")==0){
      delay(10);
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
      index = strtol(inStr, &ptr, 10);
      Serial.print("INDEX=");
      Serial.println(index);
      Serial.print("PTR='");
      Serial.print(ptr);
      Serial.println("'");
      //Serial1.flush();
      Get=true;
    }
    else{
      Serial.println("Algo inesperado foi recebido, limpando o serial. Enviando ERRO");
      Serial1.print("ERR");
      for (int i=0; i<10; i++){
        Serial1.read();
        if(Serial1.available()==0){
          i=10;
        }
      }
    }
  }
  if(Serial.available()!=-1 && Serial.available() != 0){
    while(Serial.available()>0){
      static int i=0;
      debugStr[i]=Serial.read();
      i++;
      if(Serial.available()==-1 || Serial.available()==0){
        i=0;
      }
    }
    Serial1.print(debugStr);
  }
  
}

void scrollBar(int j)
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
    display.drawLine(display.width()-1, (barSize+(j*offset)/2), display.width()-1,display.height()-1-((EEPROM.read(0)-(j+1))*offset)/2, WHITE);
}


void checkPins()    //função void necessaria para checar os botões.
{
  static int tempButton = 0;    //botão temporario que vai receber o valor do ultimo botão apertado para impedir que a ação se repita.
  if(digitalRead(buttonUP)||digitalRead(buttonDOWN)||digitalRead(buttonConfirm)||digitalRead(buttonCancel))    
  {
    //int buttonState = digitalRead(buttonLeft);
    // print out the state of the button:
    if(digitalRead(buttonUP) && tempButton != digitalRead(buttonUP)){
      tempButton = digitalRead(buttonUP);
      Serial.print("UP:");Serial.println(digitalRead(buttonUP));
      up=true;          
    }
    if(digitalRead(buttonDOWN) && tempButton != digitalRead(buttonDOWN)){
      tempButton = digitalRead(buttonDOWN);
      Serial.print("DOWN:");Serial.println(digitalRead(buttonDOWN));
      down=true;
    }
    if(digitalRead(buttonConfirm) && tempButton != digitalRead(buttonConfirm)){
      tempButton = digitalRead(buttonConfirm);
      Serial.print("Confirm:");Serial.println(digitalRead(buttonConfirm));
      yes=true;
    }
    if(digitalRead(buttonCancel) && tempButton != digitalRead(buttonCancel)){
      tempButton = digitalRead(buttonCancel);
      Serial.print("Cancel:");Serial.println(digitalRead(buttonCancel));
      no=true;
    }
    delay(10);
  }
  else {
    tempButton = 0;
  }
}
void clock()
{
  //private static String temptime = "0:0";
  
  if(time.getHour(h12, PM) < 10){
    temptime = "0";
    temptime += time.getHour(h12, PM);
    temptime += ":";

    if(time.getMinute() < 10){
      temptime += 0;
    }
    temptime += time.getMinute() ;
  }
  else {
    temptime = time.getHour( h12, PM);
    temptime += ":";
    if(time.getMinute() < 10){
      temptime += 0;
    }
    temptime += time.getMinute();
  }
  
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor((display.width()/2)-(temptime.length()*6/2), 0);
  display.print(temptime);
}
void clockAdjust()
{
  static bool doing = false, blinker = true, century;
  static int track = 0; //declarar e inicializar a variavel track, que será usada para definir o foco da função e o que será alterado(0=hora;1=minuto;2=dia;3=mes;4=ano)
  static int tempH, tempM, tempD, tempMn, tempY;  //declarando as variaveis temporarias responsaveis por receber os valor do rtc.
  static unsigned long timeTemp = 0;  static unsigned long tempTemp = 0;
  //display.setTextSize(2);
  
  if( doing == false )  //se for a primeira vez rodando essa função, receber os valores do rtc para as variaveis.
  {
    tempH = time.getHour( h12, PM );
    tempM = time.getMinute();
    tempD = time.getDate();
    tempMn = time.getMonth(century);
    tempY = time.getYear();
    
    doing = true;
  }

//[6+1][6+1][6+1]

  if(blinker){
    timeTemp = millis();    //variavel temporario recebe tempo em millis.
    if((timeTemp-tempTemp) > 500){    //se a diferença entre as duas variaveis temporarias for de 1/2 segundos.
      blinker = false;    //blinker recebe valor false.
      tempTemp = timeTemp;    //A variavel tempTemp recebe o valor da timeTemp para resetar a diferença.
    }
    
    if(track!=0){   //se NÃO for HORA.
      display.setTextSize(1);   //Definir tamanho do texto(1).
      display.setTextColor(WHITE);    //Definir cor do texto(BRANCO).
      display.setCursor(display.width()/2-15, barSize+4);    //Definir a posição do cursor(metade da largura da tela menos 2 caracteres e meio, meia linha abaixo da barra superior).
      if(tempH<10){
        display.print("0");   //Se o valor de HORA for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
      }
      display.print(tempH);   //Imprime valor Temporario de HORA.
    }
    display.setTextSize(1);   //Definir tamanho do texto(1).
    display.setTextColor(WHITE);    //Definir cor do texto(BRANCO).
    display.setCursor(display.width()/2-3, barSize+4);    //Definir a posição do cursor(metade da largura da tela menos meio caractere, meia linha abaixo da barra superior).
    display.print(":");   //Imprime separador de tempo.
    
    if(track!=1){   //se NÃO for MINUTO.
      display.setTextSize(1);   //Definir tamanho do texto(1).
      display.setTextColor(WHITE);    //Definir cor do texto(BRANCO).
      display.setCursor(display.width()/2+3, barSize+4);    //Definir a posição do cursor(metade da largura da tela mais meio caractere, meia linha abaixo da barra superior).
      if(tempM<10){
        display.print("0");   //Se o valor de MINUTO for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
      }
      display.print(tempM);   //Imprime valor Temporario de MINUTO.
    }
    
    if(track!=2){   //se NÃO for DIA.
      display.setTextSize(1);   //Definir tamanho do texto(1).
      display.setTextColor(WHITE);    //Definir cor do texto(BRANCO).
      display.setCursor(display.width()/2-25, barSize*2+6);   //Definir a posição do cursor(metade da largura da tela menos 4 caracteres, uma linha e meia abaixo da barrar superior).
      if(tempD<10){
        display.print(" ");   //Se o valor de DIA for menor que 10(e portante, apenas um caractere), imprime [ ] na posição.
      }
      display.print(tempD);   //Imprime valor Temporario de DIA.
    }
    display.setTextSize(1);   //Definir tamanho do texto(1).
    display.setTextColor(WHITE);    //Definir cor do texto(BRANCO).
    display.setCursor(display.width()/2-13, barSize*2+6);   //Definir a posição do cursor(metade da largura da tela menos 2 caracteres, uma linha e meia abaixo da barra superior).
    display.print("/");   //Imprime separador de data.
    
    if(track!=3){   //se NÃO for MES.
      display.setTextSize(1);   //Definir tamanho do texto(1).
      display.setTextColor(WHITE);    //Definir a cor do texto(BRANCO).
      display.setCursor(display.width()/2-7, barSize*2+6);   //Definir a posição do cursor(metade da largura da tela menos 1 caractere, uma linha e meia abaixo da barra superior).
      if(tempMn<10){
        display.print("0");   //Se o valor de MES for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
      }
      display.print(tempMn);    //Imprime valor Temporario de MES.
    }
    display.setTextSize(1);   //Definir tamanho do texto(1).
    display.setTextColor(WHITE);    //Definir cor do texto(BRANCO).
    display.setCursor(display.width()/2+5, barSize*2+6);    //Definir a posição do cursor(metade da largura da tela mais 1 caractere, uma linha e meia abaixo da barra superior).
    display.print("/");   //Imprime separador de data.
    
    if(track!=4){   //se NÃO for ANO.
      display.setTextSize(1);   //Definir tamanho do texto(1).
      display.setTextColor(WHITE);    //Definir a cor do texto(BRANCO).
      display.setCursor(display.width()/2+11, barSize*2+6);   //Definir a posição do cursor(metade da largura da tela mais 2 caracteres, uma linha e meia abaixo da barra superior).
      if(tempY<10){
        display.print("0");   //Se o valor de ano for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
      }
      display.print(tempY);   //Imprime valor Temporario de ANO.
    }
  }
  else{
    timeTemp = millis();    //variavel temporario recebe tempo em millis.
    if((timeTemp-tempTemp) > 500){    //se a diferença entre as duas variaveis temporarias for de 1/2 segundos.
      blinker = true;    //blinker recebe valor true e é ativado.
      tempTemp = timeTemp;    //A variavel tempTemp recebe o valor da timeTemp para resetar a diferença.
    }
    
    display.setTextSize(1);   //Definir tamanho do texto(1).
    display.setTextColor(WHITE);    //Definir a cor do texto(BRANCO).
    display.setCursor(display.width()/2-15, barSize+4);   //Definir a posição do cursor(metade da largura da tela menos 2 caracteres e meio).
    if(tempH<10){
      display.print("0");   //Se o valor de HORA for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
    }
    display.print(tempH);   //Imprime valor Temporario de HORA.

    display.print(":");   //Imprime separador de hora.

    if(tempM<10){
      display.print("0");   //Se o valor de MINUTE for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
    }
    display.print(tempM);   //Imprime valor Temporario de MINUTE.

    display.setCursor(display.width()/2-25, barSize*2+6);   //Definir a posição do cursor(metade da largura da tela menos 4 caracteres).
    if(tempD<10){
      display.print(" ");   //Se o valor de DIA for menor que 10(e portanto, apenas um caractere), imprime [ ] na posição.
    }
    display.print(tempD);   //Imprime valor Temporario de DIA.
    display.print("/");   //Imprime separador de data.
    if(tempMn<10){
      display.print("0");   //Se o valor de MES for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
    }
    display.print(tempMn);    //Imprime valor Temporario de MES.
    display.print("/");   //Imprime separador de data.
    if(tempY<10){
      display.print("0");   //Se o valor de ANO for menor que 10(e portanto, apenas um caractere), imprime 0 na posição.
    }
    display.print(tempY);   //Imprime valor Temporario de ANO.
  }

  switch(track)
  {
    case 0: //hora: de 0 a 23 horas.
    {
      if(up)  //se o botão UP tiver valor true.
      {
        if(tempH<23){ //se a hora for menor que 23 horas
          tempH++;  //adiciona uma hora a mais.
        }
        else{ //se a hora for 23 horas.
          tempH = 0;  //volta a hora 0(equivalente as 24 horas)
        }
        up=false; //reseta o valor do botão UP para false.
      }
      if(down)  //se o botão DOWN tiver valor true.
      {
        if(tempH>0){  //se a hora for maior que 0 horas.
          tempH--;  //diminui uma hora.
        }
        else{ //se a hora tiver valor 0.
          tempH = 23; //volta a hora 23.
        }
        down=false; //reseta o valor do botão DOWN para false.
      }
      if(yes) //se o botão YES tiver valor true.
      {
        time.setHour(tempH);  //setta o minuto do rtc com o valor de tempH;
        yes=false;  //reseta o valor do botão YES para false. Melhor fazer isso antes de avançar a track.
        doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
        track++;  //track avança para a proxima.
        }
      if(no)  //se o botão NO tiver valor true.
      {
        //tempH = time.getHour( h12, PM );  //recupera o valor valor de hora salvo no rtc.
        //no=false; //reseta o valor do botão NO para false.
        //screen = 0; //retornar para a screen anterior.
        doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
      }
      break;  //fim da logica da track 0 representando as horas.
    }
    
    
    case 1: //minuto
    {     
      if(up)  //se o botão UP tiver valor true.
      {
        if(tempM<59)  //se o minuto for menor que 59.
       {
         tempM++; //adiciona um minuto a mais.
        }
        else  //se o minuto for 59.
        {
          tempM = 0;  //retornar ao minuto 0.
        }
        up=false; //reseta o valor do botão UP para false.
      }
      if(down)  //se o botão DOWN tiver valor true.
      {
        if(tempM>0){  //se o minuto for maior que 0.
          tempM--;  //minuto diminui por um.
        }
        else{ //se o minuto for 0.
          tempM=59; //minuto retornar ao valor 59.
        }
        down=false; //reseta o valor do botão DOWN para false.
      }
      if(yes) //se o botão YES tiver valor true.
      {
        time.setMinute(tempM);  //setta o minuto do rtc com o valor de tempM;
        yes=false;  //reseta o valor do botão YES para false.
        doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
        track++;  //avança para a proxima track.
      }
      if(no)  //se o botão NO tiver valor true.
      {
        doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
        no=false; //reseta o valor do botão NO para false.
        track--;  //retorna a track anterior.
      }
      break;  //fim da logica da track 1 representando os minutos.
      
    }
    case 2: //dia
    { 
      if(up){  //se o botão UP tiver valor true.  
        if(tempMn==2){  //se o mes for fevereiro
          if(tempD<28){ //se o dia for menor que 28
            tempD++;  //adiciona um dias a mais.
          }
          else{ //se o dia for 28(ou mais).
            tempD = 1;  //volta ao primeiro dia do mes.
          }
        }
        else if(tempMn<8){  //se o mes for antes de agosto
          if(tempMn % 2 != 0){  //se o mes for impar(meses impares antes de agosto tem 31 dias)
            if(tempD<31){ //se o dia for menor que 31.
              tempD++;  //adiciona um dia a mais.
            }
            else{ //se o dia for 31.
              tempD = 1;  //volta ao primeiro dia do mes.
            }
          }
          else{ //se o mes for par(meses pares antes de agosto tem 30 dias exceto por fevereiro.)
            if(tempD<30){ //se o dia for menor que 30.
              tempD++;  //adiciona um dia a mais.
            }
            else{ //se o dia for 30.
              tempD = 1;  //volta ao primeiro dia do mes.
            }
          }
        }
        else{ //se o mes for pelo menos agosto.
          if(tempMn % 2 == 0){ //se o mes for par(mese pares a partir de agosto tem 31 dias)
            if(tempD<31){ //se o dia for menor que 31.
              tempD++;  //adiciona um dia a mais.
            }
            else{ //se o dia for 31.
              tempD = 1;  //volta ao primeiro dia do mes.
            }
          }
          else{ //se o mes for impar(mese impares a partir de agosto tem 30 dias.
            if(tempD<30){ //se o dia for menor que 30.
              tempD++;  //adiciona um dias a mais.
            }
            else{ //se o dia for 30.
              tempD = 1;  //volta ao primeiro dias do mes.
            }
          }
        }
        up=false; //reseta o valor do botão UP para false.
      }
      
      if(down){  //se o valor do botão DOWN for true.
        if(tempD>1){  //se o dia for maior que 1.
          tempD--;
        }
        else{ //se o dia for 1.
          if(tempMn==2){  //se o mes for fevereiro.
            tempD = 28; //dia retornar a 28.
          }
          else if(tempMn<8){  //se o mes não for fevereiro e for antes de agosto.
            if(tempMn % 2 == 0){  //se o numero do mes for par.(meses pares antes de agosto tem 30 dias exceto por fevereiro)
              tempD = 30; //dia retorna a 30.
            }
            else{ //se o numero do mes for impar(31 dias).
              tempD = 31; //dia retorna a 31.
            }
          }
          else{ //se o mes não for vereiro e for pelo menos agosto.
            if(tempMn % 2 == 0){  //se o numero do mes for par.(meses pares a partir de agosto tem 31 dias)
              tempD = 31; //dia retorna a 31.
            }
            else{ //se o numero do mes for impar.(30 dias)
              tempD = 30; //dia retorna a 30.
            }
          }
        }
        down=false; //reseta o valor do botão DOWN para false.
      }
      
      if(yes) //se o valor do botão YES for true.
      {
        yes=false;  //reseta o valor do botão YES para false.
        time.setDate(tempD);  //setta o valor de dia no rtc com o valor do tempD.
        doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
        track++;  //avança ao proximo track.
      }
      if(no)  //se o valor do botão NO for true.
      {
        doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
        no=false; //reseta o valor do botão NO para false.
        track--;  //retorna a track anterior.
      }
      break;  //final da track 2 do dia.
    }
    case 3: //mes
    {
      if(up)  //se o valor do botão UP for true.
      {
        if(tempMn <12){ //se o mes for antes de dezembro.
          tempMn++; //adiciona um mes.
        }
        else{ //se o mes for dezembro.
          tempMn = 1; //retorna ao mes 1
        }
        up=false; //reseta o valor do botão UP para false.
      }
      
      if(down)  //se o valor do botão DOWN for true.
      {
        if(tempMn>1){ //se o mes for maior que 1.
          tempMn--; //diminuit um mes.
        }
        else{ //se o mes for 1;
          tempMn = 12;  //retorna ao mes 12.
        }
        down=false; //reseta o valor do botão DOWN para false.
      }
      
      if(yes) //se o valor do botão YES for true.
      {
        yes=false;  //reseta o valor do botão YES para false.
        time.setMonth(tempMn);  //setta o valor do mes no rtc com o valor do tempMn

        if(tempD>28){  //se o dia for maior ou igual a 28 quando o mes for mudado.
          if(tempMn==2){  //se o mes for fevereiro
            tempD=28; //tempD muda para dia 28.
            time.setDate(tempD); //setta o dia no rtc para 28.
          }
          else if(tempD>30){  //se o mes não for fevereiro e o dia for maior que 31.
            if(tempMn < 8){ //se o mes for antes de agosto.
              if(tempMn % 2 == 0){ //se o mes for par(meses pares antes de agosto tem 30 dias).
                tempD = 30; //tempD muda para dia 30.
                time.setDate(tempD); //setta o dia no rtc para 30.
              }
            }
            else if(tempMn % 2 != 0){ //se o mes for pelo menos agosto e impar(meses impares a partir de agosto tem 30 dias).
              tempD = 30; //tempD muda para dia 30.
              time.setDate(tempD); //setta o dia no rtc para 30.
            }
          }
        }
        doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.        
        track++;  //avança para a proxima track.
      }
      
      if(no)  //se o valor do botão NO for true.
      {
        doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
        no=false; //reseta o valor do botão NO para false.
        track--;  //retorna a track anterior.
      }      
      break;  //final da track 3.
    }
    case 4: //ano
    {
      if(up)  //se o valor do botão UP for true.
      {
        tempY++;  //adiciona um numero ao valor de ano.
        up=false; //reseta o valor do botão UP para false.
      }
      if(down)  //se o valor do botão DOWN for true.
      {
        tempY--;  //diminui o valor de ano.
        down=false; //reseta o valor do botão DOWN para false.
      }
      if(yes) //se o valor do botão YES for true.
      {
        time.setYear(tempY);  //setta o valor no rtc do ano com valor em tempY.
        doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
        yes=false;  //resetar o valor de YES para false.
        track = 0; //retorna a track 0 representando a hora.
      }
      if(no)  //se o valor do botão NO for true.
      {
        doing=false;    //reseta o valor de doing para que a proxima vez que adjustClock for chamado que os valores das variaveis sejam recuperados do rtc.
        no=false; //resetar o valor do botão NO para false.
        track--;  //retornar a track anterior.
      }
      break;  //fim da track 4 representando o ano
    }
  }
}
void frequencySweepEasy() {
    // Create arrays to hold the data
    int real[NUM_INCR+1], imag[NUM_INCR+1];

    // Perform the frequency sweep
    if (AD5933::frequencySweep(real, imag, NUM_INCR+1)) {
      // Print the frequency data
      double cfreq = (START_FREQ);
      for (int i = 0; i < NUM_INCR+1; i++, cfreq += FREQ_INCR) {
        // Print raw frequency data
        Serial.print(cfreq/1000);
        Serial.print(": R=");
        Serial.print(real[i]);
        Serial.print("/I=");
        Serial.print(imag[i]);

        // Compute impedance
        double magnitude = sqrt(pow(real[i], 2) + pow(imag[i], 2));
        double impedance = 1/(magnitude*gain[i]);
        Serial.print("  |Z|=");
        Serial.println(impedance);
      }
      Serial.println("Frequency sweep complete!");
    } else {
      Serial.println("Frequency sweep failed...");
    }
}

bool frequencySweepCustom(unsigned long FREQ, int NUM ){
  medReal=0;  //reseta os valores medios de real e imaginario.
  medImag=0;
  int real, imag, i=0;
  double cfreq = FREQ*0.95;
  double inc = (FREQ/100);
  Serial.println(FREQ);
  Serial.println(cfreq);

  if(!AD5933::reset()){
    Serial.println("Reset Falhou");
    return false;
  }
  delay(1);
  if(!AD5933::setInternalClock(true)){
    Serial.println("SetInternalClock Falhou");
    return false;
  }
  delay(1);
  if(!AD5933::setStartFrequency(FREQ*0.95)){
    Serial.println("SetStartFrequency Falhou");
    return false;
  }
  delay(1);
  if(!AD5933::setIncrementFrequency(FREQ/100)){
    Serial.println("SetIncrementFrequency Falhou");
    return false;
  }
  delay(1);
  if(!AD5933::setNumberIncrements(NUM)){
    Serial.println("SetNumberIncrements Falhou");
    return false;
  }
  delay(1);
  if(!AD5933::setPGAGain(PGA_GAIN_X1)){
    Serial.println("SetPGAGain Falhou");
    return false;
  }
  delay(1);
  
  if(!(AD5933::setPowerMode(POWER_STANDBY) &&
       AD5933::setControlMode(CTRL_INIT_START_FREQ) &&
       AD5933::setControlMode(CTRL_START_FREQ_SWEEP)))
       {
        Serial.print("Falhou em inicializar SWEEP.");
       }
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
  medReal/=(NUM+1);
  medImag/=(NUM+1);
  
  Serial.println("Completo!");
  Serial.print("MedReal=");
  Serial.println(medReal);
  Serial.print("MedImag=");
  Serial.println(medImag);
  bool h12,PM,century;
  leitura0={FREQ, medReal, medImag, time.getHour( h12,  PM), time.getMinute(), time.getDate(), time.getMonth( century), time.getYear()};

  Serial.print("EEPROM address 0:");Serial.println(EEPROM.read(addr));
  
    // Set AD5933 power mode to standby when finished
  if (!AD5933::setPowerMode(POWER_STANDBY))
        Serial.println("Could not set to standby...");
}

bool defaultConfig()
{
       Serial.print("Resetar AD:");
  if(AD5933::reset()) {    Serial.println("Sucesso");  }
  else{ Serial.println("Falhou");
        return false;            }
  delay(1);
  
       Serial.print("Configurar Relogio interno:");
  if(AD5933::setInternalClock(true))  {     Serial.println("Sucesso");  }
  else{ Serial.println("Falhou");
        return false;            }
  delay(1);

    Serial.print("Iniciar frequencia(");Serial.print(START_FREQ*(0.95));Serial.print("):");
  if(AD5933::setStartFrequency(START_FREQ*0.95))  {    Serial.println("Sucesso");  }
  else{ Serial.println("Falhou");
        return false;            }
  delay(1);

      Serial.print("Configurar Incremento de Frequencia(");Serial.print(FREQ_INCR);Serial.print("):");
  if(AD5933::setIncrementFrequency(FREQ_INCR))  {    Serial.println("Sucesso"); }
  else{ Serial.println("Falhou");
        return false;            }
  delay(1);

      Serial.print("Configurar Numero de Incrementos(");Serial.print(NUM_INCR);Serial.print(");");
  if(AD5933::setNumberIncrements(NUM_INCR))  {    Serial.println("Sucesso");  }
  else{ Serial.println("Falhou");
        return false;            }
  delay(1);

      Serial.print("Configurar ganho PGA X1:");
  if(AD5933::setPGAGain(PGA_GAIN_X1))  {    Serial.println("Sucesso");  }
  else{ Serial.println("Falhou");
        return false;            }
  delay(1);
  return true;
}

