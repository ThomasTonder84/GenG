
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

//FIXME: Neuer Ausschnitt
//final float MAXLATITUDE = 54.1878; //Norden
//final float MAXLONGITUDE = 12.2161; //Osten
//final float MINLATITUDE = 54.0505; //Süden
//final float MINLONGITUDE = 12.0184; //Westen


//FIXME: Nur zum Testen
//final float MAXLATITUDE = 55.2444; //Norden
//final float MAXLONGITUDE = 13.2958; //Osten
//final float MINLATITUDE = 53.0501; //Süden
//final float MINLONGITUDE = 10.9964; //Westen




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
int toolYOffset;

//Informationen
int infoWidth;
int infoHeight;
int infoXOffset;
int infoYOffset;
InfoPanel infoPanel;

//Daten einlesen
String[] poiFiles;
String busFile;
String busLineFile;
String borderFile;
String parkFile;
String streetFile;
DataReader readData;

//Aufbereitete Daten
ArrayList<HashMap> poiData;
ArrayList<HashMap> busData;
ArrayList<HashMap<String,String>> borderData;
ArrayList<HashMap<String,String>> parkData, streetData;
ArrayList<HashMap<String,String>> busLineData;

//Busdaten
ArrayList<BusStation> busStation;
HashMap<String,BusLine[]> busLine;
ArrayList<String> busLinesAvailable;
ArrayList<HashMap> tmpLine; //Temporäre Verarbeitung

//Stadtgrenze
ArrayList<CityBorder> cityBorder; 

//Stadtfläche
HashMap<String,CityPark[]> cityPark;
HashMap<String,CityStreet[]> cityStreet;


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
color colorBackground;
color colorCityCenter;
color colorRed;
color colorBlue;
color colorWhite;
color colorGreen;
color colorBrown;
color colorPurple;
color colorLightBlue;
color colorGray;

//Zoom
float graphicScale = 1.0f;
int zoomXOrigin;
int zoomYOrigin;
int xOffset;
int yOffset;
int xOffsetPrev;
int yOffsetPrev;


