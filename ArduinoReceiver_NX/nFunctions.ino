bool readNodeReply(String command){
  if(Serial2.available()){
    delay(100); // allows all serial sent to be received together
    nodeReply = Serial2.readStringUntil('\r');
    Serial.println(nodeReply); 
    //Serial.println("command:" + command );
    //Serial.println("commandIndexOf: "+String(nodeReply.indexOf(command)));
  }

  if (nodeReply.indexOf(command) >= 0){
    return true;
  }
  return false;
}

void updateGameData(){  
  nodeReply.remove(0,5);  //--Remove INFO:  
 
  G.nameP1 = nodeReply.substring(0, nodeReply.indexOf(",")); //First name
  //Serial.println(n);

  nodeReply.remove(0, nodeReply.indexOf(",")+1);

  G.nameP2 = nodeReply.substring(0, nodeReply.indexOf(","));   //Second name
  //Serial.println(n);
  
  nodeReply.remove(0, nodeReply.indexOf(",")+1);
  
  for (int k = 0; k < 6; k++){
    GameInfo[k] = nodeReply.substring(0, nodeReply.indexOf(",")).toInt();
    //Serial.println(GameInfo[k]);
    nodeReply.remove(0, nodeReply.indexOf(",")+1);
  }

  //Serial.print("NEW GAME STARTED....");
  //Serial.print(G.matches);
  //Serial.println(" MATCHES");
  //Serial.println();
  //Serial.print(G.nameP1 + ": " + String(G.score[P1]) + "    " + String(G.setP1));
  //Serial.print("     vs    ");
  //Serial.println(G.nameP2 + ": " +  String(G.score[P2]) + "    " + String(G.setP1));
  //Serial.println(G.setP1);
  //Serial.println(G.setP2);
}

