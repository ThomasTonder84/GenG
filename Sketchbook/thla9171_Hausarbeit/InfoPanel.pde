
public class InfoPanel
{
  //TODO: 
  //Erstellen des Infopanels
  //Formatieren und Anzeigen der übergebenen Infos
  //Prop bool displayInfo 
  //Width und Height
  //x und y Offset
  //color Headline
  //color text
  
  //Erstellen und Anzeige der Legende
  //Symbole festlegen
  //Haltestelle Kreis blau
  //Brunnen Quadrat violett
  //INfo blaues Dünnes Rechteck
  //Kino Dreieck braun
  //Musikclub umgedrehtes Dreieck grün
  
  private int startXPosition;
  private int startYPosition;
  private int xWidth;
  private int yHeight;
  private int yLegendStart;
  
  //Trenner
  private int sepStartX;
  private int sepStartY;
  private int sepThick;
  private color sepColor;
  
  //Format
  private int Offset;
  private final int headSize = 16;
  private final int headSubSize = 12;
  private final int textSize = 14;
  
  private float tmpPosXHead;
  private float tmpPosXText;
  private float tmpPosYHead;
  private float tmpPosYText;
  
  //Anzeigetyp
  private Boolean isBusStation;
  private Boolean isBrunnen;
  private Boolean isKino;
  private Boolean isInfo;
  private Boolean isMusik;
  private Boolean isHelpActive;
  
  //Anzeigedaten
  private BusStation busStation;
  private PoiKino poiKino;
  private PoiBrunnen poiBrunnen;
  private PoiMusikClub poiMusik;
  private PoiTouristenInfo poiTouristInfo;
    
  public InfoPanel(int startX, int startY, int xWidth, int yHeight, color sepColor)
  {
    this.startXPosition = startX;
    this.startYPosition = startY;
    this.xWidth = xWidth;
    this.yHeight = yHeight;
    
    //Init Anzeigetypen
    this.isBusStation = false;
    this.isBrunnen = false;
    this.isKino = false;
    this.isInfo = false;
    this.isMusik = false;
    this.isHelpActive = true;
    
    //Aufteilen des Infobereichs
    this.yLegendStart = this.yHeight - (this.yHeight / 100 * 30);
    
    //Trennzeichen
    this.sepStartX = 0;
    this.sepStartY = this.yLegendStart;
    this.sepThick = 5;
    
    //Farbe zuweisen
    this.sepColor = sepColor;
    
    this.Offset = 15;
    
    
    
    this.tmpPosXHead = startXPosition  + Offset;
    this.tmpPosXText = tmpPosXHead + Offset;
    this.tmpPosYHead = startYPosition + (2 * Offset);
    this.tmpPosYText = tmpPosYHead; 
  }
  
  private void DisplayHeader()
  {
    pushStyle();
    fill(sepColor);
    textSize(headSize);
    text("Informationen zur Auswahl",tmpPosXHead,tmpPosYHead);
    popStyle();
  }
  
  public void DisplayHelp()
  {
    float PosX = tmpPosXHead;
    float PosY = tmpPosYText;
    
    pushStyle();
    fill(sepColor);
    textSize(headSize);
    text("Anleitung zur Bedienung",tmpPosXHead,tmpPosYHead);
    
    
     PosY += (2* Offset);
     textSize(textSize);
     text("Click",PosX,PosY,xWidth,PosY);
        
     PosY += (1.5f* Offset);
     textSize(headSubSize);
     text("Anzeige von Informationen des Objekts (siehe Legende)",PosX,PosY,xWidth-Offset,PosY);
     
     PosY += (3* Offset);
     textSize(textSize);
     text("Mausrad",PosX,PosY,xWidth,PosY);
        
     PosY += (1.5f* Offset);
     textSize(headSubSize);
     text("Karte herein oder heraus zoomen",PosX,PosY,xWidth-Offset,PosY);
     
    PosY += (2* Offset);
     textSize(textSize);
     text("Maustaste gedrückt halten",PosX,PosY,xWidth,PosY);
        
     PosY += (1.5f* Offset);
     textSize(headSubSize);
     text("Die Karte kann nach rechts, links, oben und unten verschoben werden",PosX,PosY,xWidth-Offset,PosY);
     
        PosY += (3* Offset);
     textSize(textSize);
     text("Ziel der Anwendung",PosX,PosY,xWidth,PosY);
        
     PosY += (1.5f* Offset);
     textSize(headSubSize);
     text("Wird eine Haltestelle angeklickt zeigt die Anwendung entlang aller abfahrenden Buslinien die Erreichbarkeit ...",PosX,PosY,xWidth-Offset,PosY);
     
     popStyle();
  }
  
