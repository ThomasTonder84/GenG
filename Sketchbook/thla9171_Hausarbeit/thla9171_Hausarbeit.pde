
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

//FIXME: Testing
ArrayList<HashMap> tmpLine;


//Konverter
DistanceConverter distConverter;

//Sort
SplitBusStations sortStations;

//Zoom
float graphicScale = 1.0f;


ArrayList<PoiTouristenInfo> testpoi;


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
  for (HashMap test : poiData)
  {
    println(test.get("uuid") + " | " + test.get("latitude") + " | " + test.get("longitude"));
    testcount++;
  }
  println("Anzahl der POI --> " + testcount);
  printArray(poiData.get(0));
  
  
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
  sortStations = new SplitBusStations(busData);
  
  //FIXME: Testing
  tmpLine = sortStations.Split("31");
  println("Testing Linie 16 --> ");
  printArray(tmpLine);
  
  //public DistanceConverter(float latitudeTop, float longitudeTop, float latitudeBottom, float longitudeBottom, float widthDrawing, float heightDrawing, float originX, float originY)
  //TODO: Testen der Koordinatenumrechnung
  distConverter = new DistanceConverter(MAXLATITUDE, MINLONGITUDE, MINLATITUDE, MAXLONGITUDE, graphicWidth, graphicHeight, graphicXOffset, graphicYOffset);
  
  //FIXME: Debugging
  println ("<<<<<<<<<<<<<XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX GEO TESTS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX>>>>>>>>>>>>>>>>>>>>>");
  println ("Origins | X --> " + distConverter.LatitudeToX(MAXLATITUDE) + " | Y --> " + distConverter.LongitudeToY(MINLONGITUDE) );
  println ("Umrechnung Latitude --> " + distConverter.LatitudeToX(MINLATITUDE) + " | Longitude --> " + distConverter.LongitudeToY(MAXLONGITUDE));
  println ("Bus --> " + busData.get(23));
  
  
  //FIXME: Testing
  testpoi = new ArrayList<PoiTouristenInfo>();
  testpoi.add(new PoiTouristenInfo(400f,400f,54.22222f,12.222222f,10f,10f));
  testpoi.add(new PoiTouristenInfo(400f,430f,54.22222f,12.222222f,10f,10f));
  /*
  println("Tests --> TouriPoi");
  println("xPos --> " + testpoi.GetXPosition() + " | yPos --> " + testpoi.GetYPosition());
  testpoi.SetOffset(-11f,-22f);
  println("xPos neu --> " + testpoi.GetXPosition() + " | yPos neu --> " + testpoi.GetYPosition());
  testpoi.SetScaleFactor(10);
  */
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
int xOffsetPrev;
int yOffsetPrev;
Boolean moveXDirection = true;
Boolean moveYDirection = true;

void mousePressed()
{
  //Ausgangsposition des Clicks ermitteln
  zoomXOrigin = mouseX;
  zoomYOrigin = mouseY;
  
  //Zwischenspeichern Offset
  xOffsetPrev = xOffset;
  yOffsetPrev = yOffset;
}

void mouseDragged()
{
  //Zwischenspeicher vorheriger Offset
  //xOffset = 0;
  //yOffset = 0;
  
  //println("mouseDragged x --> " + mouseX + " | y --> " + mouseY);
  println("mouseOrigin  x --> " + zoomXOrigin + " | y --> " + zoomYOrigin);
 
   
  //Offset berechnen und invertieren
  if (mouseX > infoWidth && mouseY > toolHeight)
  {
    xOffset = (zoomXOrigin - mouseX) * (-1) + xOffsetPrev;
    yOffset = (zoomYOrigin - mouseY) * (-1) + yOffsetPrev;
  }
  
  
    println("Offset  x --> " + xOffset + " | y --> " + yOffset);  
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
  
  //TODO: Muss in die Klasse InfoPanel verlegt werden
  //Infobereich zeichnen
  pushStyle();
  fill(111);
  rect(0f,toolHeight,infoWidth,infoHeight);
  popStyle();
  
  
  scale(graphicScale);
  
  //Testing
  PoiTouristenInfo test;
  
  testpoi.get(0).draw();
  testpoi.get(1).draw();
  testpoi.get(0).SetColor(color(122,255,190));
  test = testpoi.get(0);
  test.SetVisibility(true);
  test.SetInformation(poiData.get(0));
  test.SetOffset(xOffset,yOffset);
  
  
   
   
   //FIXME: Stadtmitte
   float MitteX = 54.0924445;
   float MitteY = 12.1286127;
   float MitteXPixel = distConverter.LatitudeToX(MitteX);
   float MitteYPixel = distConverter.LongitudeToY(MitteY);
   pushStyle();
   fill(255,200,200);
   noStroke();
   ellipse(MitteXPixel,MitteYPixel,10f,10f);
   popStyle();
  
  //FIXME: Testing
    for (int i=0; i < tmpLine.size(); i++)
    {
      HashMap tmpBusStation = tmpLine.get(i);
      float xCoord = Float.parseFloat(tmpBusStation.get("latitude").toString());
    float yCoord = Float.parseFloat(tmpBusStation.get("longitude").toString());
    float xPixel = distConverter.LatitudeToX(xCoord);
    float yPixel = distConverter.LongitudeToY(yCoord);
      ellipse(distConverter.LatitudeToX(xCoord), distConverter.LongitudeToY(yCoord),5f,5f);
      
      if ((i+1)<tmpLine.size())
      {
      tmpBusStation = tmpLine.get(i+1);
      float xCoordNext = Float.parseFloat(tmpBusStation.get("latitude").toString());
      float yCoordNext = Float.parseFloat(tmpBusStation.get("longitude").toString());
      float xPixelNext = distConverter.LatitudeToX(xCoordNext);
    float yPixelNext = distConverter.LongitudeToY(yCoordNext);
      pushStyle();
      stroke(5f);
      line(xPixel,yPixel,xPixelNext,yPixelNext);
      popStyle();
      }
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