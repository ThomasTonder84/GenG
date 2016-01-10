
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
InfoPanel infoPanel;

//Daten einlesen
String[] poiFiles;
String busFile;
DataReader readData;

//Aufbereitete Daten
ArrayList<HashMap> poiData;
ArrayList<HashMap> busData;

//Busdaten
ArrayList<BusStation> busStation;
HashMap<String,BusLine[]> busLine;
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

//Farben
color colorStations;
color colorBrunnen;
color colorMusik;
color colorKino;
color colorInfo;
color colorBackground;
color colorCityCenter;
color colorRed;
color colorBlue;
color colorWhite;

//Zoom
float graphicScale = 1.0f;
int zoomXOrigin;
int zoomYOrigin;
int xOffset;
int yOffset;
int xOffsetPrev;
int yOffsetPrev;




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
  
  //Init Farben
  colorRed = color(#d81920);
  colorBlue = color(#006cb7);
  colorWhite = color(#f3f3f3);
  
  colorStations = colorBlue;
  colorBrunnen = colorRed;
  colorMusik = colorRed;
  colorKino = colorRed;
  colorInfo = colorRed;
  colorBackground = colorWhite;
  colorCityCenter = color(#7c19a1);
  
  
  //Init InfoPanel
  infoPanel = new InfoPanel(0,toolHeight,infoWidth,infoHeight,colorBlue);
  
  //Init Poi Files
  poiFiles = new String[]{"brunnen.csv","kinos.csv","musikclubs.csv","touristeninformation.csv"};
  busFile = "haltestellen.csv";
  
  //Init Poi Types
  poiBrunnen = new ArrayList<PoiBrunnen>();
  poiKino = new ArrayList<PoiKino>();
  poiMusik = new ArrayList<PoiMusikClub>();
  poiTouristInfo = new ArrayList<PoiTouristenInfo>();
  
  //Init Bus Types
  busLinesAvailable = new ArrayList<String>();
  busLine = new HashMap<String,BusLine[]>();
  busStation = new ArrayList<BusStation>();
  
  //Daten einlesen
  readData = new DataReader();
  readData.SetFolder("poi\\");
  
  
  //Temp Variablen für Koordinatentransformation
  float tmpX = 0f;
  float tmpY = 0f;
  float tmpXPixel = 0f;
  float tmpYPixel = 0f;
  
  //Points of Interest einlesen
  int poiCounter = 0;
  int poiIndex = 0;
  
  //Poi Brunnen einlesen
  poiData = readData.getDataPoi(poiFiles[poiCounter]);
  
  for (HashMap tmpPoi : poiData)
  {
    tmpX = Float.parseFloat(tmpPoi.get("latitude").toString());
    tmpY = Float.parseFloat(tmpPoi.get("longitude").toString());
    tmpXPixel = distConverter.LatitudeToX(tmpX);
    tmpYPixel = distConverter.LongitudeToY(tmpY);
    
    
    poiBrunnen.add(new PoiBrunnen(tmpXPixel,tmpYPixel,tmpX,tmpY,5f));
    poiBrunnen.get(poiIndex).SetInformation(tmpPoi);
    
    poiIndex++;
  }
  
  poiCounter++;
  
  
  //Poi Kinos einlesen
  poiData = readData.getDataPoi(poiFiles[poiCounter]);
  poiIndex = 0;
  
  for (HashMap tmpPoi : poiData)
  {
    tmpX = Float.parseFloat(tmpPoi.get("latitude").toString());
    tmpY = Float.parseFloat(tmpPoi.get("longitude").toString());
    tmpXPixel = distConverter.LatitudeToX(tmpX);
    tmpYPixel = distConverter.LongitudeToY(tmpY);
    
    
    poiKino.add(new PoiKino(tmpXPixel,tmpYPixel,tmpX,tmpY,7f,7f));
    poiKino.get(poiIndex).SetInformation(tmpPoi);
    
    poiIndex++;
  }
  
  poiCounter++;
  
  
  //Poi Musikclubs einlesen
  poiData = readData.getDataPoi(poiFiles[poiCounter]);
  poiIndex = 0;
  
  for (HashMap tmpPoi : poiData)
  {
    tmpX = Float.parseFloat(tmpPoi.get("latitude").toString());
    tmpY = Float.parseFloat(tmpPoi.get("longitude").toString());
    tmpXPixel = distConverter.LatitudeToX(tmpX);
    tmpYPixel = distConverter.LongitudeToY(tmpY);
    
    
    poiMusik.add(new PoiMusikClub(tmpXPixel,tmpYPixel,tmpX,tmpY,7f,7f));
    poiMusik.get(poiIndex).SetInformation(tmpPoi);
    
    poiIndex++;
  }
  
  poiCounter++;
  
  
  //Poi Musikclubs einlesen
  poiData = readData.getDataPoi(poiFiles[poiCounter]);
  poiIndex = 0;
  
  for (HashMap tmpPoi : poiData)
  {
    tmpX = Float.parseFloat(tmpPoi.get("latitude").toString());
    tmpY = Float.parseFloat(tmpPoi.get("longitude").toString());
    tmpXPixel = distConverter.LatitudeToX(tmpX);
    tmpYPixel = distConverter.LongitudeToY(tmpY);
    
    
    poiTouristInfo.add(new PoiTouristenInfo(tmpXPixel,tmpYPixel,tmpX,tmpY,3f,7f));
    poiTouristInfo.get(poiIndex).SetInformation(tmpPoi);
    
    poiIndex++;
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
    int lineSize = tmpLine.size();
    BusLine[] tmpLineBuffer = new BusLine[lineSize];
    
    
    //FIXME: Debugging
    println("Verarbeitung Linie --> " + tmpBusLine);
    //printArray(tmpLine);
    
      
    //Konvertieren der Geo zu Pixel Koordinaten
    for (HashMap tmpStation : tmpLine)
    {     
      idCount++;
      
      tmpX = Float.parseFloat(tmpStation.get("latitude").toString());
      tmpY = Float.parseFloat(tmpStation.get("longitude").toString());
      tmpXPixel = distConverter.LatitudeToX(tmpX);
      tmpYPixel = distConverter.LongitudeToY(tmpY);
      
      tmpLineBuffer[idCount-1] = new BusLine(tmpXPixel,tmpYPixel,tmpX,tmpY,10f,tmpBusLine,idCount);
    }

    println("HashMap Print --> " + tmpLineBuffer.length);
    
    //Erstellen des Buslinien Objekts
    busLine.put(tmpBusLine,tmpLineBuffer);
  }
  
  
  //Stationen einlesen
  for (HashMap tmpStation : busData)
  {
      tmpX = Float.parseFloat(tmpStation.get("latitude").toString());
      tmpY = Float.parseFloat(tmpStation.get("longitude").toString());
      tmpXPixel = distConverter.LatitudeToX(tmpX);
      tmpYPixel = distConverter.LongitudeToY(tmpY);
  
        //public BusStation(float xPositionPixel, float yPositionPixel, float latitude, float longitude, float xWidth, String availableLines)
      busStation.add(new BusStation(tmpXPixel,tmpYPixel,tmpX,tmpY,6f,tmpStation.get("linien").toString()));
  }
  
  //FIXME: Debugging
  println ("<<<<<<<<<<<<<XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX GEO TESTS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX>>>>>>>>>>>>>>>>>>>>>");
  println ("Origins | X --> " + distConverter.LatitudeToX(MAXLATITUDE) + " | Y --> " + distConverter.LongitudeToY(MINLONGITUDE) );
  println ("Umrechnung Latitude --> " + distConverter.LatitudeToX(MINLATITUDE) + " | Longitude --> " + distConverter.LongitudeToY(MAXLONGITUDE));
  //println ("Bus --> " + busData.get(23));

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
  //println("mouseOrigin  x --> " + zoomXOrigin + " | y --> " + zoomYOrigin);
 
   
  //Offset berechnen und invertieren
  if (mouseX > infoWidth && mouseY > toolHeight)
  {
    xOffset = (zoomXOrigin - mouseX) * (-1) + xOffsetPrev;
    yOffset = (zoomYOrigin - mouseY) * (-1) + yOffsetPrev;
  }
  
    //FIXME: Debugging
    //println("Offset  x --> " + xOffset + " | y --> " + yOffset);  
}

BusStation markedStation;
//Auslesen der Informationen
void mouseClicked(MouseEvent clickEvent)
{
  float xClick = (float)clickEvent.getX();
  float yClick = (float)clickEvent.getY();
  float tolerance = 2f*graphicScale;
  float objXPosition = 0f;
  float objYPosition = 0f;
  
  //FIXME: Debugging
  println("Clicked on --> X:" + xClick + " | Y:" + yClick + " | Toleranz --> " + tolerance);  
  println("Suchradius X --> " + (xClick-tolerance) + " bis " + (xClick+tolerance));
  println("Suchradius Y --> " + (yClick-tolerance) + " bis " + (yClick+tolerance));
  
  if (xClick > infoWidth && yClick > toolHeight)
  {
    //TODO: Jede Buslinie wieder auf selected == false setzen
    //Gleiches mit Punkten
    /////////////////////////////////////////
    //Highlight zurücksetzen
    /////////////////////////////////////////
    infoPanel.SetInfoDisplay(false);
    
    //Buslinien
    for (String tmpLine : busLinesAvailable)
    {
      for (BusLine tmpBusLine : busLine.get(tmpLine))
      {
        tmpBusLine.SetSelected(false);
      }
    }
    
    //Haltestellen
    for (BusStation tmpStation : busStation)
    {
      tmpStation.SetSelected(false);
    }
    
    //PoiBrunnen
    for (PoiBrunnen tmpPoi : poiBrunnen)
    {
      tmpPoi.SetSelected(false);
    }
    
    //PoiKino
    for (PoiKino tmpPoi : poiKino)
    {
      tmpPoi.SetSelected(false);
    }
    
    //PoiMusikClub  
    for (PoiMusikClub tmpPoi : poiMusik)
    {
      tmpPoi.SetSelected(false);
    }
    
    //PoiTouristenInformation
    for (PoiTouristenInfo tmpPoi : poiTouristInfo)
    {
      tmpPoi.SetSelected(false);
    }
    
    /////////////////////////////////////////
    //Highlight setzen
    ////////////////////////////////////////
    for (BusStation tmpStation : busStation)
    {
        objXPosition = tmpStation.GetXPosition() * graphicScale;
        objYPosition = tmpStation.GetYPosition() * graphicScale;
      
      if (objXPosition >= (xClick-tolerance) && objXPosition <= (xClick+tolerance) && objYPosition >= (yClick-tolerance) && objYPosition <= (yClick+tolerance))
      {
        if (tmpStation.GetSelected() == false)
        {
          println("Gefundener Punkt --> X:" + tmpStation.GetXPosition() + " | Y:" + tmpStation.GetYPosition() + " --> ");
          printArray(tmpStation.GetBusLines());

          tmpStation.SetSelected(true);         
          infoPanel.SetDisplayData(tmpStation);
          
          //TODO: Bei Selektion mittig ausrichten
          
          
          for (String tmpLine : tmpStation.GetBusLines())
          {
            for (BusLine tmpBusLine : busLine.get(tmpLine))
            {
              tmpBusLine.SetSelected(true);
            }
          }
          
        }
        else
        {
          tmpStation.SetSelected(false);
        }
      }
    }
    
    
    
    //PoiBrunnen auswählen
    for (PoiBrunnen tmpPoi : poiBrunnen)
    {
        objXPosition = tmpPoi.GetXPosition() * graphicScale;
        objYPosition = tmpPoi.GetYPosition() * graphicScale;
      
      
      
      if (objXPosition >= (xClick-tolerance) && objXPosition <= (xClick+tolerance) && objYPosition >= (yClick-tolerance) && objYPosition <= (yClick+tolerance))
      {
        if (tmpPoi.GetSelected() == false)
        {
          println("Gefundener Punkt --> X:" + tmpPoi.GetXPosition() + " | Y:" + tmpPoi.GetYPosition() + " --> ");
          printArray(tmpPoi.GetInformation());

          tmpPoi.SetSelected(true);
          infoPanel.SetDisplayData(tmpPoi);
          
        }
        else
        {
          tmpPoi.SetSelected(false);
        }
      
      }
    }
    
    
    
    //PoiKino auswählen
    for (PoiKino tmpPoi : poiKino)
    {
        objXPosition = tmpPoi.GetXPosition() * graphicScale;
        objYPosition = tmpPoi.GetYPosition() * graphicScale;
      
      
      
      if (objXPosition >= (xClick-tolerance) && objXPosition <= (xClick+tolerance) && objYPosition >= (yClick-tolerance) && objYPosition <= (yClick+tolerance))
      {
        if (tmpPoi.GetSelected() == false)
        {
          println("Gefundener Punkt --> X:" + tmpPoi.GetXPosition() + " | Y:" + tmpPoi.GetYPosition() + " --> ");
          printArray(tmpPoi.GetInformation());

          tmpPoi.SetSelected(true);
          infoPanel.SetDisplayData(tmpPoi);
          
        }
        else
        {
          tmpPoi.SetSelected(false);
        }
      
      }
    }
    
    
    
    //PoiInfo auswählen
    for (PoiTouristenInfo tmpPoi : poiTouristInfo)
    {
        objXPosition = tmpPoi.GetXPosition() * graphicScale;
        objYPosition = tmpPoi.GetYPosition() * graphicScale;
      
      
      
      if (objXPosition >= (xClick-tolerance) && objXPosition <= (xClick+tolerance) && objYPosition >= (yClick-tolerance) && objYPosition <= (yClick+tolerance))
      {
        if (tmpPoi.GetSelected() == false)
        {
          println("Gefundener Punkt --> X:" + tmpPoi.GetXPosition() + " | Y:" + tmpPoi.GetYPosition() + " --> ");
          printArray(tmpPoi.GetInformation());

          tmpPoi.SetSelected(true);
          infoPanel.SetDisplayData(tmpPoi);
          
        }
        else
        {
          tmpPoi.SetSelected(false);
        }
      
      }
    }
    
    
    
    //PoiMusikClubs auswählen
    for (PoiMusikClub tmpPoi : poiMusik)
    {
        objXPosition = tmpPoi.GetXPosition() * graphicScale;
        objYPosition = tmpPoi.GetYPosition() * graphicScale;
      
      
      
      if (objXPosition >= (xClick-tolerance) && objXPosition <= (xClick+tolerance) && objYPosition >= (yClick-tolerance) && objYPosition <= (yClick+tolerance))
      {
        if (tmpPoi.GetSelected() == false)
        {
          println("Gefundener Punkt --> X:" + tmpPoi.GetXPosition() + " | Y:" + tmpPoi.GetYPosition() + " --> ");
          printArray(tmpPoi.GetInformation());

          tmpPoi.SetSelected(true);
          infoPanel.SetDisplayData(tmpPoi);
          
        }
        else
        {
          tmpPoi.SetSelected(false);
        }
      
      }
    }
    
    
  }
}


void draw()
{
  //FIXME: MUss hier raus
  //noLoop();
  //TODO: Aufbau des Gui, Infoseite und Zeichenbereich
  
  
  
  background(colorBackground);
  
  //Tool zeichnen
  pushStyle();
  fill(#006cb7);
  strokeWeight(1f);
  rect(0f,0f,toolWidth,toolHeight);
  popStyle();
  
  //TODO: Muss in die Klasse InfoPanel verlegt werden
  //Infobereich zeichnen
  pushStyle();
  fill(colorBackground);
  stroke(colorBlue);
  strokeWeight(1f);
  rect(0f,toolHeight,infoWidth,infoHeight);
  popStyle();
  
  infoPanel.draw();
  
  //Skalierung --> Zoom
  scale(graphicScale);
   
   
   
     //Buslinien darstellen
  for (String tmpBusLine : busLinesAvailable)
  {
    float pointOneX = 0f;
    float pointOneY = 0f;
    float pointTwoX = 0f;
    float pointTwoY = 0f;
    
    
    BusLine[] tmpDrawLine = busLine.get(tmpBusLine);
    
    for (int i=0; i < tmpDrawLine.length; i++)
    {
      tmpDrawLine[i].SetOffset(xOffset,yOffset);
      
     if ((i+1)<tmpDrawLine.length)
     {
       pointOneX = tmpDrawLine[i].GetXPosition();
       pointOneY = tmpDrawLine[i].GetYPosition();
       pointTwoX = tmpDrawLine[i+1].GetXPosition();
       pointTwoY = tmpDrawLine[i+1].GetYPosition();
       
       if ((tmpDrawLine[i].GetXPosition()*graphicScale) <= infoWidth || (tmpDrawLine[i+1].GetXPosition()*graphicScale) <= infoWidth || (tmpDrawLine[i].GetYPosition()*graphicScale) <= toolHeight || (tmpDrawLine[i+1].GetYPosition()*graphicScale) <= toolHeight)
       {
         tmpDrawLine[i].SetVisibility(false);
         tmpDrawLine[i+1].SetVisibility(false);
       }
       else
       {
         tmpDrawLine[i].SetVisibility(true);
         tmpDrawLine[i+1].SetVisibility(true);
       }
       
       
       if (tmpDrawLine[i].GetVisibility() == true && tmpDrawLine[i+1].GetVisibility() == true && tmpDrawLine[i].GetSelected() == true && tmpDrawLine[i+1].GetSelected() == true)
       {
         pushStyle();
         stroke(tmpDrawLine[i].GetHighlightColor());
         line(pointOneX,pointOneY,pointTwoX,pointTwoY);
         popStyle();
       }
       
     }
    }
  }
   
   
   
   
   
   
   
   
   
   
   
   //Stadtmitte einzeichnen
   float MitteX = 54.0924445;
   float MitteY = 12.1286127;
   float MitteXPixel = distConverter.LatitudeToX(MitteX) + xOffset;
   float MitteYPixel = distConverter.LongitudeToY(MitteY) + yOffset;
   pushStyle();
   fill(colorCityCenter);
   noStroke();
   if ((MitteXPixel*graphicScale) > infoWidth && (MitteYPixel*graphicScale) > toolHeight)
   {
     ellipse(MitteXPixel,MitteYPixel,10f,10f);
   }
   popStyle();
  

  //Brunnen darstellen
  for (PoiBrunnen tmpPoi : poiBrunnen)
  {
    tmpPoi.SetOffset(xOffset,yOffset);
    
   if ((tmpPoi.GetXPosition()*graphicScale) <= infoWidth || (tmpPoi.GetYPosition()*graphicScale) <= toolHeight)
   {
     tmpPoi.SetVisibility(false);
   }
   else
   {
     tmpPoi.SetVisibility(true);
   }
   
   
   if (tmpPoi.GetVisibility() == true)
   {
      tmpPoi.draw();
   }
  }
  

  //Kinos darstellen
  for (PoiKino tmpPoi : poiKino)
  {
    tmpPoi.SetOffset(xOffset,yOffset);
    
   if ((tmpPoi.GetXPosition()*graphicScale) <= infoWidth || (tmpPoi.GetYPosition()*graphicScale) <= toolHeight)
   {
     tmpPoi.SetVisibility(false);
   }
   else
   {
     tmpPoi.SetVisibility(true);
   }
   
   
   if (tmpPoi.GetVisibility() == true)
   {
      tmpPoi.draw();
   }
  }

  
  //Musikclubs darstellen
  for (PoiMusikClub tmpPoi : poiMusik)
  {
    tmpPoi.SetOffset(xOffset,yOffset);
    
   if ((tmpPoi.GetXPosition()*graphicScale) <= infoWidth || (tmpPoi.GetYPosition()*graphicScale) <= toolHeight)
   {
     tmpPoi.SetVisibility(false);
   }
   else
   {
     tmpPoi.SetVisibility(true);
   }
   
   
   if (tmpPoi.GetVisibility() == true)
   {
      tmpPoi.draw();
   }
  }
  
  //TouristenInfo darstellen
  for (PoiTouristenInfo tmpPoi : poiTouristInfo)
  {
    tmpPoi.SetOffset(xOffset,yOffset);
    
   if ((tmpPoi.GetXPosition()*graphicScale) <= infoWidth || (tmpPoi.GetYPosition()*graphicScale) <= toolHeight)
   {
     tmpPoi.SetVisibility(false);
   }
   else
   {
     tmpPoi.SetVisibility(true);
   }
   
   
   if (tmpPoi.GetVisibility() == true)
   {
      tmpPoi.draw();
   }
  }
  
  
  //Haltestellen darstellen
  for (BusStation tmpStation : busStation)
  {
    tmpStation.SetOffset(xOffset,yOffset);
    
   if ((tmpStation.GetXPosition()*graphicScale) <= infoWidth || (tmpStation.GetYPosition()*graphicScale) <= toolHeight)
   {
     tmpStation.SetVisibility(false);
   }
   else
   {
     tmpStation.SetVisibility(true);
   }
   
   
   if (tmpStation.GetVisibility() == true)
   {
      tmpStation.draw();
   }
  }
    
  

 
  
}