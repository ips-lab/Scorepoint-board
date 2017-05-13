void controlGame() {
  if (activeOGame) {
    Serial2.println("UPDATE:6");
    Serial.println("ONLINE GAME CANCELED");
    gameOver();
  }
  else if (activeOffGame){
    Serial.println("OFFLINE GAME CANCELLED");
    gameOver();
  }
  else {
    G.setP1 = 0;
    G.setP2 = 0;
    G.matches = 1;
    G.points = 11;
    G.score[0] = 0;
    G.score[1] = 0;
    G.nameP1 = "Player1";
    G.nameP2 = "Player2";
    activeOffGame = true;
    activeOGame = false;
    Serial.println("NEW OFFLINE GAME");
  }
}

void gameOver() {
  LedMxPrintCenter(&g_LmxDev1, "Game");
  LedMxPrintLeft(&g_LmxDev2, "Over");
  delay(1000);

  digitalWrite(oEnablePin[0], HIGH);          // -- Prepare digits
  digitalWrite(oEnablePin[1], HIGH);          // -- Prepare digits
  digitalWrite(oEnablePin[2], HIGH);          // -- Prepare digits

  activeOGame = false;
  activeOffGame = false;
  activeOffGame_Init = false;
  startM = millis();
}

void updateDigits(int who) {
  int d1, d2;

  //Serial.print("Update digits for... ");
  //Serial.println(String(who + 1));

  if (who == P1 || who == P2) {
    d1 = G.score[who] / 10;
    d2 = G.score[who] % 10;
    //Serial.println("ScoreP" + String(who+1) + ": " + String(G.score[who]));
    //Serial.println("ScoreP" + String(who+1) + ": " + String(d1) + String(d2));
  }
  else {
    d1 = G.setP1;
    d2 = G.setP2;
    //Serial.println("Sets: " + String(G.setP1) + "vs " +  String(G.setP2));
    //Serial.println("Sets: " + String(d1) + "vs " +  String(d2));
  }

  digitalWrite(latchPin[who], LOW);
  shiftOut(sDataPin[who], clkPin[who], MSBFIRST, digit1[d1]);
  shiftOut(sDataPin[who], clkPin[who], MSBFIRST, (digit2[d2] >> 8));
  digitalWrite(latchPin[who], HIGH);

  //Serial.println("Updated digits");
}

void determineWinner() {
  if ((G.score[P1] >= G.points) && (G.score[P2] <= (G.score[P1] - 2))) {
    G.setP1++;
    updateDigits(sets);
    if (activeOGame){
      Serial2.println("UPDATE:4");
    }
    LedMxPrintCenter(&g_LmxDev1, "Winner");
    LedMxPrintLeft(&g_LmxDev2, "Loser");
    delay(1000);
    //Serial.println();
    //Serial.println(G.nameP1 + " wins");
    G.score[P1] = 0;
    G.score[P2] = 0;
    updateDigits(P1);
    updateDigits(P2);
  }
  else if ((G.score[P2] >= G.points) && (G.score[P1] <= (G.score[P2] - 2))) {
    G.setP2++;
    updateDigits(sets);
    if (activeOGame){
      Serial2.println("UPDATE:5");
    }
    LedMxPrintCenter(&g_LmxDev1, "Loser");
    LedMxPrintLeft(&g_LmxDev2, "Winner");
    delay(1000);
    //Serial.println();
    //Serial.println(G.nameP2 + " wins");
    G.score[P1] = 0;
    G.score[P2] = 0;
    updateDigits(P1);
    updateDigits(P2);
  }
}


