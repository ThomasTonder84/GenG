
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
final int SKETCHWIDTH = 1280;
final int SKETCHHEIGHT = 960;

//Anzeige
int graphicWidth;
int graphicHeight;
int graphicXOffset;
int graphicYOffset;

//Tool
int toolWidth;
int toolHeight;

//Informationen
int infoWidth;
int infoHeight;
int infoXOffset;
int infoYOffset;

//Daten einlesen
String[] poiFiles;
String busFile;
DataReader readData;

//Aufbereitete Daten
ArrayList<HashMap> poiData;
ArrayList<HashMap> busData;

//Konverter
DistanceConverter distConverter;

//Sort
SortBusStations sortStations;

//Zoom
float graphicScale = 1.0f;


////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
// Ablauflogik
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
//Init
void setup()
{
  //BEI ÄNDERUNG DER GRÖßE MUSS sketchWidth und sketchHeight AUCH ANGEPASST WERDEN!!!!!!
  size(1280,960); //FIXME: Breite muss wieder auf 1280 gesetzt werden
  
  //TODO: Festlegen der Breiten für die einzelnen Bereiche
  //Maße festlegen
  //Breiten
  infoWidth = 250;
  toolWidth = SKETCHWIDTH;
  graphicWidth = SKETCHWIDTH - infoWidth;
  graphicXOffset = infoWidth;
  infoXOffset = 0;
  
  //Höhen
  toolHeight =  100;
  graphicHeight = SKETCHHEIGHT - toolHeight;
  infoHeight = SKETCHHEIGHT;
  graphicYOffset = toolHeight;
  infoYOffset = toolHeight;
  
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
  /*testcount = 0;
  println ("<<<<<<<<<<<<<XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Enthaltene Datensätze Haltestellen XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX>>>>>>>>>>>>>>>>>>>>>");
  for (HashMap test : busData)
  {
    
    
    println(test.get("latitude") + " | " + test.get("longitude") + " | " + test.keySet());
    printArray(test.get("linien"));
    println ("\n");
    
    testcount++;
  }*/
  
  println("Anzahl der Haltestellen --> " + testcount);
  
  println("Buslinien --> ");
  printArray(readData.getAvailableBusLines());
  
  //TODO: aufrufen des Getters und zuweisen der Rückgabedaten
  sortStations = new SortBusStations(busData, readData.getAvailableBusLines());
  
  
  //public DistanceConverter(float latitudeTop, float longitudeTop, float latitudeBottom, float longitudeBottom, float widthDrawing, float heightDrawing, float originX, float originY)
  //TODO: Testen der Koordinatenumrechnung
  distConverter = new DistanceConverter(MAXLATITUDE, MINLONGITUDE, MINLATITUDE, MAXLONGITUDE, graphicWidth, graphicHeight, graphicXOffset, graphicYOffset);
  
  //FIXME: Debugging
  println ("<<<<<<<<<<<<<XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX GEO TESTS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX>>>>>>>>>>>>>>>>>>>>>");
  println ("Origins | X --> " + distConverter.LatitudeToX(MAXLATITUDE) + " | Y --> " + distConverter.LongitudeToY(MINLONGITUDE) );
  println ("Umrechnung Latitude --> " + distConverter.LatitudeToX(MINLATITUDE) + " | Longitude --> " + distConverter.LongitudeToY(MAXLONGITUDE));
  println ("Bus --> " + busData.get(23));
}


//Maus Interaktionen
//Zoom
void mouseWheel(MouseEvent zoomEvent)
{
  float wheel = zoomEvent.getCount();
  
  //FIXME: Debugging
  println("Mouse Scrolling --> " + wheel);
  println("Mouse Action    --> " + zoomEvent.getAction());
  println("Mouse x         --> " + zoomEvent.getX() + " | Mouse y --> " + zoomEvent.getY());
  
  if (wheel < 0f)
  {
    graphicScale += 0.1f;
  }
  
  if (wheel > 0f)
  {
    if (graphicScale > 1f)
    {
      graphicScale -= 0.1f;
    }
  }
  
}


int zoomXOrigin;
int zoomYOrigin;
int xOffset;
int yOffset;
Boolean moveXDirection = true;
Boolean moveYDirection = true;

