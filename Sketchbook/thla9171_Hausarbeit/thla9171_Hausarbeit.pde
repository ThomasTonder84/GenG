
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
//final float MAXLATITUDE = 54.2444; //Norden
//final float MAXLONGITUDE = 12.2958; //Osten
//final float MINLATITUDE = 54.0501; //Süden
//final float MINLONGITUDE = 11.9964; //Westen

final float MAXLATITUDE = 54.1878; //Norden
final float MAXLONGITUDE = 12.2161; //Osten
final float MINLATITUDE = 54.0505; //Süden
final float MINLONGITUDE = 12.0184; //Westen





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

//Busdaten
ArrayList<BusStation> busStation;
ArrayList<BusLine> busLine;
ArrayList<String> busLinesAvailable;
ArrayList<HashMap> tmpLine; //Temporäre Verarbeitung

//Farben
//TODO: Farben für Buslinien und Pois festlegen

//Points of Interes
ArrayList<PoiTouristenInfo> poiTouristInfo;
ArrayList<PoiMusikClub> poiMusik;
ArrayList<PoiKino> poiKino;
ArrayList<PoiBrunnen> poiBrunnen;

//Konverter
DistanceConverter distConverter;

//Sort
SplitBusStations sortStations;

//Zoom
float graphicScale = 1.0f;



