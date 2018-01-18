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


#include <AD5933.h> //incluir a library da AD.
#define START_FREQ  (50000) // frequencia inicial padrão.
#define FREQ_INCR   (START_FREQ/100) // incremento de frequencia padrão.
#define NUM_INCR    (10)  // numero padrão de incrementos.
#define REF_RESIST  (10000) // valor de referencia de resistor.
double gain[NUM_INCR+1];  // vetor double para conter o valor de ganho.
int phase[NUM_INCR+1];  // vetor int para conter o valor de fase.

int real[NUM_INCR+1], imag[NUM_INCR+1]; // vetores do tipo int para conter os valores reais e imaginarios da impedancia.

#define OLED_RESET 4
Adafruit_SSD1306 display(OLED_RESET);
DS3231 time;
AD5933 AD;

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
const int buttonLeft = 23;
const int buttonRight = 25;
const int buttonConfirm = 24;
const int buttonCancel = 22;
const int potPin = A15;

int pwr;
int pct;

int selector = 1;
int screen = 0;
int barSize = 8;
bool up=false,down=false,yes=false,no=false, BLE;
static String temptime = "0:0";

//Inicialização.

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Serial1.begin(9600);
  BLE=true;
  
  Serial.println("starting");
  
  //display.setRotation(2); // mudando a rotação da tela
  Wire.begin(); //Inicializar o Wire
  Wire.setClock(400000);  //Definir a velocidade de clock do Wire para conversar com a AD.

  while(!defaultConfig());

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

  pinMode(buttonLeft, INPUT);
  pinMode(buttonRight, INPUT);
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
  /*
  display.drawRect(0,0, display.width(), display.height(), WHITE);
  display.display();
  delay(250);
  clock();
  display.display();
  delay(250);
  selector = 0;
  menu();
  display.display();
  delay(250);
  */
  selector = 1;

  
  /*Wire.requestFrom(0x0D, 7);
  delay(1);
      byte d = Wire.available();
    Serial.print(d);
  while(Wire.available())
  {

    char c = Wire.read();
    Serial.print(c);
  }
  */
  delay(500);
  
}

void loop() {
  // put your main code here, to run repeatedly:

  display.clearDisplay();
  //clock();
  checkPins();
  menu();  // ALTERAR MENU COMEÇAR TUDO ABAIXO DA BARRA SUPERIOR

  
  //display.drawRect(0,9, display.width(), display.height()-9, WHITE); // desenha o retangulo abaixo da barra superior
  upperBar(); // desenha a barra superior com bateria, bluetooth e relogio.
  
  
  

  display.display();


  
  delay(1);  

}

void upperBar() // barra superior.
{
  display.fillRect(0, 0, display.width(), barSize, BLACK); // desenha a barra em preto, mantendo permanentemente a barrar acima de tudo.

  
  pwr = analogRead(potPin); 
  pct = map(pwr,0,1023,0,100);
  pwr = map(pwr, 0, 1023, 0, 12);

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
  
  
  scrollBar();


}

/*
 * void serialEvent1() 
{
  static String last_cmd;
  static bool working = false;
  static float d1, d2;
  //if( Serial1.available() ) {
    if (working == false) {
      Serial.println( "Bluetooth Working" );
      working = true;
    }
    String input;
    if( ( input = Serial1.readString() ) != -1 )
    {
      Serial.println( input );
      
      last_cmd = input;

      if( input == "CHK" ) 
      {
        Serial1.print( temptime );
        Serial1.flush();
        Serial.print("Time sent - ");Serial.println( temptime );
        input = "";
      }
      else if ( input == "OK" ) 
      {
        Serial1.println("OK");
        Serial1.flush();
        Serial.print("OK Received: OK Sent - ");Serial.println( temptime );
        input = "";
      }
      
    }
  //}
}
*/

void scrollBar()
{
  static int n=4; //inicializando um int com o numero de opções na tela 0.
  static int s= 100*(3*8)/(n*8); // inicializando um float s para receber o valor de 0 a 100 entre o numero 3*8(3 opções, limite de opções em uma tela) dividido por n*8(n opções) tudo multiplicado por 100.

  s = map(s,1,100,(3*8),1); //utiliza a função map para definir o tamanho em pixels da barra de scroll;

  if(screen==0)
  {
    if(selector<=3)
    {
      display.drawLine(display.width()-1,8, display.width()-1,s+8, WHITE);
    }
    else if(selector<=5)
    {
      display.drawLine(display.width()-1, display.height(), display.width()-1, display.height()-s, WHITE);
    }
  }
}


