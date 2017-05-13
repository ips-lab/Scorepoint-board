#include <ESP8266WiFi.h>
#include <SoftwareSerial.h>

const char* ssid = "IPS-OPERATION";
const char* password = "Wireles$KeY153190";

const char* host = "scorepoint-cm.herokuapp.com";  //--Scorepoint server ip
const int port = 80;              //--Scorepoint server port

WiFiClient client;                  //--Use WiFiClient class to create TCP connections

//--URIs for the requests
String uriInfoGame = "/game";               //--Details of games queue
String uriAddPoint = "/score/addPoint";     //--Add point
String uriSubsPoint = "/score/removePoint"; //--Substract point
String uriSetWinner = "/score/setWinner";   //--Indicate set winner
String uriCancel = "/game/cancelGame";

String jsServerReply;               //--String from server in json format
String arduinoReply;
String postDataP1;
String postDataP2;

const long requestTimer = 15000;    //--NodeMCU will look for new information every 15s
unsigned long timer = millis()+15000; 

bool activeGame = false;            //--Indicates if there is an active game
String activeGameId = "";           

String IDs[12] = {
  "gameTypeId",     //--0
  "setId",          //--1
  "teamLocalName",  //--2
  "teamVisitName",  //--3
  "scoreLocal",     //--4
  "scoreVisit",     //--5
  "teamLocalId",    //--6
  "teamVisitId",    //--7
  "setLocalWon",    //--8
  "setVisitWon",    //--9
  "endDate",        //--10
  "points"          //--11
}; 

struct Game{
  String gameTypeId;
  String setID;
  String nameLocal;
  String nameVisit;  
  String scoreLocal;
  String scoreVisit;
  String IDLocal;
  String IDVisit;
  String setLocal;
  String setVisit; 
  String endGame; 
  String points;
};

Game G;
String *GameInfo = &(G.gameTypeId);  //--Pointer to structure G, allows acces like array

//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  FUNCTIONS
//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --

void getRequest(String Uri){                    //--Sends a GET-Request to server
  //Serial.println("Requesting URI: " + String(host) + Uri);
  client.print(String("GET ") + Uri + " HTTP/1.1\r\n");
  client.print(String("Host: ") + host + "\r\n");
  client.println("Connection: closed\r\n\r\n");
  delay(500);
}

void postRequest(String Uri, String postData){  //--Sends a POST-Request to server
  //Serial.print("Requesting URI: " + Uri);
  client.println("POST " + Uri + " HTTP/1.1"); 
  client.println(String("Host: ") + host);  
  client.println("User-Agent: Node/1.0");
  client.println("Content-Type:application/json; charset=utf-8"); 
  client.println("Connection: close"); 
  client.print("Content-Length: "); 
  client.println(postData.length()); 
  client.println(); 
  client.println(postData); 
  delay(500);
}

void readServerReply(){                         //--Read the server's reply                                
  while(client.available()){
    jsServerReply = client.readStringUntil('\r');
    //Serial.print(jsServerReply);
  }  
}

String getValue(String id){                     //--Returns de value of an id in a json-format string
  String s = jsServerReply;     //--Copy the string to s
  
  int idLen = s.length();       //--Find length of the string

  if (idLen == 0){ 
    return String("");          //--If the string is empty, return NULL
  }

  int idIndex = s.indexOf(id);  //--Find the position where the id starts

  if (idIndex == -1){
    return String("");          //--If the string doesn't contain the id, return NULL 
  }
  else{
    s.remove(0,idIndex);        //--Remove the first part of the string (is not needed)
    
    int dataStart = s.indexOf(':') + 1;         //--Data starts after :
    int dataEnd = s.indexOf(',');               //--Data ends before ,

    if (dataEnd == -1){
      dataEnd = s.indexOf('}');  //--Data might also end before }
    }

    s = s.substring(dataStart,dataEnd);         //--Substract only the data from the string

    jsServerReply.remove(idIndex-1, dataEnd+2); //--From the original string remove the field (id and its value)

    //Serial.println(s);
    //Serial.println(String(s.indexOf("null")));
    
    if (s.indexOf("null") != -1){
      //Serial.print("null = ");
      s = s.substring(0,s.length()-1);
      //Serial.println(s);
    }
    
    if(s.indexOf('"') == -1) 
      return s;                                 //--Return the content
    else                                      
      return s.substring(1,s.length()-1);       //--If the content is between "", eliminate them
  }
}

bool readArduinoReply(String command){          //--Determine if Arduino's reply is what expected
  unsigned long timeout = 1500;                 //--Timeout = 1.2s
  unsigned long start = millis();

  while (millis() - start < timeout){           //--Wait until tiemout for arduino's reply
    if (Serial.available()){
      delay(100);                               //--Allows all serial sent to be received together
      arduinoReply = Serial.readStringUntil('\r'); 
      //Serial.println(arduinoReply);

      if (arduinoReply.indexOf(command) != -1){
        //Serial.println(arduinoReply);
        return true;
      }
    }
  }

  return false; 
}

bool getNewInfo(String activeGameId){           //--Determines if game information was updated by the app
  bool newInfo = false;
  String data;

  if (millis()-timer < requestTimer){           //--Update data every 15 seconds
    return false;
  }

  if (client.connect(host, port)){                         
    getRequest(uriInfoGame + "/" + activeGameId);
    delay(100);
    readServerReply();
    //Serial.println(jsServerReply);

    for (int k = 0; k < 12; k++){
      data = getValue(IDs[k]);                  //--Get the values of the needed IDs
      //Serial.print(data + "     ");
      //Serial.println(GameInfo[k]);
      int val = data.compareTo(GameInfo[k]);
      
      if (val != 0){     //--If there is new information
        //Serial.println(val);
        //Serial.println("new info found" + String(k));
        //Serial.println(data);
        //Serial.println(GameInfo[k]);
        newInfo = true;
        GameInfo[k] = data;                     //--Update it
      }
    }
  }

  return newInfo;
}

