




public class MapObject
{
  //TODO: Notwendige Informationen
  //Geokoords
  //Pixelkoords
  //
  //Positionseigenschaften(Pixel)
  private float xPosition;
  private float yPosition;
  private float xOffset;
  private float yOffset;
  
  //Positionseigenschaften(Geo)
  private float latitude;
  private float longitude;
  
  //visuelle Eigenschaften
  private color objectColor;
  private color highlightColor;
  private Boolean isVisible;
  private Boolean isSelected;
  
  //Zusätzliche Informationen
  private String bezeichnung;
  private String strasse;
  private String hausnummer;
  private String plz;
  private String ort;
  private String telefon;
  private String website;
  
  
  public MapObject()
  {
    //Init der Props
    this.isVisible = true;
    this.isSelected = false;
    this.xOffset = 0f;
    this.yOffset = 0f;
    this.highlightColor = color(#FFF743);
  }
  
  public MapObject(float xPositionPixel, float yPositionPixel, float latitude, float longitude)
  {
    //Init der Props
    this.isVisible = true;
    this.isSelected = false;
    this.xOffset = 0f;
    this.yOffset = 0f;
    this.highlightColor = color(#d81920);
      
    
    //Zuweisen der übergebenen Parameter
    this.xPosition = xPositionPixel;
    this.yPosition = yPositionPixel;
    this.latitude = latitude;
    this.longitude = longitude;   
  }
  
  public void DisplayInformation()
  {
    //TODO: Übergeben der Informationen an InfoPanel
    //Wenn isSelected = true ist
  }
  
  //Setter
  public void SetInformation (String bezeichnung, String strasse, String hausnummer, String plz, String ort, String telefon, String website)
  {
    this.bezeichnung = bezeichnung;
    this.strasse = strasse;
    this.hausnummer = hausnummer;
    this.plz = plz;
    this.ort = ort;
    this.telefon = telefon;
    this.website = website;
    
  }
  
  public void SetOffset(float xOffset, float yOffset)
  {
    this.xOffset = xOffset;
    this.yOffset = yOffset;
  }
  
  public void SetColor(color myColor)
  {
    this.objectColor = myColor;
  }
  
  public void SetHighlightColor(color myHighlight)
  {
    this.highlightColor = myHighlight;
  }

  public void SetVisibility(Boolean isVisible)
  {
    this.isVisible = isVisible;
  }
  
  public void SetSelected(Boolean isSelected)
  {
    this.isSelected = isSelected;
  }

 
  //Getter
  public float GetXPosition()
  {
    return (this.xPosition + this.xOffset);
  }
  
  public float GetYPosition()
  {
    return (this.yPosition + this.yOffset);
  }

  public color GetColor()
  {
    return this.objectColor;
  }
  
  public color GetHighlightColor()
  {
    return this.highlightColor;
  }

  public Boolean GetSelected()
  {
    return this.isSelected;
  }
  
  public Boolean GetVisibility()
  {
    return this.isVisible;
  }
  
  public float GetXOffset()
  {
    return this.xOffset;
  }
  
  public float GetYOffset()
  {
    return this.yOffset;
  }
  
  public HashMap<String,String> GetInformation()
  {
    HashMap<String,String> objInformation = new HashMap<String,String>();
    
    objInformation.put("bezeichnung",this.bezeichnung);
    objInformation.put("strasse",this.strasse);
    objInformation.put("hausnummer",this.hausnummer);
    objInformation.put("plz",this.plz);
    objInformation.put("ort",this.ort);
    objInformation.put("telefon",this.telefon);
    objInformation.put("website",this.website);
    
    return objInformation;
  }
  
  
}

  //TODO:
  //Draw der einzelen Punkte
  //Festlegen von Symbolen
  //Speichern von Geo und Pixelkoordinaten
  //Speichern von Farben
  //Nächster und vorheriger Punkt --> erstellen nach Linien sortiert
  //isVisible
  //color
  //
  
  //TODO: BusLine


//public class BusLine extends MapObject
//{
//  private float objWidth;
//  private float objHeight;
//  private float busSpeed;
  
//  //Abfahrtszeit der ersten Haltestelle
//  private int busDepHour;
//  private int busDepMin;
  
//  private ArrayList<HashMap> busLine;
//  private String busLineNumber;
  
//  public BusLine(ArrayList<HashMap> busLine, float xWidth)
//  {
//    //TODO: Position der ersten Haltestelle
//    //Konstruktur der Basisklasse aufrufen
//    super();
    
//    this.busLine = new ArrayList<HashMap>();
       
//    //Aufbereiten der Daten
//    this.busLineNumber = busLine.get(0).get("linien").toString();
    
            
//    for(HashMap bus : busLine)
//    {

//      bus.remove("linien");
//      bus.put("visible",true);
//      this.busLine.add(bus);
//    }
    
//    //FIXME: Debugging
//    println("Aufruf aus BusLine Klasse --> Linie: " + this.busLineNumber);
//    printArray(this.busLine);
    
//    //Größe festlegen
//    this.objWidth = xWidth;
//    this.objHeight = xWidth;
        
//    //Farben setzen
//    super.SetColor(#1630FF);
//  }
  
//  public void SetStationVisibility(float xPosition, float yPosition, Boolean isVisible)
//  {
//    for (HashMap tmpStation : busLine)
//    {
//      float xStation = Float.parseFloat(tmpStation.get("x").toString());
//      float yStation = Float.parseFloat(tmpStation.get("y").toString());
      
//      if (xStation == xPosition && yStation == yPosition)
//      {
//        tmpStation.replace("visible",isVisible);
//      }
//    }
//  }
    
    
//  //Setzen der Abfahrtszeit, der Station
//  public void SetDepature(int hour, int minute)
//  {
//     this.busDepHour = hour;
//     this.busDepMin = minute;
//  }
  
//  public String GetLineNumber()
//  {
//    return this.busLineNumber;
//  }
   
//  public int GetStationNumber(float xPosition, float yPosition)
//  {
    
//    //TODO: Ermitteln der Stationsnummer durch Position
    
//    return 1;
//  }
  
//  public int GetDepatureHour(float xPosition, float yPosition)
//  {
//    //TODO: Ermitteln der Abfahrtszeit durch Stationsnummer --> Interpolation
    
//     return this.busDepHour;
//  }
  
//  public int GetDepatureMinute(float xPosition, float yPosition)
//  {
//     return this.busDepMin;
//  }
  
//  //TODO: Positionen ermitteln und zurückgeben
//  public PVector GetFirstStation()
//  {
//    return new PVector(11,22);
//  }
  
//  public PVector GetLastStation()
//  {
//    return new PVector(22,11);
//  }
  
//  void draw()
//  {
//    //TODO: Alle Punkte der Linie zeichnen
//    //Punkte nur zeichnen wenn highlight
//    //sonst nur die LInien einzeichnen
    
    
    
//    if(super.GetVisibility() == true)
//    {
//      float pointOneX = 0f;
//      float pointOneY = 0f;
//      float pointTwoX = 0f;
//      float pointTwoY = 0f;
      
      
//      pushStyle();
      
//      strokeWeight(objWidth/5);

//      if (super.GetSelected() == false)
//      {
//        stroke(super.GetColor());
//        //line(
//      }
//      else
//      {
//        fill(super.GetHighlightColor());
//      }
      
      
      
//      for (int i=0; i < busLine.size(); i++)
//      {
//        pointOneX = Float.parseFloat(busLine.get(i).get("x").toString()) + super.GetXOffset();
//        pointOneY = Float.parseFloat(busLine.get(i).get("y").toString()) + super.GetYOffset();
        
//        if((i+1) < busLine.size())
//        {
//          pointTwoX = Float.parseFloat(busLine.get(i+1).get("x").toString()) + super.GetXOffset();
//          pointTwoY = Float.parseFloat(busLine.get(i+1).get("y").toString()) + super.GetYOffset();
          
//          line(pointOneX,pointOneY,pointTwoX,pointTwoY);
          
//          println("Zeichne Linie von X|Y --> " + pointOneX + " | " + pointTwoY + "  ||| Nach X|Y -->" + pointTwoX + " | " + pointTwoY);
//        }
        
//        if (super.GetSelected() == true && busLine.get(i).get("visible").equals(true))
//        {
//          ellipse(pointOneX,pointOneY,objWidth,objHeight);
//        }

//      }
      
      
//      popStyle();
//    }
//  }

//}  
  
  
  
public class BusLine extends MapObject
{
  private float objWidth;
  private float objHeight;
 
  private String lineNumber;
  private int stationId;
  
  public BusLine(float xPositionPixel, float yPositionPixel, float latitude, float longitude, float xWidth, String busLineNumber, int stationId)
  {
    //Konstruktur der Basisklasse aufrufen
    super(xPositionPixel, yPositionPixel, latitude, longitude);
       
    this.lineNumber = busLineNumber;
    this.stationId = stationId;
    
    //Größe festlegen
    this.objWidth = xWidth;
    this.objHeight = xWidth;
        
    //TODO: Farben auswählen1!!!!!!"!"
    //Standardfarben setzen
    super.SetColor(#1630FF);
    
    super.SetVisibility(false);
  }
 
  
  public String GetLineNumber()
  {
    return this.lineNumber;
  }
  
  public int GetId()
  {
    return this.stationId;
  }
  
    
  
  //void draw()
  //{
  //  if(super.GetVisibility() == true)
  //  {
  //    pushStyle();
  //    noStroke();
      
  //    if (super.GetSelected() == false)
  //    {
  //      fill(super.GetColor());
  //    }
  //    else
  //    {
  //      fill(super.GetHighlightColor());
  //    }
      
      
  //    ellipse((super.GetXPosition()+super.GetXOffset()),(super.GetYPosition()+super.GetYOffset()),objWidth,objHeight);
  //    popStyle();
  //  }
  //}

}  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
public class BusStation extends MapObject
{
  private float objWidth;
  private float objHeight;
 
  private String[] busLines;
  
  public BusStation()
  {
    super();
  }
  
  public BusStation(float xPositionPixel, float yPositionPixel, float latitude, float longitude, float xWidth, String availableLines)
  {
    //Konstruktur der Basisklasse aufrufen
    super(xPositionPixel, yPositionPixel, latitude, longitude);
       
    
    //Aufbereiten der Buslinien und speichern in Array
    busLines = new String[availableLines.split(",").length];
    busLines = availableLines.split(",");
        
    //Leerzeichen entfernen
    for (int i=0; i < busLines.length; i++)
    {
      String tmpLine = busLines[i].trim();
      busLines[i] = tmpLine;
      
      //FIXME: Debugging
      println("Ausgabe hoffentlich ohne Leerzeichen -->" + tmpLine + "|");  
    }
    
    println("Und alle Buslinien --> " );
    printArray(busLines);
    
    
    //Größe festlegen
    this.objWidth = xWidth;
    this.objHeight = xWidth;
        
    //TODO: Farben auswählen1!!!!!!"!"
    //Standardfarben setzen
    super.SetColor(#1630FF);
  }
  

  //Setzen der zusätzlichen Informationen für Infobereich
  public void SetInformation(HashMap<String,Object> information)
  {
    /*super.SetInformation (
          information.get("bezeichnung").toString(),
          information.get("strasse_name").toString(),
          information.get("hausnummer").toString(),
          information.get("postleitzahl").toString(),
          information.get("gemeindeteil_name").toString(),
          "",
          "");*/
  }
  
  public String[] GetBusLines()
  {
    return this.busLines;
  }
  
  public Boolean ContainsBusLine(String busLine)
  {
    Boolean busLineAvailable = false;
    
    for (String bus : busLines)
    {
      if (bus.equals(busLine) == true)
      {
        busLineAvailable = true;
      }
    }
    
    return busLineAvailable;
  }
  
  
  void draw()
  {
    if(super.GetVisibility() == true)
    {
      pushStyle();
      noStroke();
      
      if (super.GetSelected() == false)
      {
        fill(super.GetColor());
      }
      else
      {
        fill(super.GetHighlightColor());
      }
      
      
      ellipse(super.GetXPosition(),super.GetYPosition(),objWidth,objHeight);
      popStyle();
    }
  }

}




public class PoiBrunnen extends MapObject
{
  private float objWidth;
  private float objHeight;
    
  public PoiBrunnen(float xPositionPixel, float yPositionPixel, float latitude, float longitude, float xWidth)
  {
    //Konstruktur der Basisklasse aufrufen
    super(xPositionPixel, yPositionPixel, latitude, longitude);
    
    //Größe festlegen
    this.objWidth = xWidth;
    this.objHeight = xWidth;
        
    //TODO: Farben auswählen1!!!!!!"!"
    //Standardfarben setzen
    super.SetColor(#1630FF);
  }
  
   
  //Setzen der zusätzlichen Informationen für Infobereich
  public void SetInformation(HashMap<String,Object> information)
  {
    super.SetInformation (
          information.get("bezeichnung").toString(),
          information.get("strasse_name").toString(),
          information.get("hausnummer").toString(),
          information.get("postleitzahl").toString(),
          information.get("gemeindeteil_name").toString(),
          "",
          "");
  }
  
  void draw()
  {
    if(super.GetVisibility() == true)
    {
      pushStyle();
      noStroke();
      
      if (super.GetSelected() == false)
      {
        fill(super.GetColor());
      }
      else
      {
        fill(super.GetHighlightColor());
      }
      
      rect((super.GetXPosition()-(objWidth/2)),(super.GetYPosition()-(objHeight/2)),objWidth,objHeight);
      popStyle();
    }
  }
}












public class PoiKino extends MapObject
{
  private float objWidth;
  private float objHeight;
    
  public PoiKino(float xPositionPixel, float yPositionPixel, float latitude, float longitude, float xWidth, float yHeight)
  {
    //Konstruktur der Basisklasse aufrufen
    super(xPositionPixel, yPositionPixel, latitude, longitude);
    
    //Größe festlegen
    this.objWidth = xWidth;
    this.objHeight = yHeight;
        
    //TODO: Farben auswählen1!!!!!!"!"
    //Standardfarben setzen
    super.SetColor(#1630FF);
    //super.SetHighlightColor(#7209FF);
  }
  
   
  //Setzen der zusätzlichen Informationen für Infobereich
  public void SetInformation(HashMap<String,Object> information)
  {
    //Todo: Aufbereiten der Infos und Zuweisen
    //Zuweisen mit super.SetInformation(....)
    
    //SetInformation (String bezeichnung, String strasse, String hausnummer, String plz, String ort, String telefon, String website)
    
    super.SetInformation (
          information.get("bezeichnung").toString(),
          information.get("strasse_name").toString(),
          information.get("hausnummer").toString(),
          information.get("postleitzahl").toString(),
          information.get("gemeindeteil_name").toString(),
          information.get("telefon").toString(),
          information.get("website").toString());
    
    //FIXME: Debugging
    //println("Ausgabe in SetInformation --> ");
    //printArray(information);
    
    
    
    
    
  }
  
  void draw()
  {
    float pointOneX;
    float pointOneY;
    float pointTwoX;
    float pointTwoY;
    float pointThreeX;
    float pointThreeY;
    
    if(super.GetVisibility() == true)
    {
      pushStyle();
      noStroke();
      
      if (super.GetSelected() == false)
      {
        fill(super.GetColor());
      }
      else
      {
        fill(super.GetHighlightColor());
      }
      
      //Zuweisen der Koordinaten an Punkte 
      pointOneX = super.GetXPosition();
      pointOneY = super.GetYPosition() - (objHeight / 2);
      pointTwoX = super.GetXPosition() - (objWidth / 2);
      pointTwoY = super.GetYPosition() + (objHeight / 2);
      pointThreeX = pointTwoX + objWidth;
      pointThreeY = pointTwoY;
      
      triangle(pointOneX, pointOneY, pointTwoX, pointTwoY, pointThreeX, pointThreeY);
      
      popStyle();
    }
  }   
}










public class PoiMusikClub extends MapObject
{
  private float objWidth;
  private float objHeight;
    
  public PoiMusikClub(float xPositionPixel, float yPositionPixel, float latitude, float longitude, float xWidth, float yHeight)
  {
    //Konstruktur der Basisklasse aufrufen
    super(xPositionPixel, yPositionPixel, latitude, longitude);
    
    //Größe festlegen
    this.objWidth = xWidth;
    this.objHeight = yHeight;
        
    //TODO: Farben auswählen1!!!!!!"!"
    //Standardfarben setzen
    super.SetColor(#1630FF);
    //super.SetHighlightColor(#7209FF);
  }
  
   
  //Setzen der zusätzlichen Informationen für Infobereich
  public void SetInformation(HashMap<String,Object> information)
  {
    //Todo: Aufbereiten der Infos und Zuweisen
    //Zuweisen mit super.SetInformation(....)
    
    //SetInformation (String bezeichnung, String strasse, String hausnummer, String plz, String ort, String telefon, String website)
    
    super.SetInformation (
          information.get("bezeichnung").toString(),
          information.get("strasse_name").toString(),
          information.get("hausnummer").toString(),
          information.get("postleitzahl").toString(),
          information.get("gemeindeteil_name").toString(),
          information.get("telefon").toString(),
          information.get("website").toString());
    
    //FIXME: Debugging
    //println("Ausgabe in SetInformation --> ");
    //printArray(information);
    
    
    
    
    
  }
  
  void draw()
  {
    float pointOneX;
    float pointOneY;
    float pointTwoX;
    float pointTwoY;
    float pointThreeX;
    float pointThreeY;
    
    if(super.GetVisibility() == true)
    {
      pushStyle();
      noStroke();
      
      if (super.GetSelected() == false)
      {
        fill(super.GetColor());
      }
      else
      {
        fill(super.GetHighlightColor());
      }
      
      //Zuweisen der Koordinaten an Punkte 
      pointOneX = super.GetXPosition() - (objWidth / 2);
      pointOneY = super.GetYPosition() - (objHeight / 2);
      pointTwoX = super.GetXPosition() + (objWidth / 2);
      pointTwoY = pointOneY;
      pointThreeX = pointOneX + (objWidth / 2);
      pointThreeY = pointOneY + objHeight;
      
      triangle(pointOneX, pointOneY, pointTwoX, pointTwoY, pointThreeX, pointThreeY);
      
      popStyle();
    }
  }   
}







public class PoiTouristenInfo extends MapObject
{
  private float objWidth;
  private float objHeight;
    
  public PoiTouristenInfo(float xPositionPixel, float yPositionPixel, float latitude, float longitude, float xWidth, float yHeight)
  {
    //Konstruktur der Basisklasse aufrufen
    super(xPositionPixel, yPositionPixel, latitude, longitude);
    
    //Größe festlegen
    this.objWidth = xWidth;
    this.objHeight = yHeight;
        
    //TODO: Farben auswählen1!!!!!!"!"
    //Standardfarben setzen
    super.SetColor(#1630FF);
  }
  
   
  //Setzen der zusätzlichen Informationen für Infobereich
  public void SetInformation(HashMap<String,Object> information)
  {
     super.SetInformation (
          information.get("bezeichnung").toString(),
          information.get("strasse").toString(),
          information.get("hnr").toString(),
          information.get("plz").toString(),
          information.get("ort").toString(),
          information.get("telefon").toString(),
          information.get("website").toString());
  }
  
  void draw()
  {
    if(super.GetVisibility() == true)
    {
      pushStyle();
      noStroke();
      
      if (super.GetSelected() == false)
      {
        fill(super.GetColor());
      }
      else
      {
        fill(super.GetHighlightColor());
      }
      
      rect((super.GetXPosition()-(objWidth/2)),(super.GetYPosition()-(objHeight/2)),objWidth,objHeight);
      popStyle();
    }
  }   
}