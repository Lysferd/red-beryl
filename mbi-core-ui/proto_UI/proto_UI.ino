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


#include <AD/AD5933.h> //incluir a library da AD.
#define START_FREQ  (50000) // frequencia inicial padrão.
#define FREQ_INCR   (1000) // incremento de frequencia padrão.
#define NUM_INCR    (10)  // numero padrão de incrementos.
#define REF_RESIST  (10000) // valor de referencia de resistor.
double gain[NUM_INCR+1];  // vetor double para conter o valor de ganho.
int phase[NUM_INCR+1];  // vetor int para conter o valor de fase.


#define OLED_RESET 4
Adafruit_SSD1306 display(OLED_RESET);
DS3231 time;

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

    //fazer o setup inicial da AD e avisar de algo falhar PS:POR ALGUMA RAZÃO TIVER PROBLEMAS COM O RESET, SE CONTINUAR A TER PROBLEMAS, COMENTAR POR ENQUANTO PARA
    //DEPOIS VER SE ALGO ESTA ERRADO NA BIBLIOTECA.
  if (!(AD5933::reset() &&  //resetar
        AD5933::setInternalClock(true) && //usar clock interno
        AD5933::setStartFrequency(START_FREQ) &&  //frequencia inicial
        AD5933::setIncrementFrequency(FREQ_INCR) && //incremento de frequencia
        AD5933::setNumberIncrements(NUM_INCR) &&  //numero de incrementos
        AD5933::setPGAGain(PGA_GAIN_X1))) //ganho PGA
        {
            Serial.println("FAILED in initialization!");
            while (true) ;
        }
        //calibrar.
    if (AD5933::calibrate(gain, phase, REF_RESIST, NUM_INCR+1))
    {
      Serial.println("Calibrated!");
    }
    else
    {
      Serial.println("Calibration failed...");
    }

  display.begin(SSD1306_SWITCHCAPVCC, 0x3C); // inicializando o OLED.
  Serial.println("Wire");
  
  Serial.println("Done");

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
  static int track = 0;
  static String adtime = "00:00";
  static int tempH, tempM, tempD, tempMn, tempY;
  if( doing == false )
  {
    //adtime = temptime;
    tempH = time.getHour( h12, PM );
    tempM = time.getMinute();
    tempD = time.getDate();
    tempMn = time.getMonth(century);
    tempY = time.getYear();
    
    //time.getTime(tempY, tempMn, tempD, int d, tempH, tempM, int s);
    doing = true;
  }

  switch(track)
  {
    case 0: //minuto
    {
      if(up)
      {
        up=false;
      }
      if(down)
      {
        down=false;
      }
      if(yes)
      {
        yes=false;
      }
      if(no)
      {
        no=false;
      }

      break;
    }
    
    case 1: //hora
    {
      
      if(up)
      {
        up=false;
      }
      if(down)
      {
        down=false;
      }
      if(yes)
      {
        yes=false;
      }
      if(no)
      {
        no=false;
      }

      break;
    }
    case 2: //dia
    {
      
      if(up)
      {
        up=false;
      }
      if(down)
      {
        down=false;
      }
      if(yes)
      {
        yes=false;
      }
      if(no)
      {
        no=false;
      }

      break;
    }
    case 3: //mes
    {
      
      if(up)
      {
        up=false;
      }
      if(down)
      {
        down=false;
      }
      if(yes)
      {
        yes=false;
      }
      if(no)
      {
        no=false;
      }

      break;
    }
    case 4: //ano
    {
      
      if(up)
      {
        up=false;
      }
      if(down)
      {
        down=false;
      }
      if(yes)
      {
        yes=false;
      }
      if(no)
      {
        no=false;
      }

      break;
    }
  }

  
  if(up)
  {
    if(track == 1)
    {
      if(tempM<59)
      {
        tempM++;
      }
      else
      {
        tempM = 0;
      }
    }
    else if(track == 0)
    {
      if(tempH<23)
      {
        tempH++;
      }
      else
      {
        tempH = 0;
      }
    }
    else if(track==2)
    {
      switch(tempMn)
      {
        case 2:
        {
          if(tempD<28)
          {
            tempD++;
          }
          else
          {
            tempD=1;
          }
          break;
        }
        case 4:
        {
          if(tempD<30)
          {
            tempD++;
          }
          else
          {
            tempD=1;
          }
          break;
        }
        case 6:
        {
          if(tempD<30)
          {
            tempD++;
          }
          else
          {
            tempD=1;
          }
          break;
        }
        case 9:
        {
          if(tempD<30)
          {
            tempD++;
          }
          else
          {
            tempD=1;
          }
          break;
        }
        case 11:
        {
          if(tempD<30)
          {
            tempD++;
          }
          else
          {
            tempD=1;
          }
          break;
        }
        default:
        {
          if(tempD<31)
          {
            tempD++;
          }
          else
          {
            tempD=1;
          }
          break;
        }
      }
    }
    up = false;
  }
  if(down)
  {
    if(track == 1)
    {
      if(tempM>0)
      {
        tempM--;
      }
      else
      {
        tempM = 59;
      }
    }
    else if(track == 0)
    {
      if(tempH>0)
      {
        tempH--;
      }
      else
      {
        tempH = 23;
      }
    }
    down = false;
  }
  if(yes)
  {
    if(track==1)
    {
      time.setMinute(tempM);
      //no = true;
    }
    else if(track==0);
    {
      time.setHour(tempH);
    }
    track++;
    yes = false;
  }
  if(no)
  {
    if(track==1)
    {
      track--;
    }
    else if(track==0)
    {
      screen = 2;
    }
    no = false;
  }
  adtime = tempH; adtime += ":" ; adtime += tempM;

  if(track==1)
  {
    display.setCursor(display.width()/2-24, barSize);
    if(tempH>9)
    {
      
    }
    else
    {
      display.print("0");
    }
    display.print(tempH);
    display.print(":");
    if(blinker)
    {
      //do not print;
      blinker = false;;
    }
    else
    {
      if(tempM>9)
      {
        
      }
      else
      {
        display.print("0");
      }
      display.print(tempM);
      blinker = true;;
    }
  }
  else if(track==0)
  {
    if(blinker)
    {
      //do not print;
      display.setCursor(display.width()/2, barSize);
      blinker = false;
    }
    else
    {
      static int count = 0;
      if(count >1)
      {
        if(blinker == true)
        {
          blinker = false;
        }
        else blinker = true;
        count = 0;
      }
      else count++;
      display.setCursor((display.width()/2)-24, barSize);
      if(tempH>9)
      {
        
      }
      else
      {
        display.print("0");
      }
      display.print(tempH);
      //blinker = true;
    }
    display.print(":");
    if(tempM>9)
    {
      
    }
    else
    {
      display.print("0");
    }
    display.print(tempM);
  }
  else if(track==2)
  {
    //display.setCursor((8*   //continuar isso
  }
  //display.print(adtime);
}