void updateInfo(String Uri, String postData){   //--Updates info to server (add/remove point, setWinner)
  if (client.connect(host, port)){
    postRequest(Uri, postData);
    delay(100);
    //readServerReply();
    //Serial.print(jsServerReply);
  }
  else{
    Serial.println("ERROR");
    activeGame = false;
  }
}

void updatePost(){
  postDataP1 =                       //--Json for the add/substract P1 POST-Request
              "{\"gameId\":\"" + activeGameId + 
              "\",\"setId\":\"" + G.setID + 
              "\",\"visit\":\"0\"}";

  postDataP2 =                       //--Json for the add/substract P2 POST-Request
            "{\"gameId\":\"" + activeGameId + 
            "\",\"setId\":\"" + G.setID + 
            "\",\"visit\":\"1\"}";
}

//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  
//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --

void setup() {
  Serial.begin(115200);
  while(!Serial);
 
  //Serial.print("Connecting to " + String(ssid));
  WiFi.begin(ssid, password);                   //--We start by connecting to a WiFi network
  
  while (WiFi.status() != WL_CONNECTED) { 
    delay(500);
    //Serial.print(".");
  }

  Serial.println();
  //Serial.println("WiFi connected");            
  //Serial.println("IP address: " + WiFi.localIP());

  for (int k = 0; k < 12; k++){                   
    GameInfo[k] = "";                             //--Initializes structure with NULLs
  }
}
 
void loop() {
  if (!activeGame){                               //--If there isn't an active game, search for one
    if (client.connect(host, port)){
      getRequest(uriInfoGame);                    //--Send request to get game's queue
      readServerReply();                          //--Get json string with game's queue
      activeGameId = getValue("gameId");          //--Get the value of gameID

      if(activeGameId.length() > 0){              //--If queue has a new active game
        Serial.println("ACTIVE");                 //--Indicate the Arduino there is an active game
        if (readArduinoReply("OK")){              //--When arduino is ready to receive, send info
          activeGame = true;
        }
      }
      else{                                       //--If queue is empty
        delay(10000);                             //--Wait 10 seconds and check again if there is an active game
      }  
    }
    else{
      Serial.println("Can't connect to SP");
    }
  }
  else{                                           //--If there is an active game TIMER
    if (getNewInfo(activeGameId)){                //--When there is new information from app 
      updatePost();
      
      if (G.endGame.compareTo("null") != 0){
        Serial.println("OVER");
        activeGame = false;
        return;
      }
      
      timer = millis();                           //--Reset timer

      //Serial.println("NEW");                      //--Indicate it to arduino 
      Serial.print("INFO:");
      Serial.print(G.nameLocal + ",");
      Serial.print(G.nameVisit + ",");
      Serial.print(G.scoreLocal + ",");
      Serial.print(G.scoreVisit + ",");
      Serial.print(G.setLocal + ",");
      Serial.print(G.setVisit + ",");
      Serial.print(G.points + ",");
      Serial.println(G.gameTypeId);

      if (!readArduinoReply("OK"))                //--When arduino is ready to receive, send info
        G.endGame = "1";
    }

    if (readArduinoReply("UPDATE")){            //--If arduino has a game update (UPDATE:n)
      int index = arduinoReply.indexOf(":");
      
      arduinoReply.remove(0,index+1);           //--Remove UPDATE:
      String number = arduinoReply.substring(0,1);  //--Get n
      int state = number.toInt();               //--Convert string to int

      Serial.println(state);  
                  
      switch (state){
        case 0: {                               //--Add point to P1
          G.scoreLocal = String(G.scoreLocal.toInt()+1);
          updateInfo(uriAddPoint, postDataP1);
        } break;
        case 1:{                                //--Add point to P2
          G.scoreVisit = String(G.scoreVisit.toInt()+1);
          updateInfo(uriAddPoint, postDataP2);
        } break;
        case 2: {                               //--Substract point from P1
          G.scoreLocal = String(G.scoreLocal.toInt()-1);
          updateInfo(uriSubsPoint, postDataP1);
        } break;
        case 3:{                                //--Substract point from P2
          G.scoreVisit = String(G.scoreVisit.toInt()-1);
          updateInfo(uriSubsPoint, postDataP2);
        } break;
        case 4:{                                //--P1 is the winner of the set
          G.scoreLocal = "0";
          G.scoreVisit = "0";
          G.setLocal = "1";
          String postData = "{\"gameId\":\"" + activeGameId + 
                            "\",\"setId\":\"" + G.setID + 
                            "\",\"winnerTeamId\":\"" + G.IDLocal + "\"}";
          updateInfo(uriSetWinner, postData);
          G.setID = String(G.setID.toInt()+1);
        } break;
        case 5:{                               //--P2 is the winner of the set
          G.scoreLocal = "0";
          G.scoreVisit = "0";
          G.setVisit = "1";
          String postData = "{\"gameId\":\"" + activeGameId + 
                            "\",\"setId\":\"" + G.setID + 
                            "\",\"winnerTeamId\":\"" + G.IDVisit + "\"}";
          updateInfo(uriSetWinner, postData);
          G.setID = String(G.setID.toInt()+1);
        } break;
        case 6:{                                //--Game canceld
          String postData = "{\"gameId\":\"" + activeGameId + "\"}";
          updateInfo(uriCancel, postData);
          activeGame = false;
        } break;
        default: break;
      }
    }
  }
}
