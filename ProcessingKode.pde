// importere nodvendige bibliotek
import processing.serial.*;
import processing.sound.*;
import java.util.Map;

// HashMap (Dictionary) for aa tilegne hver sangfil(SoundFile) en RFID-kode(String)
HashMap<String,SoundFile> sanger = new HashMap<String, SoundFile>();

Serial myPort;
String val;
float L;
float vol1;
float vol2;
float vol3;


float mapval1;
float mapval2;
float mapval3;

PImage runding;
PImage pil;
PImage runding2;
PImage pil2;
PImage runding3;
PImage pil3;


// Opprette fil-objekter
SoundFile file;
SoundFile file2;
SoundFile file3;
SoundFile file4;
SoundFile file5;
SoundFile file6;
SoundFile file7;
SoundFile file8;
SoundFile file9;
SoundFile file10;
SoundFile file11;
SoundFile file12;
SoundFile file13;

// Filene som spilles for oyeblikket
SoundFile spilles1 = null;
SoundFile spilles2 = null;
SoundFile spilles3 = null;


// Float-verdi mellom 0 og 1 som representerer verdier fra potentiometrene
// Dette er fordi amp-funksjonen (som brukes til aa sette volum) tar imot en float mellom 0 og 1
float volKnapp1;
float volKnapp2;
float volKnapp3;

void setup() {
  size(700,700);
  runding = loadImage("runding.png");
  runding.resize(200,200);
  pil = loadImage("pil2.png");
  pil.resize(120,120);
  runding2 = loadImage("runding.png");
  runding2.resize(200,200);
  pil2 = loadImage("pil2.png");
  pil2.resize(120,120);
  runding3 = loadImage("runding.png");
  runding3.resize(200,200);
  pil3 = loadImage("pil2.png");
  pil3.resize(120,120);
  
  // tilegner filobjektene en lydfil og putter dem (som verdier) i HashMap-et med en RFID som nokkel
  sanger.put("84 AD CB 1E", file = new SoundFile(this, "CaveSoundsF.mp3")); //markert
  sanger.put("71 54 2B 1B", file2 = new SoundFile(this, "TogF.mp3"));  //markert
  sanger.put("C2 D1 A4 31", file3 = new SoundFile(this, "BakgrunnsMusikkF.mp3")); //markert
  sanger.put("8F 7A 9F 29", file4 = new SoundFile(this, "CrowdedHallF.mp3")); //markert
  sanger.put("8F 3F 5E 29", file5 = new SoundFile(this, "StreetSceneF.mp3")); //markert
  sanger.put("8F BA B4 29", file6 = new SoundFile(this, "HavF.mp3")); //markert
  sanger.put("8F 85 24 29", file7 = new SoundFile(this, "InsideHumanOrAnimalBodyF.mp3")); //markert  
  sanger.put("8F 99 82 29", file8 = new SoundFile(this, "RegnF.mp3")); //markert
  sanger.put("8F 09 1F 29", file9 = new SoundFile(this, "SkogF.mp3"));  //markert
  sanger.put("8F 5D E4 29", file10 = new SoundFile(this, "PeacefulHummingF.mp3")); //markert
  sanger.put("8F BC 42 29", file11 = new SoundFile(this, "TordenF.mp3")); //markert
  sanger.put("9E E6 18 20", file12 = new SoundFile(this, "VindF.mp3")); //markert                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
  sanger.put("8F 62 8D 29", file13 = new SoundFile(this, "KnirkingF.mp3")); //markert


  // Itererer over hvert element i HashMap-et og printer ut nokkel og tilhorende verdi
  for (Map.Entry me : sanger.entrySet()) {
    print(me.getKey() + " is ");
    println(me.getValue());
  }
  // Legger til rette for serial kommunikasjon med arduinoen
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
}

void draw() {
 
  // Utforer kun koden dersom arduinoen er tilgjengelig
  if (myPort.available() > 0) {
    // val settes til aa holde paa det som printes fra arduinoen 
    val = myPort.readStringUntil('\n');
    
    // Kaller paa baade hentVolum og spillSang med samme verdi
    // disse funksjonene haandterer informasjonen de faar og sjekker om 
    // det er volum fra potentiometer eller en RFID-kode + play/stop-kommando 
    if (val != null){
      println(val);
        val = trim(val);
        // henter verdi fra et gitt potentiometer og setter det i riktig variabel
        // avhengig av hvilket potMeter som det blir lest fra
        hentVolum(val);
        // Finner riktig lydfil basert paa RFID-en og legger sangen inn i spilles-arrayet
        // Hvor i arrayet de blir plassert er avhengig av hvilken RFID-leser kortet ligger paa
        spillSang(val);
      }
    
    // Funksjon som setter volum til hver lydfil som blir avspilt
    settVolum1(volKnapp1);
    settVolum2(volKnapp2);
    settVolum3(volKnapp3);
  }
  
  // Viser en grafisk representasjon av potMetrene
  grafisk();
}


void settVolum1(float volum){
  // Sjekker at det faktisk er en sang paa denne plassen i arrayet
  if(spilles1 != null){
    SoundFile sang = spilles1;
    // Sjekker at sangen blir avspilt naa
    if (sang.isPlaying()){
      // Setter volum
      sang.amp(volum);
    }
  }
}

