#include "ardledmxio.h"

//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
//  --  --  --  --  -- VARIABLE DECLARATION --  --  --  --  --
//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --

//  --  --  --  --  --  --  ARDUINO --  --  --  --  --  --  --
char welcome[] = "ScorePoint!";

const int P1 = 0;
const int P2 = 1;
const int sets = 2;

const byte boardBtn = 20;          

struct Game {
  String nameP1;
  String nameP2;
  int score[2];
  int setP1;
  int setP2;
  int points;
  int matches;
};

char *nameP1;
char *nameP2;

Game G;
int *GameInfo = &(G.score[P1]);  //--Pointer to structure G, allows acces like array
String *Name = &(G.nameP1);

bool activeOGame = false;
bool activeOffGame = false;
bool activeOffGame_Init = false;
//  --  --  --  --  --  --  DIGITS  --  --  --  --  --  --  --
//MSB 0 UPTO 9
int digit1[10] = {   B11111100, //0
                     B00001100, //1
                     B10110110, //2
                     B10011110, //3
                     B01001110, //4
                     B11011010, //5
                     B11111010, //6
                     B10001100, //7
                     B11111110, //8
                     B11011110  //9
                 };
int digit2[10];

//--LED Driver (P1, P2, Sets)
const int sDataPin[3] = {22, 26, 30};
const int clkPin[3] = {23, 27, 31};
const int latchPin[3] = {24, 28, 32};
const int oEnablePin[3] = {25, 29, 33};


//  --  --  --  --  --  -- MATRICES --  --  --  --  --  --  --
/* The LEDMXIOCFG is the hardware configuration of I/O interface to the display. 
    Arduino Digital I/O pin mapping for the LMXSHIELD */
unsigned long timeoutM = 20000;        //--Timeout = 1s
unsigned long startM = 20000;

LEDMXIOCFG g_IOCfg = {
  LMXSHIELD_WR,                                         //--WR pin 
  LMXSHIELD_RD,                                         //--RD pin
  LMXSHIELD_DATA,                                       //--Data pin
  LMXSHIELD_EN,                                         //--Enable pin
  {LMXSHIELD_AD0, LMXSHIELD_AD1, LMXSHIELD_AD2, -1,},  //--The LMXSHIELD uses 3 digital pins to address 8 Displays
  3,                                                    //--Number of CS pins 
  LMXSHIELD_CSTYPE                                      //--Type of addressing for access to display
};

/* The LEDMXCFG is the LED matrix display arrangement configuration.
    Each of this data structure define the arrangement of displays boards for a single line.  
    For multiple lines, many of this data structure can be defined.*/
LEDMXCFG g_Cfg1 = {
  &g_IOCfg,                                             //--The I/O interface configuration above LEDMXIOCFG
  1,                                                    //--Number of display board connected, max 8 boards 
  {4, 5, 6, 7, 0, 1, 2, 3},                             //--display board ordering, 0-1 are on connector P1, 4-7 are on P2
};

LEDMXCFG g_Cfg2 = {
  &g_IOCfg,                                             //--The I/O interface configuration above LEDMXIOCFG
  1,                                                    //--Number of display board connected, max 8 boards 
  {0, 1, 2, 3, 4, 5, 6, 7},                             //--display board ordering, 0-1 are on connector P1, 4-7 are on P2
};

/*This is the data instance require by all LMX C functions. It is initialized bit LedMxInit. */
LEDMXDEV g_LmxDev1;                                     //--For line 1
LEDMXDEV g_LmxDev2;                                     //--For line 2 

//  --  --  --  --  --  -- NODE-MCU --  --  --  --  --  --  --
String nodeReply;

//  --  --  --  --  --  --  X-BEES  --  --  --  --  --  --  --
const int idP1 = 2;                 //--Xbee-ID for player 1
const int idP2 = 16;                //--Xbee-ID for player 2
int id;

//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
//  --  --  --  --  --  --   FUNCTIONS  --  --  --  --  --  --  
//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
void controlGame();
void gameOver();
void updateDigits(int who);
void determineWinner();
void DispFill(char pat);
void DispScroll(char *pText);
void loadNames();
bool readNodeReply(String command);
void updateGameData();
int readXbee();
void updateScore(int reading, int player);

//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --

