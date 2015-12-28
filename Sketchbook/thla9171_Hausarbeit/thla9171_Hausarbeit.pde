
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
// Includes
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
import java.util.*;
import controlP5.*;

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
// Globale Variablen
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
// Größen der verschiedenen Elemente
////////////////////////////////////////////////////////////////

//Geo Koordinaten
//TODO: Prüfen ob Ausschnitt in Ordnung
final float MAXLATITUDE = 54.2444; //Norden
final float MAXLONGITUDE = 12.2958; //Osten
final float MINLATITUDE = 54.0501; //Süden
final float MINLONGITUDE = 11.9964; //Westen

//Größe der Zeichenfläche 
//(WICHTIG --> Größe der Zeichenfläche muss
//in setup manuell angepasst werden
//Variablen nur zur Berechnung der Aufteilung)
final int SKETCHWIDTH = 1024;
final int SKETCHHEIGHT = 768;

//Anzeige
int graphicWidth;
int graphicHeight;

//Tool
int toolWidth;
int toolHeight;

//Informationen
int infoWidth;
int infoHeight;

//Daten einlesen
String[] poiFiles;
String busFile;
DataReader readData;

//Aufbereitete Daten
ArrayList<HashMap> poiData;
ArrayList<HashMap> busData;

//Konverter
DistanceConverter distConverter;


////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
// Ablauflogik
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
//Init
void setup()
{
  //BEI ÄNDERUNG DER GRÖßE MUSS sketchWidth und sketchHeight AUCH ANGEPASST WERDEN!!!!!!
  size(1024,768);
  
  //TODO: Festlegen der Breiten für die einzelnen Bereiche
  
  poiFiles = new String[]{"brunnen.csv","kinos.csv","musikclubs.csv","touristeninformation.csv"};
  busFile = "haltestellen.csv";
  
  //readData = new DataReader("D:\\FH\\GenG\\Daten\\poi\\");
  readData = new DataReader();
  readData.SetFolder("poi\\");
  
  
  //Points of Interest einlesen
  poiData = readData.getAllDataPoi(poiFiles);
  
  //FIXME: Muss raus
  //Test = readData.getDataPoi("unterkuenfte.csv");
  
  //FIXME: Debugging
  int testcount = 0;
  println ("<<<<<<<<<<<<<XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Enthaltene Datensätze POIs XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX>>>>>>>>>>>>>>>>>>>>>");
  /*for (HashMap test : poiData)
  {
    println(test.get("uuid") + " | " + test.get("latitude") + " | " + test.get("longitude"));
    testcount++;
  }
  println("Anzahl der POI --> " + testcount);*/
  
  //Buslinien auslesen
  readData.SetFolder("\\");
  busData = readData.getDataBus(busFile);
  
  //FIXME: Debugging
  testcount = 0;
  println ("<<<<<<<<<<<<<XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Enthaltene Datensätze Haltestellen XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX>>>>>>>>>>>>>>>>>>>>>");
  for (HashMap test : busData)
  {
    
    
    println(test.get("latitude") + " | " + test.get("longitude"));
    printArray(test.get("linien"));
    println ("\n");
    
    testcount++;
  }
  
  println("Anzahl der Haltestellen --> " + testcount);
  
  println("Buslinien --> ");
  printArray(readData.getAvailableBusLines());
  
  //public DistanceConverter(float latitudeTop, float longitudeTop, float latitudeBottom, float longitudeBottom, float widthDrawing, float heightDrawing, float originX, float originY)
  //TODO: Testen der Koordinatenumrechnung
  distConverter = new DistanceConverter(MAXLATITUDE, MINLONGITUDE, MINLATITUDE, MAXLONGITUDE, 1024f, 768f, 0f, 0f);
  
  //FIXME: Debugging
  println ("<<<<<<<<<<<<<XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX GEO TESTS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX>>>>>>>>>>>>>>>>>>>>>");
  println ("Origins | X --> " + distConverter.getOriginX() + " | Y --> " + distConverter.getOriginY() );
  println ("Umrechnung Latitude --> " + distConverter.LatitudeToX(MINLATITUDE) + " | Longitude --> " + distConverter.LongitudeToY(MAXLONGITUDE));
  
}



void draw()
{
  
  //TODO: Aufbau des Gui, Infoseite und Zeichenbereich
  
  background(255);
  
  //FIXME: Testing
  for (HashMap busStop : busData)
  {
    float xCoord = Float.parseFloat(busStop.get("latitude").toString());
    float yCoord = Float.parseFloat(busStop.get("longitude").toString());
    
    ellipse(distConverter.LatitudeToX(xCoord), distConverter.LongitudeToY(yCoord),5f,5f);
  }
  
  
}