  private void SetHelpActive(Boolean isActive)
  {
    this.isHelpActive = isActive;
  }
  
  private void DisplayLegend()
  {
    //Maße
    int objWidth = 10;
    int objHeight = 10;
    
    //Position
    float tmpPosXSign = sepStartX  + (2 * Offset);
    float tmpPosXText = tmpPosXSign + Offset;
    float tmpPosY = sepStartY;
    
    //FIXME: Änderungen vorgenommen
    textSize(headSubSize);
    
    pushStyle();
    fill(sepColor); //FIXME: Änderung
    noStroke();    //FIXME: Änderung
    rect(sepStartX,tmpPosY,xWidth,sepThick);
    popStyle();
    
    pushStyle();
    tmpPosY += 2 * Offset;
    stroke(sepColor); //FIXME: Änderung
    //Bushaltestellen
    ellipse((tmpPosXSign + (objWidth/2)),tmpPosY,objWidth,objHeight);
    tmpPosY += objHeight/2;
    fill(sepColor); //FIXME: Änderung
    text("Haltestelle Stadtbus",tmpPosXText,tmpPosY);
    
    tmpPosY += Offset;
    noStroke(); //FIXME: Änderung
    
    //Brunnen
    pushStyle();
    fill(colorBrown);
    rect(tmpPosXSign,tmpPosY,objWidth,objHeight);
    popStyle();
    tmpPosY += objHeight;
    text("Brunnen",tmpPosXText,tmpPosY);
    
    tmpPosY += Offset;
    pushStyle();
    //Touristeninformation
    fill(colorGreen);
    rect(tmpPosXSign,tmpPosY,5,objHeight);
    popStyle();
    tmpPosY += objHeight;
    text("Touristeninformation",tmpPosXText,tmpPosY);
    
    tmpPosY += Offset;
    
    //Kinos
    pushStyle();
    fill(colorLightBlue);
    triangle(tmpPosXSign+(objWidth/2),tmpPosY - (objHeight/2),tmpPosXSign-(objWidth/2),tmpPosY + objHeight,tmpPosXSign+(objWidth),tmpPosY + objHeight);
    popStyle();
    tmpPosY += objHeight;
    text("Kinos",tmpPosXText,tmpPosY);
    
    tmpPosY += Offset;
    
    //Musikclubs
    pushStyle();
    fill(colorPurple);
    triangle(tmpPosXSign-(objWidth/2),tmpPosY - (objHeight/2),tmpPosXSign+objWidth,tmpPosY - (objHeight/2),tmpPosXSign,tmpPosY + objHeight);
    popStyle();
    tmpPosY += objHeight;
    text("Musikclubs",tmpPosXText,tmpPosY);
    
    tmpPosY += Offset;
    
    //Buslinien
    stroke(colorBlue);
    strokeWeight(3f);
    line(tmpPosXSign,(tmpPosY + (objHeight/2)), tmpPosXSign+objWidth, (tmpPosY + (objHeight/2)));
    tmpPosY += objHeight;
    text("Buslinie",tmpPosXText,tmpPosY);
    
    tmpPosY += Offset;
    
    //Straßen
    stroke(colorGray);
    line(tmpPosXSign,(tmpPosY + (objHeight/2)), tmpPosXSign+objWidth, (tmpPosY + (objHeight/2)));
    tmpPosY += objHeight;
    text("Straße",tmpPosXText,tmpPosY);
    
    
    tmpPosY += Offset;
    
    //Stadtmitte
    noStroke();
    fill(colorCityCenter);
    ellipse((tmpPosXSign + (objWidth/2)),tmpPosY,objWidth,objHeight);
    tmpPosY += objHeight/2;
    fill(sepColor);
    text("Stadtmitte",tmpPosXText,tmpPosY);
    
    
    textSize(11);
     tmpPosY +=  2 * Offset;
     text("Genutzte Datensätze: http://www.opendata-hro.de",tmpPosXSign,tmpPosY,xWidth-Offset,tmpPosY);
    
    popStyle();
  }
  