int zoomXOrigin;
int zoomYOrigin;
int xOffset;
int yOffset;
int xOffsetPrev;
int yOffsetPrev;
Boolean moveXDirection = true;
Boolean moveYDirection = true;




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
  
  //Init des Distance Konverters
  distConverter = new DistanceConverter(MAXLATITUDE, MINLONGITUDE, MINLATITUDE, MAXLONGITUDE, graphicWidth, graphicHeight, graphicXOffset, graphicYOffset);
  
  //Init Poi Files
  poiFiles = new String[]{"brunnen.csv","kinos.csv","musikclubs.csv","touristeninformation.csv"};
  busFile = "haltestellen.csv";
  
  //Init Poi Types
  poiBrunnen = new ArrayList<PoiBrunnen>();
  
  //Init Bus Types
  busLinesAvailable = new ArrayList<String>();
  busLine = new ArrayList<BusLine>();
  
  //Daten einlesen
  readData = new DataReader();
  readData.SetFolder("poi\\");
  
  
    //FIXME: Testing
   //float xPositionPixel, float yPositionPixel, float latitude, float longitude, float xWidth, String availableLines)
  //busStation = new ArrayList<BusStation>();
  //busStation.add(new BusStation(400f,510f,54.22222f,12.222222f,10f,busData.get(100).get("linien").toString()));
  
  
  //poiTouristInfo = new ArrayList<PoiTouristenInfo>();
  //poiTouristInfo.add(new PoiTouristenInfo(400f,400f,54.22222f,12.222222f,3f,10f));
  //poiTouristInfo.add(new PoiTouristenInfo(400f,430f,54.22222f,12.222222f,3f,10f));
  
  //poiMusik = new ArrayList<PoiMusikClub>();
  //poiMusik.add(new PoiMusikClub(400f,450f,54.22222f,12.222222f,10f,10f));
  
  //poiKino = new ArrayList<PoiKino>();
  //poiKino.add(new PoiKino(400f,470f,54.22222f,12.222222f,10f,10f));
  
  //
  //poiBrunnen.add(new PoiBrunnen(400f,490f,54.22222f,12.222222f,10f));
  
  
  
  float tmpX = 0f;
  float tmpY = 0f;
  float tmpXPixel = 0f;
  float tmpYPixel = 0f;
  
  //TODO: Poi einzeln einlesen und zuweisen
  //Points of Interest einlesen
  int poiCounter = 0;
  poiData = readData.getDataPoi(poiFiles[poiCounter]);
  
  for (HashMap tmpPoi : poiData)
  {
    tmpX = Float.parseFloat(tmpPoi.get("latitude").toString());
    tmpY = Float.parseFloat(tmpPoi.get("longitude").toString());
    tmpXPixel = distConverter.LatitudeToX(tmpX);
    tmpYPixel = distConverter.LongitudeToY(tmpY);
    
    
    poiBrunnen.add(new PoiBrunnen(tmpXPixel,tmpYPixel,tmpX,tmpY,10f));
    poiBrunnen.get(poiCounter).SetInformation(tmpPoi);
    
    poiCounter++;
  }
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
  busLinesAvailable = readData.getAvailableBusLines();
  
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
  printArray(busLinesAvailable);
  
  //Aufteilen nach Buslinien
  sortStations = new SplitBusStations(busData);
  
  //Aufbereiten der Buslinien  
  for (String tmpBusLine : busLinesAvailable)
  {
    int idCount = 0;
    tmpLine = sortStations.Split(tmpBusLine);  
    
    //FIXME: Debugging
    println("Verarbeitung Linie --> " + tmpBusLine);
    //printArray(tmpLine);
    
      
    //Konvertieren der Geo zu Pixel Koordinaten
    for (HashMap tmpStation : tmpLine)
    {
      println("Station --> ");
      printArray(tmpStation);
      
      idCount++;
      
      tmpX = Float.parseFloat(tmpStation.get("latitude").toString());
      tmpY = Float.parseFloat(tmpStation.get("longitude").toString());
      tmpXPixel = distConverter.LatitudeToX(tmpX);
      tmpYPixel = distConverter.LongitudeToY(tmpY);
      
      tmpStation.put("x",tmpXPixel);
      tmpStation.put("y",tmpYPixel);
      tmpStation.put("id",idCount);
    }
    
    //Erstellen des Buslinien Objekts
    busLine.add(new BusLine(tmpLine,10f));
  }
  
  
  
  
  
  
  
  
  //FIXME: Debugging
  println ("<<<<<<<<<<<<<XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX GEO TESTS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX>>>>>>>>>>>>>>>>>>>>>");
  println ("Origins | X --> " + distConverter.LatitudeToX(MAXLATITUDE) + " | Y --> " + distConverter.LongitudeToY(MINLONGITUDE) );
  println ("Umrechnung Latitude --> " + distConverter.LatitudeToX(MINLATITUDE) + " | Longitude --> " + distConverter.LongitudeToY(MAXLONGITUDE));
  //println ("Bus --> " + busData.get(23));
  
  

  /*
  println("Tests --> TouriPoi");
  println("xPos --> " + poiTouristInfo.GetXPosition() + " | yPos --> " + poiTouristInfo.GetYPosition());
  poiTouristInfo.SetOffset(-11f,-22f);
  println("xPos neu --> " + poiTouristInfo.GetXPosition() + " | yPos neu --> " + poiTouristInfo.GetYPosition());
  poiTouristInfo.SetScaleFactor(10);
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




void mousePressed()
{
  //Ausgangsposition des Clicks ermitteln
  zoomXOrigin = mouseX;
  zoomYOrigin = mouseY;
  
  //Zwischenspeichern des vorherigen Offset
  xOffsetPrev = xOffset;
  yOffsetPrev = yOffset;
}

void mouseDragged()
{
  //FIXME: Debugging
  //println("mouseDragged x --> " + mouseX + " | y --> " + mouseY);
  println("mouseOrigin  x --> " + zoomXOrigin + " | y --> " + zoomYOrigin);
 
   
  //Offset berechnen und invertieren
  if (mouseX > infoWidth && mouseY > toolHeight)
  {
    xOffset = (zoomXOrigin - mouseX) * (-1) + xOffsetPrev;
    yOffset = (zoomYOrigin - mouseY) * (-1) + yOffsetPrev;
  }
  
    //FIXME: Debugging
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
  
  //Skalierung --> Zoom
  scale(graphicScale);
  
  //FIXME: Testing
  //PoiTouristenInfo test;
  
  //poiTouristInfo.get(0).draw();
  //poiTouristInfo.get(1).draw();
  //poiTouristInfo.get(0).SetColor(color(122,255,190));
  //test = poiTouristInfo.get(0);
  //test.SetVisibility(true);
  //test.SetSelected(true);
  ////test.SetInformation(poiData.get(0));
  //test.SetOffset(xOffset,yOffset);
  
  //poiMusik.get(0).draw();
  //poiKino.get(0).draw(); 
  
  
  //busStation.get(0).draw();
  
   
   //Stadtmitte einzeichnen
   float MitteX = 54.0924445;
   float MitteY = 12.1286127;
   float MitteXPixel = distConverter.LatitudeToX(MitteX);
   float MitteYPixel = distConverter.LongitudeToY(MitteY);
   pushStyle();
   fill(255,200,200);
   noStroke();
   ellipse((MitteXPixel+xOffset),(MitteYPixel+yOffset),10f,10f);
   popStyle();
  
  //TODO: Nötige Abfragen zum Verschieben etc. einbauen
  //Brunnen darstellen
  for (PoiBrunnen tmpBrunnen : poiBrunnen)
  {
    tmpBrunnen.SetOffset(xOffset,yOffset);
    
    
    tmpBrunnen.draw();
  }
  
  
  
  
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
    
  
  //Buslinien darstellen
  for (BusLine tmpLine : busLine)
  {
     tmpLine.SetOffset(xOffset,yOffset);
    
    if (tmpLine.GetXPosition() <= infoWidth || tmpLine.GetYPosition() <= toolHeight)
    {
      moveXDirection = false;
      //tmpLine.SetStationVisibility(tmpLine.,)
    }
    else
    {
      tmpLine.SetVisibility(true);
    }
    
    tmpLine.draw();
  }
  
  //BusLine testbus = busLine.get(0);
  //testbus.SetSelected(true);
  //testbus.draw();
  //println("Zeichne Line Nummer --> " + testbus.GetLineNumber());
  
  
  
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