const short debounceDelay = 350;
long lastDebounceTime = 0;

bool lastState[2] = {false};
bool longPress[2] = {false};

int readXbee(){
  unsigned long timeout = 1000;        //--Timeout = 1s
  unsigned long start = millis();

  while (millis() - start < timeout){   //--Wait until tiemout for arduino's reply
    if (Serial3.available()) {          //--Make sure the frame is complete
      delay(100);                       //--Allows all serial sent to be received together
      if (Serial3.read() == 0x7E) {      //--7E is the start byte, indicates beginning of data frame
        for (int i = 0; i < 19; i++) {
          byte discard = Serial3.read(); //--Unecessary data sent from the X-bee
        }
        int reading = Serial3.read();
        //Serial.println(reading);
        return reading;
      }
    }
  }
}

void updateScore(int reading, int player) {
  if (reading) {                       //--If button is currently pressed                                              
    if (lastState[player] == false) {  //--for the first time
      lastState[player] = true;        //--indicate button was pressed
      lastDebounceTime = millis();     //--record time when button was pressed.
    }
    //--Determine if the button was held high longer than the debounceDelay
    if ((millis() - lastDebounceTime > debounceDelay) && (longPress[player] == false)) { 
      longPress[player] = true;        //--Change longPress to true to stop repeating acivation                                                          
      if (G.score[player] > 0) { 
        G.score[player]--;              //--Decrease score
        Serial.print(Name[player]);
        Serial.print(G.score[player]); 
        Serial.print("      UPDATE:" + String(player+2));
        if (activeOGame){
          Serial2.println("UPDATE:" + String(player+2));
        }
        while (!readNodeReply(String(player+2)));
        updateDigits(player);
      }
    }
  }
  else {                               //--If button is not pressed anymore
                                       //--but it was pressed before and it was not a long press
    if (lastState[player] == true && longPress[player] == false) {
      G.score[player]++;                //--Increase score
      Serial.print(Name[player]);
      Serial.print(G.score[player]); 
      Serial.print("      UPDATE:" + String(player));
      if (activeOGame){
        Serial2.println("UPDATE:" + String(player));
      }
      while (!readNodeReply(String(player)));
      updateDigits(player);
    }
    longPress[player] = false;         
    lastState[player] = false;
  }
}

