//Primeira iteração de um codigo de UI para o protótipo usando uma placa arduino nano e uma tela OLED azul 128x32 i2c

//#include <SPI.h>
//#include <Wire.h>
//#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define OLED_RESET 4
Adafruit_SSD1306 display(OLED_RESET);

#if (SSD1306_LCDHEIGHT != 32)
#error("Height incorrect, please fix Adafruit_SSD1306.h!");
#endif

//int sec=0, min=0, hr=0;
unsigned long time, previousTime=0,sec=0, min=0, hr=0;
const int buttonLeft = 9;
const int buttonRight = 10;
const int buttonConfirm = 11;
const int buttonCancel = 12;
int selector = 1;
int screen = 0;
//Inicialização.

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  display.setRotation(2); // mudando a rotação da tela

  display.begin(SSD1306_SWITCHCAPVCC, 0x3C); // inicializando o OLED.


  pinMode(buttonLeft, INPUT);
  pinMode(buttonRight, INPUT);
  pinMode(buttonConfirm, INPUT);
  pinMode(buttonCancel, INPUT);
  
  //display.display();
  //delay(1000);
  //Simbolo da Adafruit.
  Serial.println(display.width());
  Serial.println(display.height());
  display.clearDisplay();
  //Limpando tela.

  display.setCursor(15,7);
  display.setTextColor(WHITE);
  display.setTextSize(2);
  display.print("Red Beryl");
  display.setTextSize(1);
  display.display();
  delay(1500);
  display.clearDisplay();
  delay(100);
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
  selector = 1;
}

void loop() {
  // put your main code here, to run repeatedly:

  display.clearDisplay();
  clock();
  checkPins();
  menu();
  display.drawRect(0,0, display.width(), display.height(), WHITE);

  display.display();
  
  delay(1);  

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
      if(selector > 1 ) {
        selector--;
      }
      else {
        selector = 3;
      }
    }
    if(digitalRead(buttonRight) && temp != digitalRead(buttonRight)){
      temp = digitalRead(buttonRight);
      Serial.print("Right:");Serial.println(digitalRead(buttonRight));
      if(selector < 3 ) {
        selector++;
      }
      else {
        selector = 1;
      }
    }
    if(digitalRead(buttonConfirm) && temp != digitalRead(buttonConfirm)){
      temp = digitalRead(buttonConfirm);
      Serial.print("Confirm:");Serial.println(digitalRead(buttonConfirm));
      switch(screen) {
        case 0:
          screen = selector;
          break;
      }
    }
    if(digitalRead(buttonCancel) && temp != digitalRead(buttonCancel)){
      temp = digitalRead(buttonCancel);
      Serial.print("Cancel:");Serial.println(digitalRead(buttonCancel));
      switch(screen) {
        case 1:
          screen = 0;
          break;

        case 2:
          screen = 0;
          break;

        case 3:
          screen = 0;
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
  time = millis();
  if(time-previousTime >= 60000)
  {
    previousTime = time;
    min++;
  }
  unsigned long tempTime = time-previousTime;
  sec = tempTime/1000;
  if(min>= 60)
  {
    min = 0;
    hr++;
  }
  
  display.setCursor(2,display.height()-9);
  display.setTextColor(WHITE);
  display.print(hr);
  display.print(":");
  display.print(min);
  display.print(":");
  display.print(sec);
}
void menu()
{
  static char* menubase[] = { "1.ex1", "2.ex2", "3.ex3" };
  static char* menu0[] = { "1.Exemplo 1: tentando criar a funcao de scroll", "2.Exemplo 2", "3.Exemplo 3" };
  static unsigned int size1 = 46*7;//tamanho de menu0[0]: 46 caracteres * 7 pixels(5 de cada caracter e o espaço entre eles)
  static unsigned int scroller = 1, scrolling;
  static boolean scroll = true;
  display.setTextWrap(false);    
       
  switch(screen) {
    case 0:
      display.fillRect(display.width()/2, 0, display.width()/2-2, display.height(), WHITE);
      display.drawRect(display.width()/2+1, 1, display.width(), display.height()-2, BLACK);
      display.setTextColor(BLACK);
      
  
      switch(selector) {
        case 1:
 
          display.fillRect(display.width()/4-1, 3, display.width()/3, 9, WHITE);
          display.setCursor(display.width()/4, 4);

          if(scroll==true) {
            scrolling = 1;
            display.setCursor(display.width()*2/3-scroller, 4);
            display.setTextColor(BLACK);
            display.print(menu0[0]);
            scroller+=1;
            if (display.width()/4+size1-scroller < display.width()/3) {
              scroll = false;
              scroller = 1;
              delay(250);
            }
          }
          else {
            display.setCursor(display.width()/4, 4);
            display.setTextColor(BLACK);
            display.print(menu0[0]);
          }
          /*
          display.setTextColor(BLACK);
          display.print(menu0[0]);
          */
  
          display.setCursor(display.width()/2+4, 4+8);
          display.println(menubase[1]);
          display.setCursor(display.width()/2+4, 4+8+8);
          display.println(menubase[2]);
          break;
  
        case 2:
          display.fillRect(display.width()/4-1, 3+8, display.width()/4+2, 9, WHITE);
          display.setCursor(display.width()/4, 4+8);

          if(scrolling != selector) {
              scroll = true;
              scroller = 1;
          }
          
          display.setTextColor(BLACK, WHITE);
          display.print(menu0[1]);
  
          display.setCursor(display.width()/2+4, 4);
          display.println(menubase[0]);
          display.setCursor(display.width()/2+4, 4+8+8);
          display.println(menubase[2]);
          break;
  
        case 3:
          display.fillRect(display.width()/4-1, 3+8+8, display.width()/4+2, 9, WHITE);
          display.setCursor(display.width()/4, 4+8+8);
          display.setTextColor(BLACK, WHITE);
          display.print(menu0[2]);     
          
          display.setCursor(display.width()/2+4, 4);
          display.println(menubase[0]);
          display.setCursor(display.width()/2+4, 4+8);
          display.println(menubase[1]);
          break;
          
        
        }
        break;

      case 1:
        display.setCursor( 2, 2);
        display.setTextColor(WHITE);
        display.print(menu0[0]);
        break;

      case 2:
        display.setCursor( 2, 2);
        display.setTextColor(WHITE);
        display.print(menu0[1]);
        break;

      case 3:
        display.setCursor( 2, 2);
        display.setTextColor(WHITE);
        display.print(menu0[2]);
        break;
        


  
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

