// Nodvendige biblioteker
#include <deprecated.h>
#include <MFRC522.h>
#include <MFRC522Extended.h>
#include <require_cpp11.h>
#include <SPI.h>

// Hver RFID-lesers Slave-Select PIN
#define SS_PIN_1 10
#define SS_PIN_2 4
#define SS_PIN_3 5
// Reset PIN deles av alle lesere
#define RST_PIN 9

// Definerer hvor paa arduinoen hver sensor er koblet til
#define sensor1 A0
#define sensor2 A1
#define sensor3 A2

// Oppretter instanser av hver RFID-leser
MFRC522 leser1(SS_PIN_1, RST_PIN);  
MFRC522 leser2(SS_PIN_2, RST_PIN);   
MFRC522 leser3(SS_PIN_3, RST_PIN);   

// Melding som skal sendes til Serial Monitor
// Denne endres avhengig av om hvilket kort som er paa eller tas av
String spillerPaaKort1 = "ingen,ting";
String spillerPaaKort2 = "ingen,ting";
String spillerPaaKort3 = "ingen,ting";

// Hvert potentiometer sin analoge verdi som printes til Serial Monitor
// Endres kontuinerlig etter hva som leses av potentiometerene
int sensorVerdi1 = 0;
int sensorVerdi2 = 0;
int sensorVerdi3 = 0;

// Ventetid for hver gang det sjekkes om et kort er tatt av leseren
int debounceDelay = 250;
int debouncePot = 5;
// Antall millisekunder siden forrige gang et kort ble avlest 
unsigned long previousTime1 = 0;
unsigned long previousTime2 = 0;
unsigned long previousTime3 = 0;

unsigned long previousPot1 = 0;
unsigned long previousPot2 = 0;
unsigned long previousPot3 = 0;


void setup(){
  // Velge potentiometerene som INPUT
  pinMode(sensor1, INPUT);
  pinMode(sensor2, INPUT);
  pinMode(sensor3, INPUT);

  // Initiere RFID-leserne
  leser1.PCD_Init();  
  leser2.PCD_Init();   
  leser3.PCD_Init();   

  // Initiere Serial kommunikasjon
  Serial.begin(9600);
  // Initiere SPI bus
  SPI.begin();
  delay(1000);
}

void loop() {

  // Setter currentTime til aa holde paa antall millisekunder som er gaatt
  unsigned long currentTime = millis();

  // Kaller paa en funkjson for hver leser med currentTime som argument.
  // Hver funksjon sjekker om et kort er naert. 
  // Om dette er tilfellet printer den koden til kortet og ",Play"
   sjekkLeser1(currentTime);
   sjekkLeser2(currentTime);
   sjekkLeser3(currentTime);

  // Leser av den analoge verdien til hvert potentiometer
  // sensorVerdi1 = analogRead(sensor1);
  // sensorVerdi2 = analogRead(sensor2);
  // sensorVerdi3 = analogRead(sensor3);

  // Printer "pot1,"/"pot2,"/"pot3," i forkant av sensorverdien slik at det blir lett 
  // aa hente ut hvilket potentiometer verdien tilhorer i processing 

   sjekkPot1(currentTime);
   sjekkPot2(currentTime);
   sjekkPot3(currentTime);
}

void sjekkLeser1(unsigned long currentTime){
  
  // Sjekker om det er et kort naert leseren
  // Dersom det ikke er det blir if-setningen true
  if (!leser1.PICC_IsNewCardPresent() && !leser1.PICC_ReadCardSerial()) {
    
    // Sjekker om det det er gaatt lenger enn 500ms siden forrige gang et kort var naert
    if(currentTime - previousTime1 >= debounceDelay){
      
      // Dersom debounce-tiden er passert og intet kort er ved denne leseren
      // printes det kortet som sist ble spilt av, etterfulgt av en stop-kommando
      Serial.println(spillerPaaKort1 + ",Stop,1");
      
      // Derretter endres spillerPaaKort1-variabelen til "ingen,ting"
      spillerPaaKort1 = "ingen,ting";
      
      return;
    }
  } else if(leser1.PICC_ReadCardSerial()){
      // Hvis et kort blir lest av, henter vi ID-en til kortet og putter det i variabelen spillerPaaKort1
      String content= "";
        
      for (byte i = 0; i < leser1.uid.size; i++) {
         content.concat(String(leser1.uid.uidByte[i] < 0x10 ? " 0" : " "));
         content.concat(String(leser1.uid.uidByte[i], HEX));
      }
        
      content.toUpperCase();
      spillerPaaKort1 = content.substring(1);
      previousTime1 = currentTime;

      // Her printer vi ID-en til kortet, etterfulgt av en Play-kommando og et tall for aa
      // identifisere hvilken leser det er snakk om. 
      Serial.println(spillerPaaKort1 + ",Play,0");
  }
}

// Denne gjor akkurat det samme som sjekkLeser1 bare for leser2
void sjekkLeser2(unsigned long currentTime){
  if (!leser2.PICC_IsNewCardPresent() && !leser2.PICC_ReadCardSerial()) {
    if(currentTime - previousTime2 >= debounceDelay){
      Serial.println(spillerPaaKort2 + ",Stop,2");
      spillerPaaKort2 = "ingen,ting";
      return;
    }
  }else if(leser2.PICC_ReadCardSerial()){
     String content= "";  
      for (byte i = 0; i < leser2.uid.size; i++) {
         content.concat(String(leser2.uid.uidByte[i] < 0x10 ? " 0" : " "));
         content.concat(String(leser2.uid.uidByte[i], HEX));
      }
      content.toUpperCase();
      spillerPaaKort2 = content.substring(1);
      previousTime2 = currentTime;
      Serial.println(spillerPaaKort2 + ",Play,1");
  }
}
  
// Denne gjor akkurat det samme som sjekkLeser1 bare for leser3
void sjekkLeser3(unsigned long currentTime){
  if (!leser3.PICC_IsNewCardPresent() && !leser3.PICC_ReadCardSerial()) {
    if(currentTime - previousTime3 >= debounceDelay){
      Serial.println(spillerPaaKort3 + ",Stop,3");
      spillerPaaKort3 = "ingen,ting";
      return;
    }
  }else if(leser3.PICC_ReadCardSerial()){
        String content = "";
        for (byte i = 0; i < leser3.uid.size; i++) {
           content.concat(String(leser3.uid.uidByte[i] < 0x10 ? " 0" : " "));
           content.concat(String(leser3.uid.uidByte[i], HEX));
        }  
        content.toUpperCase();
        spillerPaaKort3 = content.substring(1);
        previousTime3 = currentTime;
        Serial.println(spillerPaaKort3 + ",Play,2");
  }
}

void sjekkPot1(unsigned long currentTime){
    if(currentTime - previousPot1 >= debouncePot){
      sensorVerdi1 = analogRead(sensor1);
      Serial.print("pot1,");
      Serial.println(sensorVerdi1);
      previousPot1 = currentTime;
    }
}
  
void sjekkPot2(unsigned long currentTime){
    if(currentTime - previousPot2 >= debouncePot){
      sensorVerdi2 = analogRead(sensor2);
      Serial.print("pot2,");
      Serial.println(sensorVerdi2);
      previousPot2 = currentTime;
    }
}
  
void sjekkPot3(unsigned long currentTime){
    if(currentTime - previousPot3 >= debouncePot){
      sensorVerdi3 = analogRead(sensor3);
      Serial.print("pot3,");
      Serial.println(sensorVerdi3);
      previousPot3 = currentTime;
    }
}