  public void SetInfoDisplay(Boolean isVisible)
  {
    //Init Anzeigetypen
    this.isBusStation = isVisible;
    this.isBrunnen = isVisible;
    this.isKino = isVisible;
    this.isInfo = isVisible;
    this.isMusik = isVisible;
  }
  
  //Setzen der Anzeigeart
  public void SetDisplayData(BusStation busStation)
  {
    this.busStation = busStation;
    isBusStation = true;
  }
  
  public void SetDisplayData(PoiBrunnen poiBrunnen)
  {
    this.poiBrunnen = poiBrunnen;
    isBrunnen = true;
  }
  
  public void SetDisplayData(PoiKino poiKino)
  {
    this.poiKino = poiKino;
    isKino = true;
  }
  
  public void SetDisplayData(PoiMusikClub poiMusik)
  {
    this.poiMusik = poiMusik;
    isMusik = true;
  }

  public void SetDisplayData(PoiTouristenInfo poiTouristInfo)
  {
    this.poiTouristInfo = poiTouristInfo;
    isInfo = true;
  }
  
  
  //Anzeigedaten verarbeiten
  private void DisplayBusStationInfo()
  {
    //Position
    float PosX = tmpPosXText;
    float PosY = tmpPosYText;
    String[] busLineArray = busStation.GetBusLines();
    String busLines = "";
    HashMap<String,String> stationInfo = busStation.GetInformation();
    
    pushStyle();
    fill(sepColor);
    
    for (int i=0; i < busLineArray.length; i++)
    {
      busLines += busLineArray[i];
      
      if ((i+1) != busLineArray.length)
      {
        busLines += ", ";
      }
    }
    
    PosY += (2* Offset);
    textSize(headSubSize);
    text("Haltende Linien",tmpPosXText,PosY,xWidth,PosY);
      
    PosY += (1* Offset);
    textSize(textSize);
    text(busLines,tmpPosXText,PosY,xWidth,PosY);
    
    
   for (String tmpKey : stationInfo.keySet())
   {
     String tmpInfo = stationInfo.get(tmpKey); 
     String tmpUpper = tmpKey.substring(0,1).toUpperCase();
     tmpUpper += tmpKey.substring(1);
     
     if (tmpInfo.equals("") == false)
     {
       PosY += (2* Offset);
       textSize(headSubSize);
       text(tmpUpper,tmpPosXText,PosY,xWidth,PosY);
        
       PosY += (1* Offset);
       textSize(textSize);
       text(tmpInfo,tmpPosXText,PosY,xWidth,PosY);
     }
   }
    
    popStyle();
  }
  