void setup() {
  LedMxInit(&g_LmxDev1, &g_Cfg1);
  LedMxInit(&g_LmxDev2, &g_Cfg2);

  for (int i = 0; i < 10; i++) {
    digit2[i] = digit1[i] * 256;
  }

  pinMode(sDataPin[0], OUTPUT);
  pinMode(sDataPin[1], OUTPUT);
  pinMode(sDataPin[2], OUTPUT);
  pinMode(clkPin[0], OUTPUT);
  pinMode(clkPin[1], OUTPUT);
  pinMode(clkPin[2], OUTPUT);
  pinMode(latchPin[0], OUTPUT);
  pinMode(latchPin[1], OUTPUT);
  pinMode(latchPin[2], OUTPUT);
  pinMode(oEnablePin[0], OUTPUT);
  pinMode(oEnablePin[1], OUTPUT);
  pinMode(oEnablePin[2], OUTPUT);

  pinMode(boardBtn, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(boardBtn), controlGame, RISING);
  
  Serial.begin(115200);     //--Arduino
  Serial3.begin(115200);    //--Xbee
  Serial2.begin(115200);    //--Node

  while(!Serial);
  while(!Serial3);
  while(!Serial2);

  digitalWrite(oEnablePin[0], HIGH);          // -- Prepare digits
  digitalWrite(oEnablePin[1], HIGH);          // -- Prepare digits
  digitalWrite(oEnablePin[2], HIGH);          // -- Prepare digits

  delay(500);              //--Necessary for matrices
}

void loop() {
  if (activeOGame || activeOffGame){
    if (activeOffGame && !activeOffGame_Init){
      LedMxPrintRight(&g_LmxDev1, "New");
      LedMxPrintLeft(&g_LmxDev2, "Game");
      delay(500);  
  
      digitalWrite(oEnablePin[0], LOW);          // -- Prepare digits
      digitalWrite(oEnablePin[1], LOW);          // -- Prepare digits
      digitalWrite(oEnablePin[2], LOW);          // -- Prepare digits
      
      Serial.println("Update Game Data");
      Serial.print("INFO: " + G.nameP1 + "," + G.nameP2 + ",");
      Serial.print(G.score[0]);
      Serial.print(",");
      Serial.print(G.score[1]);
      Serial.print(",");
      Serial.print(G.setP1);
      Serial.print(",");
      Serial.print(G.setP2);
      Serial.print(",");
      Serial.print(G.matches);
      activeOffGame_Init = true;
      updateDigits(P1);
      updateDigits(P2);
      updateDigits(sets);
      loadNames();
      delay(500);
    }
    else if (activeOGame){                                      // -- If there is an active online game
      if (readNodeReply("INFO:")) {             // -- If new info received
        LedMxPrintCenter(&g_LmxDev1, "New");
        LedMxPrintLeft(&g_LmxDev2, "Game");
        delay(500);  
    
        digitalWrite(oEnablePin[0], LOW);          // -- Prepare digits
        digitalWrite(oEnablePin[1], LOW);          // -- Prepare digits
        digitalWrite(oEnablePin[2], LOW);          // -- Prepare digits
        activeOGame = true;
        Serial2.println("OK");
        Serial.println("Update Game Data");
        updateGameData();
        updateDigits(P1);
        updateDigits(P2);
        updateDigits(sets);
        loadNames();
        delay(500);
      }
      else if (nodeReply.indexOf("OVER") >= 0 || nodeReply.indexOf("ERROR") >= 0){ // -- If game cancelled
        //Serial.println("GAME CANCELLED");
        gameOver();   
        activeOGame = false;
        return;
      }
    }

    if ((G.setP1 + G.setP2) < G.matches || (G.setP1 == G.setP2)){
      id = readXbee();
  
      switch (id) {
        case 0:                       //--No buttons pressed
          //Serial.print(".");
          updateScore(0, P1);         //--It is necessary to indicate that the buttons
          updateScore(0, P2);         //--are no longer pressed to know if was a +1 or -1
          break;
        case idP1:
          //Serial.print("Update P1 score");
          updateScore(1, P1);         //--Button from player 1 was pressed
          break;
        case idP2:
          //Serial.print("Update P1 score");
          updateScore(1, P2);         //--Button from player 2 was pressed
          break;
        default: break;
      }
      determineWinner();
    }
  }
  else{                                         // -- If there is not an active online game, FIND ONE! 
    if (readNodeReply("ACTIVE")) {        // -- If nodeSends ACTIVE
      Serial2.println("OK");
      G.setP1 = 0; 
      G.setP2 = 0; 
      G.matches = 5;
      activeOGame = true;                 // -- There is a new game
    }
    else {
      if (millis() - startM > timeoutM){
        Serial.println("Waiting for game");
        DispScroll(welcome);
        delay(2000);
        DispFill(0x55);
        delay(1000);
        DispFill(0xaa);
        delay(1000);
        DispFill(0);
        delay(1000); 
        startM = millis();
      }
    }
  }
}

