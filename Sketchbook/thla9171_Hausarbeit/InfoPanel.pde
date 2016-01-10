
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
  private final int headSubSize = 14;
  private final int textSize = 12;
  
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
    
    //Aufteilen des Infobereichs
    this.yLegendStart = this.yHeight - (this.yHeight / 100 * 30);
    
    //Trennzeichen
    this.sepStartX = 0;
    this.sepStartY = this.yLegendStart;
    this.sepThick = 5;
    
    //Farbe zuweisen
    this.sepColor = sepColor;
    
    this.Offset = 20;
    
    
    
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
  
  private void DisplayLegend()
  {
    //Maße
    int objWidth = 10;
    int objHeight = 10;
    
    //Position
    float tmpPosXSign = sepStartX  + (2 * Offset);
    float tmpPosXText = tmpPosXSign + Offset;
    float tmpPosY = sepStartY;
    
    //TODO: Legende anzeigen
    
    pushStyle();
    fill(sepColor);
    noStroke();
    
    rect(sepStartX,tmpPosY,xWidth,sepThick);
    
    tmpPosY += 2 * Offset;
    
    //Bushaltestellen
    ellipse(tmpPosXSign,tmpPosY,objWidth,objHeight);
    tmpPosY += objHeight/2;
    text("Haltestelle Stadtbus",tmpPosXText,tmpPosY);
    
    tmpPosY += Offset;
    
    //Bushaltestellen
    rect(tmpPosXSign,tmpPosY,objWidth,objHeight);
    tmpPosY += objHeight;
    text("Brunnen",tmpPosXText,tmpPosY);
    
    tmpPosY += Offset;
    
    //Bushaltestellen
    rect(tmpPosXSign,tmpPosY,5,objHeight);
    tmpPosY += objHeight;
    text("Touristeninformation",tmpPosXText,tmpPosY);
    
    tmpPosY += Offset;
    
    //Bushaltestellen
    triangle(tmpPosXSign+(objWidth/2),tmpPosY - (objHeight/2),tmpPosXSign-(objWidth/2),tmpPosY + objHeight,tmpPosXSign+(objWidth),tmpPosY + objHeight);
    tmpPosY += objHeight;
    text("Kinos",tmpPosXText,tmpPosY);
    
    tmpPosY += Offset;
    
    //Bushaltestellen
    triangle(tmpPosXSign+(objWidth/2),tmpPosY - (objHeight/2),tmpPosXSign-(objWidth/2),tmpPosY + objHeight,tmpPosXSign+(objWidth),tmpPosY + objHeight);
    tmpPosY += objHeight;
    text("Musikclubs",tmpPosXText,tmpPosY);
    
    
    
    tmpPosY += Offset;
    
    stroke(colorRed);
    //Bushaltestellen
    line(tmpPosXSign,tmpPosY, tmpPosXSign+objWidth, tmpPosY);
    tmpPosY += objHeight;
    text("Buslinie",tmpPosXText,tmpPosY);
    
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
  
  //TODO: Für alle relevanten Objekte Überladung
  //Aufbau --> Symbol Erklärung
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
    
    HashMap<String,String> stationInfo = busStation.GetInformation();
    
    pushStyle();
    fill(sepColor);

    
    //for (int i=0; i < stationInfo.size(); i++)
    //{
    //  for (String tmpKey : stationInfo.keySet())
    //  {
        
        
    //    tmpPosY += (2* Offset);
    //    textSize(headSubSize);
    //    text(tmpKey,tmpPosXText,tmpPosY);
        
    //    tmpPosY += (1* Offset);
    //    textSize(textSize);
    //    text(stationInfo.get(tmpKey),tmpPosXText,tmpPosY);
        
    //  }
    //}
    
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
     
     if (tmpInfo.equals("") == false)
     {
       PosY += (2* Offset);
       textSize(headSubSize);
       text(tmpKey,tmpPosXText,PosY);
        
       PosY += (1* Offset);
       textSize(textSize);
       text(tmpInfo,tmpPosXText,PosY);
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
     
     if (tmpInfo.equals("") == false)
     {
       PosY += (2* Offset);
       textSize(headSubSize);
       text(tmpKey,tmpPosXText,PosY);
        
       PosY += (1* Offset);
       textSize(textSize);
       text(tmpInfo,tmpPosXText,PosY);
     }
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
     
     if (tmpInfo.equals("") == false)
     {
       PosY += (2* Offset);
       textSize(headSubSize);
       text(tmpKey,tmpPosXText,PosY);
        
       PosY += (1* Offset);
       textSize(textSize);
       text(tmpInfo,tmpPosXText,PosY);
     }
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
     
     if (tmpInfo.equals("") == false)
     {
       PosY += (2* Offset);
       textSize(headSubSize);
       text(tmpKey,tmpPosXText,PosY);
        
       PosY += (1* Offset);
       textSize(textSize);
       text(tmpInfo,tmpPosXText,PosY);
     }
   }
  
    
    popStyle();
  }
  
  
  //TODO: Zwischen Info und Legende roten Balken zeichnen
  
  void draw()
  {
    
    DisplayLegend();
    DisplayHeader();
    
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