//GUI
ControlP5 cp5;
Button guiHelpButton;
Button guiFilterStations;
Button guiFilterKinos;
Button guiFilterBrunnen;
Button guiFilterMusik;
Button guiFilterInfo;




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
  infoXOffset = 10;
  
  //Höhen
  toolHeight =  100;
  graphicHeight = SKETCHHEIGHT - toolHeight;
  infoHeight = SKETCHHEIGHT;
  graphicYOffset = toolHeight;
  infoYOffset = toolHeight;
  toolYOffset = infoXOffset;
  
  //Init des Distance Konverters
  distConverter = new DistanceConverter(MAXLATITUDE, MINLONGITUDE, MINLATITUDE, MAXLONGITUDE, graphicWidth, graphicHeight, graphicXOffset, graphicYOffset);
  
  //Init Farben
  colorRed = color(#d81920);
  colorBlue = color(#006cb7);
  colorLightBlue = color(#19a1ff);
  colorWhite = color(#f3f3f3);
  //colorGreen = color(#008B25);
  colorGreen = color(#028B26); //19D84B
  colorBrown = color(#B76C00);
  colorPurple = color(#7C30DE);
  colorGray = color(#A69696);
  colorBackground = colorWhite;
  colorCityCenter = colorRed;
  
  //Init InfoPanel
  infoPanel = new InfoPanel(0,toolHeight,(infoWidth - infoXOffset),infoHeight,colorBlue);
  
  //Init Poi Files
  poiFiles = new String[]{"brunnen.csv","kinos.csv","musikclubs.csv","touristeninformation.csv"};
  busFile = "haltestellen.csv";
  borderFile = "gemeindeflaeche.json"; 
  parkFile = "parkanlagen.json";
  streetFile = "strassen.csv"; 
  busLineFile = "stadtbuslinien.csv";
  
  //Init Poi Types
  poiBrunnen = new ArrayList<PoiBrunnen>();
  poiKino = new ArrayList<PoiKino>();
  poiMusik = new ArrayList<PoiMusikClub>();
  poiTouristInfo = new ArrayList<PoiTouristenInfo>();
  
  //Init CityBorder
  cityBorder = new ArrayList<CityBorder>();
  
  //Init Parks
  cityPark = new HashMap<String,CityPark[]>();
  
  //Init Streets
  cityStreet = new HashMap<String,CityStreet[]>();
  
  //Init Bus Types
  busLinesAvailable = new ArrayList<String>();
  busLine = new HashMap<String,BusLine[]>();
  busStation = new ArrayList<BusStation>();
  
  //Daten einlesen
  readData = new DataReader();
  //readData.SetFolder("poi\\"); //FIXME: Auskommentiert
  
  //Menü
  cp5 = new ControlP5(this);
  
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
  
  
  
  //Buslinien auslesen
  //readData.SetFolder("\\");
  busData = readData.getDataBus(busFile);
  busData.remove("Schulschwimmen");
  busData.remove("");
  busLinesAvailable = readData.getAvailableBusLines();
  
  //Stadtgrenzen einlesen
  borderData = readData.getCityBorder(borderFile);
  
  //Koordinaten der Grenzen konvertieren
  for (HashMap<String,String> tmpPoint : borderData)
  {
      tmpX = Float.parseFloat(tmpPoint.get("latitude").toString());
      tmpY = Float.parseFloat(tmpPoint.get("longitude").toString());
      tmpXPixel = distConverter.LatitudeToX(tmpX);
      tmpYPixel = distConverter.LongitudeToY(tmpY);
  
      //Neues Grenzelement erzeugen
      cityBorder.add(new CityBorder(tmpXPixel,tmpYPixel,tmpX,tmpY,2f,tmpPoint.get("id")));
  }
  
 
  
  ////Aufteilen nach Buslinien
  //sortStations = new SplitBusStations(busData);
  
  ////Aufbereiten der Buslinien  
  //for (String tmpBusLine : busLinesAvailable)
  //{
  //  int idCount = 0;
  //  tmpLine = sortStations.Split(tmpBusLine);  
  //  int lineSize = tmpLine.size();
  //  BusLine[] tmpLineBuffer = new BusLine[lineSize];
      
  //  //Konvertieren der Geo zu Pixel Koordinaten
  //  for (HashMap tmpStation : tmpLine)
  //  {     
  //    idCount++;
      
  //    tmpX = Float.parseFloat(tmpStation.get("latitude").toString());
  //    tmpY = Float.parseFloat(tmpStation.get("longitude").toString());
  //    tmpXPixel = distConverter.LatitudeToX(tmpX);
  //    tmpYPixel = distConverter.LongitudeToY(tmpY);
      
  //    tmpLineBuffer[idCount-1] = new BusLine(tmpXPixel,tmpYPixel,tmpX,tmpY,10f,tmpBusLine,idCount);
  //  }

  //  //Erstellen des Buslinien Objekts
  //  busLine.put(tmpBusLine,tmpLineBuffer);
  //}
  
  
  //Stationen einlesen
  int busIndex = 0;
  for (HashMap tmpStation : busData)
  {
      tmpX = Float.parseFloat(tmpStation.get("latitude").toString());
      tmpY = Float.parseFloat(tmpStation.get("longitude").toString());
      tmpXPixel = distConverter.LatitudeToX(tmpX);
      tmpYPixel = distConverter.LongitudeToY(tmpY);
  
      busStation.add(new BusStation(tmpXPixel,tmpYPixel,tmpX,tmpY,6f,tmpStation.get("linien").toString()));
      busStation.get(busIndex).SetInformation(tmpStation);
      busIndex++;
  }
  
  
  //Straßen einlesen
  streetData = readData.getCityStreets(streetFile);
  
  int streetId = 0;
  
  for (HashMap<String,String> tmpData : streetData)
  {
    String tmpBezeichnung = tmpData.get("bezeichnung");
    String[] tmpSplitCoords = tmpData.get("coords").split(";");
    CityStreet[] tmpStreetObj;
    //CityStreet tmpStreetObj;
    
    for (String tmpStreet : tmpSplitCoords)
    {
      //TODO
      //Aufsplitten nach ,
      //In foreach abarbeiten -->
      //Koordinaten aufarbeiten 
      //konvertieren
      //getrennte Koordinaten
      
      //FIXME: Debugging
      //println("Straßen split ; --> " + tmpStreet);
      String[] tmpSubSplit = tmpStreet.split(",");
      tmpStreetObj = new CityStreet[tmpSubSplit.length];
      int streetIndex = 0;
      streetId++;
      
      //TODO: Hier beginShape
      for (String tmpSubStreet : tmpSubSplit)
      {
        String[] tmpSubSplitCoords = tmpSubStreet.split(" ");
        tmpX = Float.parseFloat(tmpSubSplitCoords[1]);
        tmpY = Float.parseFloat(tmpSubSplitCoords[0]);
        tmpXPixel = distConverter.LatitudeToX(tmpX);
        tmpYPixel = distConverter.LongitudeToY(tmpY);
        
        //public CityStreet(float xPositionPixel, float yPositionPixel, float latitude, float longitude, float Weight, String streetName)
        tmpStreetObj[streetIndex] = new CityStreet(tmpXPixel,tmpYPixel,tmpX,tmpY,1.25f,tmpBezeichnung);
        streetIndex++;
        //println("Straßen split , --> " + tmpSubStreet); 
        //println("Straßen split Leer --> " );
        //printArray(tmpSubSplitCoords);
      }
      
      cityStreet.put(String.valueOf(streetId), tmpStreetObj);
    }
  }
  
  
  
  //Parkdaten einlesen
  parkData = readData.getCityParks(parkFile);
  
  int parkId = 0;
  for (HashMap<String,String> tmpData : parkData)
  {
    String tmpBezeichnung = tmpData.get("bezeichnung");
    String[] tmpSplitCoords = tmpData.get("coords").split(";");
    CityPark[] tmpParkObj = new CityPark[tmpSplitCoords.length]; 
    int coordIndex = 0;
    parkId++;
    
    for (String tmpParkCoord : tmpSplitCoords)
    {
      String[] tmpParkSplit = tmpParkCoord.split(",");
      //TODO:
      //Geokoordinaten korrekt extrahieren
      //Pixelkoord konvertieren
      //Korrektes Objekt erzeugen
      tmpX = Float.parseFloat(tmpParkSplit[1]);
      tmpY = Float.parseFloat(tmpParkSplit[0]);
      
      tmpXPixel = distConverter.LatitudeToX(tmpX);
      tmpYPixel = distConverter.LongitudeToY(tmpY);
      
      tmpParkObj[coordIndex] = new CityPark(tmpXPixel, tmpYPixel, tmpX, tmpY, 2f);
      
      coordIndex++;
    }
    
    cityPark.put(String.valueOf(parkId),tmpParkObj);
    
    //public CityPark(float xPositionPixel, float yPositionPixel, float latitude, float longitude, float Weight)
    //cityPark.add(new CityPark(float xPositionPixel, float yPositionPixel, float latitude, float longitude, float Weight));
    
    //CityPark[] tmpObj = new CityPark[tmpSplitCoords.length];
    //tmpObj = cityPark.get(String.valueOf(parkId));
    
    //FIXME: Debugging
    //printArray(tmpObj);
  }
  
  //TODO
  //Buslinien einlesen
  busLineData = readData.getCityBusLines(busLineFile);
  
  
  
    //Aufteilen nach Buslinien
  //sortStations = new SplitBusStations(busData);
  int indexCount = 0;
  //Aufbereiten der Buslinien  
  for (HashMap<String,String> tmpBusLine : busLineData)
  {
    String tmpLinien = tmpBusLine.get("linien");
    String tmpId = tmpBusLine.get("id");
    String tmpBusLineCoords = tmpBusLine.get("coords");
    String[] tmpBusLineSplit = tmpBusLineCoords.split(",");
    BusLine[] tmpLineBuffer = new BusLine[tmpBusLineSplit.length];
    int idCount = 0;
      
    //Konvertieren der Geo zu Pixel Koordinaten
    for (String tmpStation : tmpBusLineSplit)
    {     
      String[] tmpSplit = tmpStation.split(" "); 
      
      tmpX = Float.parseFloat(tmpSplit[1]);
      tmpY = Float.parseFloat(tmpSplit[0]);
      tmpXPixel = distConverter.LatitudeToX(tmpX);
      tmpYPixel = distConverter.LongitudeToY(tmpY);
      
      tmpLineBuffer[idCount] = new BusLine(tmpXPixel,tmpYPixel,tmpX,tmpY,10f,tmpLinien,Integer.parseInt(tmpId));
      
      idCount++;
    }

    //Erstellen des Buslinien Objekts
    busLine.put(String.valueOf(indexCount),tmpLineBuffer);
    
    indexCount++;
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  setupGUI();
  
  //FIXME: Debugging
  println ("<<<<<<<<<<<<<XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX GEO TESTS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX>>>>>>>>>>>>>>>>>>>>>");
  println ("Origins | X --> " + distConverter.LatitudeToX(MAXLATITUDE) + " | Y --> " + distConverter.LongitudeToY(MINLONGITUDE) );
  println ("Umrechnung Latitude --> " + distConverter.LatitudeToX(MINLATITUDE) + " | Longitude --> " + distConverter.LongitudeToY(MAXLONGITUDE));
  //println ("Bus --> " + busData.get(23));

}

void DisplayHeader()
{
  int Offset = 20;
  String headText = "Reiseplanung Rostock";
  
  pushStyle();
  fill(colorWhite);
  textSize(40);
  text(headText,(toolWidth-Offset-textWidth(headText)),(toolHeight/2) + Offset);
  popStyle();
}

void setupGUI()
{
  cp5.addButton("showHelp")
     
     .setCaptionLabel("Anleitung")
     .setColorActive(colorBlue)
     .setColorLabel(colorWhite)
     .setColorCaptionLabel(colorBlue)
     .setSize(100,20)
     .setColorForeground(colorWhite)
     .setColorBackground(colorWhite)
     .setPosition(20,toolHeight-40);
}

void showHelp()
{
  infoPanel.SetHelpActive(true);
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
  //Offset berechnen und invertieren
  if (mouseX > infoWidth && mouseY > toolHeight)
  {
    xOffset = (zoomXOrigin - mouseX) * (-1) + xOffsetPrev;
    yOffset = (zoomYOrigin - mouseY) * (-1) + yOffsetPrev;
  }  
}


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
    infoPanel.SetHelpActive(false);  
    //Buslinien
    //for (String tmpLine : busLinesAvailable)
    //{
    //  for (BusLine tmpBusLine : busLine.get(tmpLine))
    //  {
    //    tmpBusLine.SetSelected(false);
    //  }
    //}
    

    for (String tmpBusId : busLine.keySet())
    {
      BusLine[] tmpBus = busLine.get(tmpBusId); 
      
      for (BusLine tmpBusLine : tmpBus)
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
            if (tmpLine.equals("") == false)
            {
              for (String tmpBus : busLine.keySet())
              {
                BusLine[] tmpBusLine = busLine.get(tmpBus);
                //println(busLine.keySet());
                for (BusLine curLine : tmpBusLine)
                {
                  if (curLine.GetLineNumber().contains(tmpLine))
                  {
                    curLine.SetSelected(true);
                  }
                }
              }
            }
          }
          
          //for (String tmpLine : tmpStation.GetBusLines())
          //{
          //  if (tmpLine.equals("") == false)
          //  {
          //    for (BusLine tmpBusLine : busLine.get(tmpLine))
          //    {
          //      tmpBusLine.SetSelected(true);
          //    }
          //  }
          //}
          
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

void mouseHover()
{
  float xPosition = 0;
  float yPosition = 0;
  
  
  for (BusStation tmpStation : busStation)
  {
    //xPosition = tmpStation.ge
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
  fill(colorBlue);
  strokeWeight(1f);
  stroke(colorBlue);
  rect(0f,0f,toolWidth,(toolHeight - toolYOffset));
  DisplayHeader();
  
  //Infobereich zeichnen
  fill(colorBackground);
  rect(0f,(toolHeight - toolYOffset),(infoWidth-infoXOffset),infoHeight);
  popStyle();
  infoPanel.draw();
  
  pushMatrix();
  //Skalierung --> Zoom
  scale(graphicScale);
  
  
  
  
  
   //Stadtgrenze einzeichnen
  for (int i=0; i < cityBorder.size(); i++)
  {
    cityBorder.get(i).SetOffset(xOffset,yOffset);
    
   if ((i+1) < cityBorder.size())
   {
     cityBorder.get(i+1).SetOffset(xOffset,yOffset);
     float pointOneX = cityBorder.get(i).GetXPosition();
     float pointOneY = cityBorder.get(i).GetYPosition();
     float pointTwoX = cityBorder.get(i+1).GetXPosition();
     float pointTwoY = cityBorder.get(i+1).GetYPosition();
     
     if ((pointOneX*graphicScale) <= infoWidth || (pointTwoX*graphicScale) <= infoWidth || (pointOneY*graphicScale) <= toolHeight || (pointTwoY*graphicScale) <= toolHeight)
     {
      cityBorder.get(i).SetVisibility(false);
      cityBorder.get(i+1).SetVisibility(false);
     }
     else
     {
      cityBorder.get(i).SetVisibility(true);
      cityBorder.get(i+1).SetVisibility(true);
     }
     
     
     if (cityBorder.get(i).GetVisibility() == true && cityBorder.get(i+1).GetVisibility() == true)
     {
       pushStyle();
       stroke(cityBorder.get(i).GetHighlightColor());
       strokeWeight(cityBorder.get(i).GetLineWeight());
       line(pointOneX,pointOneY,pointTwoX,pointTwoY);
       popStyle();
     }
     
     //FIXME: Debugging
     //println("Anzahl Punkte in if --> " + i);   
     
   }
   
   //println("Anzahl Punkte nach if --> " + i);
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
     //Parkflächen darstellen
      //Buslinien darstellen
  for (String tmpPark : cityPark.keySet())
  {
    float pointOneX = 0f;
    float pointOneY = 0f;
    float pointTwoX = 0f;
    float pointTwoY = 0f;
    
    
    CityPark[] tmpDrawLine = cityPark.get(tmpPark);
    
    PShape s = createShape();
    s.beginShape();
    
    for (int i=0; i < tmpDrawLine.length; i++)
    {
      tmpDrawLine[i].SetOffset(xOffset,yOffset);
      
       pointOneX = tmpDrawLine[i].GetXPosition();
       pointOneY = tmpDrawLine[i].GetYPosition();
      
      
      /*
     if ((i+1)<tmpDrawLine.length)
     {
       pointOneX = tmpDrawLine[i].GetXPosition();
       pointOneY = tmpDrawLine[i].GetYPosition();
       pointTwoX = tmpDrawLine[i+1].GetXPosition();
       pointTwoY = tmpDrawLine[i+1].GetYPosition();
       */
       //if ((tmpDrawLine[i].GetXPosition()*graphicScale) <= infoWidth || (tmpDrawLine[i+1].GetXPosition()*graphicScale) <= infoWidth || (tmpDrawLine[i].GetYPosition()*graphicScale) <= toolHeight || (tmpDrawLine[i+1].GetYPosition()*graphicScale) <= toolHeight)
       if ((tmpDrawLine[i].GetXPosition()*graphicScale) <= infoWidth || (tmpDrawLine[i].GetYPosition()*graphicScale) <= toolHeight)
       {
         tmpDrawLine[i].SetVisibility(false);
         //tmpDrawLine[i+1].SetVisibility(false);
       }
       else
       {
         tmpDrawLine[i].SetVisibility(true);
         //tmpDrawLine[i+1].SetVisibility(true);
       }
       
       
       if (tmpDrawLine[i].GetVisibility() == true)
       {
         //pushStyle();
         //stroke(tmpDrawLine[i].GetColor());
         //line(pointOneX,pointOneY,pointTwoX,pointTwoY);
         //popStyle();
         s.vertex(pointOneX,pointOneY);
         //TODO: Shapes erstellen
      
       }
       
     //}*/
    }
    s.noStroke();
    s.fill(colorGreen);
    s.endShape();
    shape(s);
    
    //FIXME: Debugging
    //println("Position Shape X --> " + s.X + " | Shape Y --> " + s.Y);
  }
  
  
  
  
  //Straßen darstellen
    for (String tmpStreet : cityStreet.keySet())
  {
   float pointOneX = 0f;
   float pointOneY = 0f;
   float pointTwoX = 0f;
   float pointTwoY = 0f;
    
    
   CityStreet[] tmpDrawLine = cityStreet.get(tmpStreet);
    
   for (int i=0; i < tmpDrawLine.length; i++)
   {
     tmpDrawLine[i].SetOffset(xOffset,yOffset);
      
    if ((i+1)<tmpDrawLine.length)
    {
      tmpDrawLine[i+1].SetOffset(xOffset,yOffset);
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
       
       
      if (tmpDrawLine[i].GetVisibility() == true && tmpDrawLine[i+1].GetVisibility() == true)
      {
        pushStyle();
        strokeWeight(tmpDrawLine[i].GetLineWeight());
        stroke(tmpDrawLine[i].GetColor());
        line(pointOneX,pointOneY,pointTwoX,pointTwoY);
        popStyle();
      }
       
    }
   }
  }
  
  
  
  
  
  
  
  
  
  
  
   
     //Buslinien darstellen
  //for (String tmpStreet : cityStreet.keySet())
  //{
  // float pointOneX = 0f;
  // float pointOneY = 0f;
  // float pointTwoX = 0f;
  // float pointTwoY = 0f;
    
    
  // CityStreet[] tmpDrawLine = cityStreet.get(tmpStreet);
    
  // for (int i=0; i < tmpDrawLine.length; i++)
  // {
  //   tmpDrawLine[i].SetOffset(xOffset,yOffset);
      
  //  if ((i+1)<tmpDrawLine.length)
  //  {
  //    pointOneX = tmpDrawLine[i].GetXPosition();
  //    pointOneY = tmpDrawLine[i].GetYPosition();
  //    pointTwoX = tmpDrawLine[i+1].GetXPosition();
  //    pointTwoY = tmpDrawLine[i+1].GetYPosition();
       
  //    if ((tmpDrawLine[i].GetXPosition()*graphicScale) <= infoWidth || (tmpDrawLine[i+1].GetXPosition()*graphicScale) <= infoWidth || (tmpDrawLine[i].GetYPosition()*graphicScale) <= toolHeight || (tmpDrawLine[i+1].GetYPosition()*graphicScale) <= toolHeight)
  //    {
  //      tmpDrawLine[i].SetVisibility(false);
  //      tmpDrawLine[i+1].SetVisibility(false);
  //    }
  //    else
  //    {
  //      tmpDrawLine[i].SetVisibility(true);
  //      tmpDrawLine[i+1].SetVisibility(true);
  //    }
       
       
  //    if (tmpDrawLine[i].GetVisibility() == true && tmpDrawLine[i+1].GetVisibility() == true)
  //    {
  //      pushStyle();
  //      strokeWeight(tmpDrawLine[i].GetLineWeight());
  //      stroke(tmpDrawLine[i].GetColor());
  //      line(pointOneX,pointOneY,pointTwoX,pointTwoY);
  //      popStyle();
  //    }
       
  //  }
  // }
  //}
   
   
   
   
     //Buslinien darstellen
  for (String tmpBusLine : busLine.keySet())
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
       tmpDrawLine[i+1].SetOffset(xOffset,yOffset);
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
       
       //TODO: Wieder einkommentieren
       if (tmpDrawLine[i].GetVisibility() == true && tmpDrawLine[i+1].GetVisibility() == true && tmpDrawLine[i].GetSelected() == true && tmpDrawLine[i+1].GetSelected() == true)
       {
         pushStyle();
         stroke(tmpDrawLine[i].GetColor()); //TODO: Auf normale Farbe ändern
         strokeWeight(2f);
         line(pointOneX,pointOneY,pointTwoX,pointTwoY);
         popStyle();
       }
       
     }
    }
  }
   
   
   
   
   
   
   
   

   
   
   
   //Buslinien darstellen
 /*for (String tmpBusLine : busLinesAvailable)
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
       tmpDrawLine[i+1].SetOffset(xOffset,yOffset);
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
  }*/
   
   
   
 
   
   
   
   
   
   
   
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
    
  
popMatrix();
 
  
}