  private void DisplayPoiBrunnenInfo()
  {    
    //Position
    float PosX = tmpPosXText;
    float PosY = tmpPosYText;
    
    HashMap<String,String> stationInfo = poiBrunnen.GetInformation();
    
    pushStyle();
    fill(sepColor);
    
    
    
   for (String tmpKey : stationInfo.keySet())
   {
     String tmpInfo = stationInfo.get(tmpKey); 
     String tmpUpper = tmpKey.substring(0,1).toUpperCase();
     tmpUpper += tmpKey.substring(1);
     
     if (tmpInfo.equals("") == false)
     {
       PosY += (2* Offset);
       textSize(headSubSize);
       text(tmpUpper,tmpPosXText,PosY,xWidth,PosY);
        
       PosY += (1* Offset);
       textSize(textSize);
       text(tmpInfo,tmpPosXText,PosY,xWidth,PosY);
     }
   }
  
    
    popStyle();
  }
  
  
  private void DisplayPoiKinoInfo()
  {    
    //Position
    float PosX = tmpPosXText;
    float PosY = tmpPosYText;
    
    HashMap<String,String> stationInfo = poiKino.GetInformation();
    
    pushStyle();
    fill(sepColor);
    
    
    
    for (String tmpKey : stationInfo.keySet())
   {
     String tmpInfo = stationInfo.get(tmpKey); 
     String tmpUpper = tmpKey.substring(0,1).toUpperCase();
     tmpUpper += tmpKey.substring(1);
     
     if (tmpInfo.equals("") == false && tmpKey != "website")
     {
       PosY += (2* Offset);
       textSize(headSubSize);
       text(tmpUpper,tmpPosXText,PosY,xWidth,PosY);
        
       PosY += (1* Offset);
       textSize(textSize);
       text(tmpInfo,tmpPosXText,PosY,xWidth,PosY);
     }
   }
   
   
    if (stationInfo.get("website").equals("") == false)
    {
         PosY += (2* Offset);
       textSize(headSubSize);
       text("Website",tmpPosXText,PosY,xWidth,PosY);
        
       PosY += (1* Offset);
       textSize(textSize);
       text(stationInfo.get("website"),tmpPosXText,PosY,xWidth-(3*Offset),PosY);
    }
  
    
    popStyle();
  }
  
  
  private void DisplayPoiMusikInfo()
  {    
    //Position
    float PosX = tmpPosXText;
    float PosY = tmpPosYText;
    
    HashMap<String,String> stationInfo = poiMusik.GetInformation();
    
    pushStyle();
    fill(sepColor);
    
    
    
   for (String tmpKey : stationInfo.keySet())
   {
     String tmpInfo = stationInfo.get(tmpKey); 
     String tmpUpper = tmpKey.substring(0,1).toUpperCase();
     tmpUpper += tmpKey.substring(1);
     
     if (tmpInfo.equals("") == false && tmpKey != "website")
     {
       PosY += (2* Offset);
       textSize(headSubSize);
       text(tmpUpper,tmpPosXText,PosY,xWidth,PosY);
        
       PosY += (1* Offset);
       textSize(textSize);
       text(tmpInfo,tmpPosXText,PosY,xWidth,PosY);
     }
   }
   
     if (stationInfo.get("website").equals("") == false)
    {
         PosY += (2* Offset);
       textSize(headSubSize);
       text("Website",tmpPosXText,PosY,xWidth,PosY);
        
       PosY += (1* Offset);
       textSize(textSize);
       text(stationInfo.get("website"),tmpPosXText,PosY,xWidth-(3*Offset),PosY);
    }

    popStyle();
  }
  
  
  private void DisplayPoiTouristInfo()
  {    
    //Position
    float PosX = tmpPosXText;
    float PosY = tmpPosYText;
    
    HashMap<String,String> stationInfo = poiTouristInfo.GetInformation();
    
    pushStyle();
    fill(sepColor);
    
    
    
    for (String tmpKey : stationInfo.keySet())
   {
     String tmpInfo = stationInfo.get(tmpKey); 
     String tmpUpper = tmpKey.substring(0,1).toUpperCase();
     tmpUpper += tmpKey.substring(1);
     
     if (tmpInfo.equals("") == false && tmpKey != "website")
     {
       PosY += (2* Offset);
       textSize(headSubSize);
       text(tmpUpper,tmpPosXText,PosY,xWidth,PosY);
        
       PosY += (1* Offset);
       textSize(textSize);
       text(tmpInfo,tmpPosXText,PosY,xWidth,PosY);
     }
   }
  
  if (stationInfo.get("website").equals("") == false)
  {
         PosY += (2* Offset);
       textSize(headSubSize);
       text("Website",tmpPosXText,PosY,xWidth,PosY);
        
       PosY += (1* Offset);
       textSize(textSize);
       text(stationInfo.get("website"),tmpPosXText,PosY,xWidth-(3*Offset),PosY);
  }
    
    popStyle();
  }
  
  
  //TODO: Zwischen Info und Legende roten Balken zeichnen
  
  void draw()
  {
    
    DisplayLegend();
    
    if (isHelpActive == false)
    {
      DisplayHeader();
    }
    else
    {
      DisplayHelp();
    }
    //TODO: Alles Anzeigetypen anzeigen wenn true
    if (isBusStation == true)
    {
      DisplayBusStationInfo();
    }
    
    if (isKino == true)
    {
      DisplayPoiKinoInfo();
    }
    
    if (isBrunnen == true)
    {
      DisplayPoiBrunnenInfo();
    }
    
    if (isInfo == true)
    {
      DisplayPoiTouristInfo();
    }
    
    if (isMusik == true)
    {
      DisplayPoiMusikInfo();
    }
  }
}