void mousePressed()
{
  //Ausgangsposition des Clicks ermitteln
  zoomXOrigin = mouseX;
  zoomYOrigin = mouseY;
}

void mouseDragged()
{
  //Reset des Offset
  xOffset = 0;
  yOffset = 0;
  
  //println("mouseDragged x --> " + mouseX + " | y --> " + mouseY);
  println("mouseOrigin  x --> " + zoomXOrigin + " | y --> " + zoomYOrigin);
  
  
  
  //Offset berechnen und invertieren
  if (mouseX > infoWidth && mouseY > toolHeight)
  {
    xOffset = (zoomXOrigin - mouseX) * (-1);
    yOffset = (zoomYOrigin - mouseY) * (-1);
  }
  
  
  
  
    
  
  
  
    println("Offset  x --> " + xOffset + " | y --> " + yOffset);
  
  
  
  ////FIXME: Testing
  //  for (HashMap poi : poiData)
  //{
  //  float xCoord = Float.parseFloat(poi.get("latitude").toString());
  //  float yCoord = Float.parseFloat(poi.get("longitude").toString());
    
  //  float xPixel = distConverter.LatitudeToX(xCoord);
  //  float yPixel = distConverter.LongitudeToY(yCoord);
    
  //  xPixel += float(xOffset);
  //  yPixel += float(yOffset);
    
  //  pushStyle();
    
  //  fill(25);
  //  //rect(distConverter.LatitudeToX(xCoord), distConverter.LongitudeToY(yCoord),5f,5f);
  //  rect(xPixel, yPixel,5f,5f);
  //  popStyle();
  //}
  
  
  
  
}


void draw()
{
  //FIXME: MUss hier raus
  //noLoop();
  //TODO: Aufbau des Gui, Infoseite und Zeichenbereich
  
  
  
  background(255);
  
  //Tool zeichnen
  pushStyle();
  fill(44);
  rect(0f,0f,toolWidth,toolHeight);
  popStyle();
  
  //Infobereich zeichnen
  pushStyle();
  fill(111);
  rect(0f,toolHeight,infoWidth,infoHeight);
  popStyle();
  
  
  
  
  
   scale(graphicScale);
  
  //FIXME: Testing
  for (HashMap busStop : busData)
  {
    float xCoord = Float.parseFloat(busStop.get("latitude").toString());
    float yCoord = Float.parseFloat(busStop.get("longitude").toString());
    
    ellipse(distConverter.LatitudeToX(xCoord), distConverter.LongitudeToY(yCoord),5f,5f);
  }
  
  
  //TODO: Wenn einzelne Punkte über die entsprechenden Grenzen hinausgehen
  //müssen diese ausgeblendet werden
  //befinden diese sich wieder im Feld müssen sie wieder eingeblendet werden
  for (HashMap poi : poiData)
  {
    float xCoord = Float.parseFloat(poi.get("latitude").toString());
    float yCoord = Float.parseFloat(poi.get("longitude").toString());
    
    float xPixel = distConverter.LatitudeToX(xCoord);
    float yPixel = distConverter.LongitudeToY(yCoord);
    
    xPixel += float(xOffset);
    yPixel += float(yOffset);
    
    if (xPixel <= infoWidth)
    {
      moveXDirection = false;
    }
    else
    {
      moveXDirection = true;
    }
    
    if (yPixel <= toolHeight)
    {
      moveYDirection = false;
    }
    else
    {
      moveYDirection = true;
    }
    
  }
  
  for (HashMap poi : poiData)
  {
    float xCoord = Float.parseFloat(poi.get("latitude").toString());
    float yCoord = Float.parseFloat(poi.get("longitude").toString());
    
    float xPixel = distConverter.LatitudeToX(xCoord);
    float yPixel = distConverter.LongitudeToY(yCoord);

    if (moveXDirection != false && moveYDirection != false)
    {
      xPixel += float(xOffset);
      yPixel += float(yOffset);
    }

    pushStyle();
    
    fill(25);
    //rect(distConverter.LatitudeToX(xCoord), distConverter.LongitudeToY(yCoord),5f,5f);
    rect(xPixel, yPixel,5f,5f);
    popStyle();
  }
  
}