void checkPins()
{
  static int temp = 0;
  if(digitalRead(buttonLeft)||digitalRead(buttonRight)||digitalRead(buttonConfirm)||digitalRead(buttonCancel))
  {
    //int buttonState = digitalRead(buttonLeft);
    // print out the state of the button:
    if(digitalRead(buttonLeft) && temp != digitalRead(buttonLeft)){
      temp = digitalRead(buttonLeft);
      Serial.print("Left:");Serial.println(digitalRead(buttonLeft));
        switch(screen)
        {
          case 0:
          {
            if(selector>1)
            {
              selector--;
            }
            else
            {
              selector = 4;
            }
            break;
          }
          case 2:
          {
            up=true;
            break;
          }
          case 3:
          {
            up=true;
            break;
          }
          case 4:
          {
            up = true;
            break;
          }
          case 5:
          {
            up = true;
            break;
          }
        }
    }
    if(digitalRead(buttonRight) && temp != digitalRead(buttonRight)){
      temp = digitalRead(buttonRight);
      Serial.print("Right:");Serial.println(digitalRead(buttonRight));        
        if(screen == 0)
        {
          if(selector < 4 ) {
            selector++;
          }
          else {
            selector = 1;
          }
        }
        if(screen == 2)
        {
          down = true;
        }
        if(screen == 3)
        {
          down = true;
        }
        if(screen == 4)
        {
          down = true;
        }
        if(screen == 5)
        {
          down = true;
        }
    }
    if(digitalRead(buttonConfirm) && temp != digitalRead(buttonConfirm)){
      temp = digitalRead(buttonConfirm);
      Serial.print("Confirm:");Serial.println(digitalRead(buttonConfirm));
      switch(screen) {
        case 0:
          screen = selector;
          break;

        case 1:
          yes = true;
          break;

        case 2:
          yes = true;
          break;

        case 3:
          yes = true;
          break;
          
        case 4:
          yes = true;
          break;

        case 5:
          yes = true;
          break;

        default:
          //yes = true;
          break;
          
      }
    }
    if(digitalRead(buttonCancel) && temp != digitalRead(buttonCancel)){
      temp = digitalRead(buttonCancel);
      Serial.print("Cancel:");Serial.println(digitalRead(buttonCancel));
      switch(screen) {
        case 1:
          no = true;
          break;

        case 2:
          screen = 0;
          break;

        case 3:
          //screen = 0;
          no = true;
          break;

        case 4:
          //screen = 0;
          no = true;
          break;

        case 5:
        no = true;
        break;

        case 6:
        no = true;
        break;
      }
    }
    delay(10);
  }
  else {
    temp = 0;
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
  
  if( doing == false )  //se for a primeira vez rodando essa função, receber os valores do rtc para as variaveis.
  {
    tempH = time.getHour( h12, PM );
    tempM = time.getMinute();
    tempD = time.getDate();
    tempMn = time.getMonth(century);
    tempY = time.getYear();
    
    doing = true;
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
        track++;  //track avança para a proxima.
        }
      if(no)  //se o botão NO tiver valor true.
      {
        tempH = time.getHour( h12, PM );  //recupera o valor valor de hora salvo no rtc.
        no=false; //reseta o valor do botão NO para false.
        screen = 2; //retornar para a screen anterior.
      }

    display.setCursor(display.width()/2-24, barSize); //prepara o cursor para ficar em posição.
    if(blinker == false){ //se o blinker for FALSE.
      if(tempH <10){  //se a hora for menor que 10.
        display.print("0"); //imprime 0.
      }
      display.print(tempH); //imprime a hora.
      timeTemp = millis();  //variavels temporaria recebe tempo.
      if((timeTemp-tempTemp) > 500){ //se a diferença entre as variaveis temporarias for de 1 segundo
        blinker = true; //blinker recebe valor true e é ativado.
        tempTemp = timeTemp;  //a variavel tempTemp recebe o valor da timeTemp para resetar a diferença.
      }
    }
    else{ //se o blinker for TRUE.
      display.print("  ");  //printa apenas espaços vazios, passando o cursor para dois caracteres a diante.
      timeTemp = millis();  //variavel temporaria recebe tempo.
      if((timeTemp-tempTemp) > 200){  //se a diferença entre variaveis temporarias for de 1/2 segundo.
        blinker = false; //blinker recebe valor false e é desativado.
        tempTemp = timeTemp;  //a variavel tempTemp recebe o valor da timeTemp para resetar a diferença.
      }
    }
    //fim da logica de blinker da hora.

    display.print(":"); //imprime os dois pontos separando os valores de hora e minuto.
    if(tempM < 10){ //se o minuto for menor que 10.
      display.print("0"); //imprime 0.
    }
    display.print(tempM); //imprime minuto.
    //fim da logica de minuto.
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
        track++;  //avança para a proxima track.
      }
      if(no)  //se o botão NO tiver valor true.
      {
        tempM = time.getMinute(); //recupera o valor de minuto salvo no rtc.
        no=false; //reseta o valor do botão NO para false.
        track--;  //retorna a track anterior.
      }

      display.setCursor(display.width()/2-24, barSize); //prepara o cursor para ficar em posição.
      if(tempH<10){ //se a hora for menor que 10.
        display.print("0"); //imprime 0.
      }
      display.print(tempH); //imprime a hora.
      display.print(":"); //imprime dois pontos separando hora e minuto.

      if(blinker == false){ //se o blinker for FALSE.
        if(tempM <10){  //se o minuto for menor que 10.
          display.print("0"); //imprime 0.
        }
        display.print(tempM); //imprime o minuto.
        timeTemp = millis();  //variavels temporaria recebe tempo.
        if((timeTemp-tempTemp) > 500){ //se a diferença entre as variaveis temporarias for de 1 segundo
          blinker = true; //blinker recebe valor true e é ativado.
          tempTemp = timeTemp;  //a variavel tempTemp recebe o valor da timeTemp para resetar a diferença.
        }
      }
      else{ //se o blinker for TRUE.
        display.print("  ");  //printa apenas espaços vazios, passando o cursor para dois caracteres a diante.
        timeTemp = millis();  //variavel temporaria recebe tempo.
        if((timeTemp-tempTemp) > 200){  //se a diferença entre variaveis temporarias for de 1/2 segundo.
          blinker = false; //blinker recebe valor false e é desativado.
          tempTemp = timeTemp;  //a variavel tempTemp recebe o valor da timeTemp para resetar a diferença.
        }
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
        track++;  //avança ao proximo track.
      }
      if(no)  //se o valor do botão NO for true.
      {
        no=false; //reseta o valor do botão NO para false.
        tempD = time.getDate(); //recupera o valor da data salvo no rtc.
        track--;  //retorna a track anterior.
      }

      display.setCursor(display.width()/2-39, barSize); //prepara o cursor para ficar em posição.

      if(blinker == false){ //se o blinker for FALSE.
        if(tempD <10){  //se a dia for menor que 10.
          display.print("0"); //imprime 0.
        }
        display.print(tempD); //imprime o dia.
        timeTemp = millis();  //variavels temporaria recebe tempo.
        if((timeTemp-tempTemp) > 500){ //se a diferença entre as variaveis temporarias for de 1 segundo
          blinker = true; //blinker recebe valor true e é ativado.
          tempTemp = timeTemp;  //a variavel tempTemp recebe o valor da timeTemp para resetar a diferença.
        }
      }
      else{ //se o blinker for TRUE.
        display.print("  ");  //printa apenas espaços vazios, passando o cursor para dois caracteres a diante.
        timeTemp = millis();  //variavel temporaria recebe tempo.
        if((timeTemp-tempTemp) > 200){  //se a diferença entre variaveis temporarias for de 1/2 segundo.
          blinker = false; //blinker recebe valor false e é desativado.
          tempTemp = timeTemp;  //a variavel tempTemp recebe o valor da timeTemp para resetar a diferença.
        }
      }
      //final da logica de blinker do dia.

      display.print("/"); //imprime '/' como separador entre dia e mes.
      if(tempMn<10){  //se o mes for menor que 10.
        display.print("0"); //imprime 0.
      }
      display.print(tempMn);  //imprime o mes.

      display.print("/"); //imprime '/' como separador entre mes e ano.
      if(tempY<10){
        display.print("0");
      }
      display.print(tempY); //imprime o ano
      
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
        track++;  //avança para a proxima track.
      }
      
      if(no)  //se o valor do botão NO for true.
      {
        no=false; //reseta o valor do botão NO para false.
        tempMn = time.getMonth(century); //tempMn recebe o valor do mes do rtc.
        track--;  //retorna a track anterior.
      }      
      display.setCursor(display.width()/2-39, barSize); //prepara o cursor para ficar em posição.
      
      if(tempD<10){  //se o dia for menor que 10.
        display.print("0"); //imprime 0.
      }
      display.print(tempD);  //imprime o dia.
      display.print("/"); //imprime '/' como separador entre dia e mes.
      
      if(blinker == false){ //se o blinker for FALSE.
        if(tempMn <10){  //se a mes for menor que 10.
          display.print("0"); //imprime 0.
        }
        display.print(tempMn); //imprime o mes.
        timeTemp = millis();  //variavels temporaria recebe tempo.
        if((timeTemp-tempTemp) > 500){ //se a diferença entre as variaveis temporarias for de 1 segundo
          blinker = true; //blinker recebe valor true e é ativado.
          tempTemp = timeTemp;  //a variavel tempTemp recebe o valor da timeTemp para resetar a diferença.
        }
      }
      else{ //se o blinker for TRUE.
        display.print("  ");  //printa apenas espaços vazios, passando o cursor para dois caracteres a diante.
        timeTemp = millis();  //variavel temporaria recebe tempo.
        if((timeTemp-tempTemp) > 200){  //se a diferença entre variaveis temporarias for de 1/2 segundo.
          blinker = false; //blinker recebe valor false e é desativado.
          tempTemp = timeTemp;  //a variavel tempTemp recebe o valor da timeTemp para resetar a diferença.
        }
      }
      //final da logica de blinker do mes.

      display.print("/"); //imprime '/' como separador entre mes e ano.
      
      if(tempY<10){
        display.print("0");
      }
      display.print(tempY); //imprime o ano
      

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
        yes=false;  //resetar o valor de YES para false.
        track = 0; //retorna a track 0 representando a hora.
      }
      if(no)  //se o valor do botão NO for true.
      {
        tempY = time.getYear(); //tempY recebe o valor de ano salvo no rtc.
        no=false; //resetar o valor do botão NO para false.
        track--;  //retornar a track anterior.
      }
      display.setCursor(display.width()/2-39, barSize); //prepara o cursor para ficar em posição.
    
      if(tempD<10){  //se o dia for menor que 10.
        display.print("0"); //imprime 0.
      }
      display.print(tempD);  //imprime o dia.
      
      display.print("/"); //imprime '/' como separador entre dia e mes.
      if(tempMn<10){  //se o mes for menor que 10.
        display.print("0"); //imprime 0.
      }
      display.print(tempMn);  //imprime o mes.

      display.print("/"); //imprime '/' como separador entre mes e ano.
       if(blinker == false){ //se o blinker for FALSE.
        if(tempY <10){  //se o ano for menor que 10(apenas os ultimos dois digitos).
          display.print("0"); //imprime 0.
        }
        display.print(tempY); //imprime o ano.
        timeTemp = millis();  //variavels temporaria recebe tempo.
        if((timeTemp-tempTemp) > 500){ //se a diferença entre as variaveis temporarias for de 1 segundo
          blinker = true; //blinker recebe valor true e é ativado.
          tempTemp = timeTemp;  //a variavel tempTemp recebe o valor da timeTemp para resetar a diferença.
        }
      }
      else{ //se o blinker for TRUE.
        display.print("  ");  //printa apenas espaços vazios, passando o cursor para dois caracteres a diante.
        timeTemp = millis();  //variavel temporaria recebe tempo.
        if((timeTemp-tempTemp) > 200){  //se a diferença entre variaveis temporarias for de 1/2 segundo.
          blinker = false; //blinker recebe valor false e é desativado.
          tempTemp = timeTemp;  //a variavel tempTemp recebe o valor da timeTemp para resetar a diferença.
        }
      }
      //final da logica de blinker do ano.

      break;  //fim da track 4 representando o ano
    }
  }
}