void menu()
{
  static char* menubase[] = { "1.Calibrar", "2.Configurar", "3.Bluetooth","4.Medidas" };
  static char* menu0[] = { "1.Calibrar", "2.Configurar", "3.Bluetooth", "4.Medidas" };
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

      case 1:
      {
        /*display.setCursor( 2, barSize);
        display.setTextColor(WHITE);
        display.print(menu0[0]);
        */
        
          static int dot = 1; // contando o numero de pontos depois da palavra calibrando para dar o efeito.
          static int bar = 0; // contando o tamanho da barra de progresso.
          static bool complete = false; // define se a barra de progresso esta concluida.
          
          static unsigned long oldtime; // inicializa a variavel que se lembra do ultimo tempo para apenas avançar de .5 em .5 segundos(meio segundo)
          unsigned long thistime = millis();
          
          display.setCursor( (display.width()/2)-(11*6/2), barSize+8);
          display.setTextSize(1);
          display.setTextColor(WHITE);
          if(bar == 0 && (thistime-oldtime)>1000)
          {
            oldtime=millis();
          }
          if(complete)
          {
            display.print("Concluido.");
            if((thistime-oldtime)>3000)
            {
              yes=false;
              up=false;
              down=false;
              no=true;
            }
          }
          else {
            display.print("Calibrando");
            int testtime = thistime-oldtime;
            display.fillRect((display.width()/2-25), (barSize+17), bar/2, 7, WHITE);
            if(testtime>500)
            {
              dot++;
              oldtime = millis();
              if(bar>100)
              {
                complete = true;
                delay(300);
              }
              //bar++;
            }
            bar++;
            if(dot>3)
            {
              dot = 0;
            }
            else
            {
              for(int i=0;i<dot;i++)
              {
                display.print(".");
              }
            }
            
          }

          if(no)
          {
            dot=0;
            bar=0;
            complete=false;
            no=false;
            screen=0;
          }
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