void settVolum2(float volum){
  // Sjekker at det faktisk er en sang paa denne plassen i arrayet
  if(spilles2 != null){
    SoundFile sang = spilles2;
    // Sjekker at sangen blir avspilt naa
    if (sang.isPlaying()){
      sang.amp(volum);
    }
  }
}

void settVolum3(float volum){
  // Sjekker at det faktisk er en sang paa denne plassen i arrayet
  if(spilles3 != null){
    SoundFile sang = spilles3;
    // Sjekker at sangen blir avspilt naa
    if (sang.isPlaying()){
      sang.amp(volum);
    }
  }
}

// Tar imot hva enn som printes fra arduinoen som parameter
void hentVolum(String val){
  
  // Stringen blir gjort om til et String-array, separert av komma
  String[] potMet = split(val, ',');
  
  // Dersom forste element i arrayet tilsier at den kommende tallet 
  // tilhorer potentiometer nr1 blir setningen true
  if (potMet[0].equals("pot1")){
    // Try-Catch for aa haandtere det dersom det blir problemer med formatteringen
    try{
      // Endrer strengen fra arrayet til en float-verdi
      float vol1 = Float.parseFloat(potMet[1].trim());
      // sjekker at tallet er innenfor de riktige grensene deretter deles tallet paa 1023 
      // slik at vi faar en float-verdi mellom 0 og 1, og putter det i riktig variabel
      if(vol1 >= 0 &&  vol1 <=1023){
        mapval1 = map(vol1,0,1023,0,5.5);
        volKnapp1 = vol1/1023;
      }
    }catch(NumberFormatException e){}
    
   
  // Kode som utforer det samme, men dersom verdien er fra potMeter 2 eller 3.
  }else if (potMet[0].equals("pot2")){
    try{
      float vol2 = Float.parseFloat(potMet[1].trim());
       if(vol2 > 0 && vol2 < 1023){
         mapval2 = map(vol2,0,1023,0,5.5);
         volKnapp2 = vol2/1023;
       }
    }catch(NumberFormatException e){}
  }else if (potMet[0].equals("pot3")){
    try{
      float vol3 = Float.parseFloat(potMet[1].trim());
      if(vol3 > 0 && vol3 < 1023){
        mapval3 = map(vol3,0,1023,0,5.5);
        volKnapp3 = vol3/1023;
      }
    }catch(NumberFormatException e){}
  }
}


// Her skal formatet paa strengen vaere som folger 
//("RFID-kode,Play/Stop,tall fra 0-2 (identifiserer hvilken RFID-leser det er snakk om)")
// F.eks "84 AD CB 1E,Play,0"
void spillSang(String val){
  
  // Sorge for at vi bare gaar videre naar en fil skal spilles eller stoppes
  if (!trim(val).equals("ingen,ting")&&(!trim(val).equals("Stop"))&&(!trim(val).equals("ing,Stop"))&&(!trim(val).equals("ng,Stop"))){
    
    // Bli kvitt undodvendig "spacing"
    val = trim(val);
    
    // Stringen blir gjort om til et String-array, separert av komma
    String[] list = split(val, ',');
    
    // Henter filen som horer til RFID-koden i strengen
    SoundFile file = sanger.get(list[0]);
    
    int fjernes = 0;
    // Gaar bare videre dersom vi vet at arrayet har en lengde paa minst 2
    // slik at vi ikke faar ArrayIndexOutOfBoundsException
    if (list.length > 1){
      
      // Sjekker at kommandoen/tekst-strengen er play
      if (list[1].trim().equals("Play")){
        
        // Sjekker at sangen ikke spilles allerede
        if(!file.isPlaying()){
          
          // Starter sangen
          file.play();
          
          // Sjekker forst at arrayet(med info fra arduinoen) har 3 plasser, og deretter setter vi 
          // sangen som spilles
          // 
          if (list.length == 3){
            println(list[2].trim());
            if (int(list[2].trim()) == 0){
              spilles1 = file;
            } else if (int(list[2].trim()) == 1){
              spilles2 = file;
            }else if (int(list[2].trim()) == 2){
              spilles3 = file;
            }
          }
        }
        
      // Dersom kommandoen paa andre element i listen er "Stop"
      // og sangen blir spilt av, stopper vi den
      }else if (list[1].trim().equals("Stop")){
        try{
          if(file.isPlaying()){
            file.stop();
            if (int(list[2].trim()) == 1){
              spilles1 = null;
             }else if (int(list[2].trim()) == 2){
              spilles2 = null;
             }else if (int(list[2].trim()) == 3){
              spilles3 = null;
            }
          }
        }catch(NullPointerException e){}
      }
    }
  }
}

void grafisk(){
  background(#A2F278);
  imageMode(CENTER);
  image(runding,150,350);
  image(runding2,350,350);
  image(runding3,550,350);

  
  pushMatrix();
  translate(150,350);
  rotate(mapval1+2.75);
  image(pil,0,0);
  popMatrix();

  pushMatrix();
  translate(350,350);
  rotate(mapval2+2.75);
  image(pil2,0,0);
  popMatrix();

  pushMatrix();
  translate(550,350);
  rotate(mapval3+2.75);
  image(pil3,0,0);
  popMatrix();
}