void menu()
{
  static char* menubase[] = { "1.Leituras", "2.Sincronizar", "3.Ajustes","4.---" };
  static char* menu0[] = { "1.Leituras", "2.Sincronizar", "3.Ajustes", "4.---" };
  static unsigned int size1 = 46*7;//tamanho de menu0[0]: 46 caracteres * 7 pixels(5 de cada caracter e o espaço entre eles)
  static unsigned int scroller = 1, scrolling;
  static boolean scroll = false;
  
  display.setTextWrap(false);    
       
  switch(screen) {
    case 0:
      //display.fillRect(display.width()/2, 0, display.width()/2-2, display.height(), WHITE);
      //display.drawRect(display.width()/2+1, 1, display.width(), display.height()-2, BLACK);
      //display.setTextColor(BLACK); 

                //unnecessary on the new design.

      
  
      switch(selector) {
        case 1:
 
          //display.fillRect(display.width()/4-1, 3, display.width()/3, 9, WHITE);
          //display.setCursor(display.width()/4, 4);

          display.fillRect(1, barSize, display.width()-5, 8, WHITE);
                //changing from a white background dividing the screen in half by length to a black background with no division but under the upper bar.

          display.setCursor(3, barSize);

          /*if(scroll==true) {
            scrolling = 1;
            display.setCursor(display.width()/3-scroller, barSize);
            display.setTextColor(BLACK, WHITE);
            display.print(menu0[0]);
            scroller+=1;
            if ( (size1-scroller) <= display.width()/2) {
              scroll = false;
              scroller = 1;
              delay(250);
            }
          }
          else*/ {
            display.setCursor(2, barSize);
            display.setTextColor(BLACK);
            display.print(menu0[0]);
          }
          /*
          display.setTextColor(BLACK);
          display.print(menu0[0]);
          */
  
          display.setCursor(3, barSize+8);
          display.setTextColor(WHITE);;
          display.println(menubase[1]);
          display.setCursor(3, barSize+(2*8));
          display.println(menubase[2]);
          display.setCursor(3, barSize+(3*8));
          display.println(menubase[3]);
          break;
  
        case 2:
          //display.fillRect(display.width()/4-1, 3+8, display.width()/4+2, 9, WHITE);
          //display.setCursor(display.width()/4, 4+8);

          display.fillRect(1, barSize+8, display.width()-5, 8, WHITE);

          display.setCursor(2, barSize+8);

          if(scrolling != selector) {
              //scroll = true;
              scroller = 1;
          }
          
          display.setTextColor(BLACK, WHITE);
          display.print(menu0[1]);


          display.setTextColor(WHITE);
          display.setCursor(3, barSize);
          display.println(menubase[0]);
          display.setCursor(3, barSize+(2*8));
          display.println(menubase[2]);
          display.setCursor(3, barSize+(3*8));
          display.println(menubase[3]);
          break;
  
        case 3:
          //display.fillRect(display.width()/4-1, 3+8+8, display.width()/4+2, 9, WHITE);
          //display.setCursor(display.width()/4, 4+8+8);

          display.fillRect(1, barSize+(2*8), display.width()-5, 8, WHITE);
          display.setCursor(2, barSize+(2*8));
          
          display.setTextColor(BLACK, WHITE);
          display.print(menu0[2]);     

          display.setTextColor(WHITE);
          display.setCursor(3, barSize);
          display.println(menubase[0]);
          display.setCursor(3, barSize+(2*8)-8);
          display.println(menubase[1]);
          display.setCursor(3, barSize+(2*8)+8);
          display.println(menubase[3]);
          break;

        case 4:

          display.fillRect(1, barSize+8, display.width()-5, 8, WHITE);
          display.setCursor(2, barSize+8);

          display.setTextColor(BLACK, WHITE);
          display.print(menu0[3]);

          display.setTextColor(WHITE);
          display.setCursor(3, barSize);
          display.print(menubase[2]);
          //display.setCursor(3, barSize+(2*8));
          //display.print(menubase[1]);
          //display.setCursor(3, barSize+(3*8)-(3*8));
          //display.print(menubase[0]);
          break;
          
        
        }
        break;

      case 1:   //screen 1 - Leituras
      {
        static int choice = 0;  //inicializa uma variavel int 'choice' que deve ser usada para percorrer o menu secundario da tela de leituras. (0)1-Nova Leitura | (1)2-historico |
                                //usar a opção choice para imprimir as telas dos submenus. (2)Fazer a leitura, gerar a media e o angulo de phase e retornar. | (3)abrir historico salvo na EEPROM(a fazer)
        switch(choice){
          case 0: //1-Nova Leitura.
            display.setCursor(0,barSize); //reseta posição do cursor
            display.setTextColor(BLACK,WHITE);  //fundo branco, letras pretas.
            display.println(" 1-Nova Leitura."); 
            display.setTextColor(WHITE);  //letras brancas.
            display.print(" 2-Historico.");
            if(yes){  //se YES for true.
              choice=2; //altera para a choice 2, aonde a AD vai realizar a leitura.
              yes = false;  //reseta YES.
            }
            if(no){
              screen = 0;
              no = false;
            }
            break;

          case 1:
            
            break;
        }

/*

        
        static boolean sweep = false; //inicializa uma variavel boolean sweep que determina se uma sweep ja foi feita e declara como false.
        static int i = 0; //inicializa uma variavel int para percorrer os vetores reais e imaginarios sem travar a atualização de frames.
        if(!sweep){ //se sweep ainda não tiver sido realizado.
          frequencySweepEasy(); //realiza um sweep(utilizar o Serial Monitor para acompanhar os valores e checar se tudo ocorreu corretamente).
          sweep = true;
        }
        else{ //se o sweep ja tiver sido realizado.
          display.setCursor(0,barSize); //seta o cursor na margem esquerda superior da tela abaixo da barrar de informações.
          display.setTextColor(WHITE);  //setta a cor do texto como branca.
          static double cfreq = (START_FREQ*0.95); //inicializa a variavel static cfreq a partir da frequencia default.
          Serial.print(i);
          if(i < NUM_INCR+1) { //se a variavel i for menor que o numero de incrementos
            if(i==0){
              cfreq = (START_FREQ*0.95);
            }
            display.print(" ");
            display.print(cfreq/1000);  //imprime a variavel cfreq.
            display.println("KHz.");
            display.print(" R=");  
            display.println(real[i]); //imprime a posição i do vetor real.
            //display.setCursor(2,barSize+8); //setta o cursor na linha abaixo.
            display.print(" I=");
            display.print(imag[i]);
            if(yes){  //se YES tiver valor true.
              i++;  //incrementa o i
              cfreq += FREQ_INCR; //incrementa a frequencia
              yes = false;  //reseta YES
            }
            
          }
        }
        if(no){
              sweep = false;
              i = 0;
              no = false;
              screen = 0;
            }
            */
        break;
        }
        
      case 2:  //criar tela de configuração.
      {
        static int choice = 0;
        switch(choice)
        {
          case 0:
          {
            display.setCursor(2,barSize);
            display.fillRect(2,barSize, display.width()-5, 8, WHITE);
            display.setTextColor(BLACK);
            display.println("1.Relogio.");
            display.setTextColor(WHITE);
            display.println("2.Eletrodos.");
            if(down)
            {
              down = false;
              choice++;
            }
            if(yes)
            {
              yes = false;
              screen = 5;
            }
            break;
          }
          case 1:
          {
            display.setCursor(2,barSize);
            display.fillRect(2,barSize+8, display.width()-5, 8, WHITE);
            display.setTextColor(WHITE);
            display.println("1.Relogio.");
            display.setTextColor(BLACK);
            display.println("2.Eletrodos.");
            if(up)
            {
              up = false;
              choice--;
            }
            if(yes)
            {
              yes = false;
              screen = 6;
            }
            if(no)
            {
              no = false;
              choice = 0;
              screen = 0;
            }
            break;
          }
        }
        break;
      }
        /*display.setCursor( 2, barSize);
        display.setTextColor(WHITE);
        display.print(menu0[1]);
        break;*/

      case 3:
        {
          static int menu3 = 0;
          switch(menu3)
          {
            case 0:
            {
              display.setCursor(0, barSize);
              display.setTextSize(1);
              display.setTextColor(BLACK);
              display.fillRect(0, barSize, display.width()-5, 8, WHITE);
              display.println("1- Ativar");
              display.setTextColor(WHITE);
              display.println("2- Desativar");

              if(down)
              {
                down=false;
                menu3=1;
              }
              if(yes)
              {
                yes = false;
                menu3=2;
              }
              if(no)
              {
                no = false;
                menu3=0;
                screen = 0;
              }
              break;
            }
            case 1:
            {
              display.setCursor(0, barSize);
              display.setTextSize(1);
              display.setTextColor(WHITE);
              display.fillRect(0, barSize+8, display.width()-5, 8, WHITE);
              display.println("1- Ativar");
              display.setTextColor(BLACK);
              display.println("2- Desativar");
              if(up)
              {
                up=false;
                menu3=0;
              }
              if(yes)
              {
                yes = false;
                menu3=3;
              }
              if(no)
              {
                no = false;
                menu3=0;
                screen = 0;
              }
              break;
            }
            case 2:
            {
              if(BLE)
              {
                display.setCursor(display.width()/2-35, barSize);  
                display.setTextSize(1);
                display.setTextColor(WHITE);
                display.println("Bluetooth esta");
                display.setCursor(display.width()/2-17, barSize+8);
                display.println("ativado");
  
                if(yes)
                {
                  yes = false;
                  menu3=0;
                }
                if(no)
                {
                  no = false;
                  menu3=0;
                }
              }
              else
              {
                static int pause=100, k=0;
                display.setCursor(display.width()/2-50, barSize);  
                display.setTextSize(1);
                display.setTextColor(WHITE);
                display.println("Ativando Bluetooth");
                if(k<pause)
                {
                  k++;
                }
                else
                {
                  BLE = true;
                  display.setCursor(display.width()/2-17, barSize+8);
                  display.println("Ativado");
                }
              }
              if(no)
              {
                no=false;
                menu3=0;
              }
              break;
            }
            case 3:
            {
                display.setCursor(display.width()/2-60, barSize);  
                display.setTextSize(1);
                display.setTextColor(WHITE);
                BLE = false;
                display.println("Bluetooth Desativado");
              if(no)
              {
                no=false;
                menu3=1;
              }
              break;
            }
          }
          break;
        }

      case 5:
        display.setCursor( ( (display.width()/2) - ( ( ( 5*5*2 )+4 )/2) ), ( ( ( display.height() + barSize )/2) - ( ( ( 7*2 )+ 1 )/2 ) ) );
        display.setTextSize(2);
        display.setTextColor(WHITE);

        clockAdjust();  //chamar função de ajustar o relogio que desenha o valor do relogio a partir do valor que receber quando entrar na tela, altera dependendo dos valores recebidos pelos botões e ajusta o valor do relogio baseado nesse valor.
        
        //display.print(temptime);
        break;

      case 4:
        {
          
          static double r1=random(100),r2=random(100);
          display.setCursor(0, barSize+4);
          
          display.setTextSize(1);
          display.setTextColor(WHITE);
          display.print("1- ");
          display.println(r1);
          display.print("2- ");
          display.println(r2);
          if(no)
          {
            r1=random(100);
            r2=random(100);
            no = false;
            screen = 0;
          }
          break;
        }

      case 6:
      {
        display.setTextSize(1);
        display.setTextColor(WHITE);
        display.setCursor(display.width()/2-50, barSize);
        display.println("Checando eletrodos");
        static int wait=100, j=0;
        if(j<wait)
        {
          j++;
        }
        else
        {
          display.println("Eletrodo 1 OK");
            j++;
        }
        if(j>(2*wait))
        {
          //display.println("Eletrodo 1 OK");
          display.println("Eletrodo 2 OK");
        }

        if(no)
        {
          no = false;
          j = 0;
          screen = 0;
        }
        break;
      }


  
    /* 
     if(selector == 1) {
      display.fillRect(display.width()/4-1, 3, display.width()/4+2, 9, WHITE);
      display.setCursor(display.width()/4, 4);
      display.setTextColor(BLACK, WHITE);
      display.print("1. Exemplo 1");
  
    }
    else {
      display.setCursor(display.width()/2+4, 4);
      display.println("1.ex1");
    }
    if(selector == 2) {
      display.fillRect(display.width()/4-1, 3+8, display.width()/4+2, 9, WHITE);
      display.setCursor(display.width()/4, 4+8);
      display.setTextColor(BLACK, WHITE);
      display.print("2. Exemplo 2");
    }
    else {
    display.setCursor(display.width()/2+4, 4+8);
    display.println("2.ex2");
    }
    if(selector == 3) {
      display.fillRect(display.width()/4-1, 3+8+8, display.width()/4+2, 9, WHITE);
      display.setCursor(display.width()/4, 4+8+8);
      display.setTextColor(BLACK, WHITE);
      display.print("3. Exemplo 3");
    }
    else {
    display.setCursor(display.width()/2+4, 4+8+8);
    display.println("3.ex3");
    }
    */
  }
}
void frequencySweepEasy() {
    // Create arrays to hold the data
    //int real[NUM_INCR+1], imag[NUM_INCR+1];

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


