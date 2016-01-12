




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

  

  
public class CityBorder extends MapObject
{
  private float lineWeight;
  private String pointId;
  
  public CityBorder(float xPositionPixel, float yPositionPixel, float latitude, float longitude, float Weight, String pointId)
  {
    //Konstruktur der Basisklasse aufrufen
    super(xPositionPixel, yPositionPixel, latitude, longitude);
       
    this.lineWeight = Weight;
    this.pointId = pointId;
        
    //TODO: Farben auswählen1!!!!!!"!"
    //Standardfarben setzen
    super.SetColor(colorRed);
    
    super.SetVisibility(true);
  }
 
  public float GetLineWeight()
  {
    return this.lineWeight;
  }
 
  public String GetId()
  {
    return this.pointId;
  }
}
  
  
  
  
  
  
  //TODO: Eventuell Shape vorher erstellen und an die Klasse übergeben
 public class CityPark extends MapObject
{
  private float lineWeight;
  
  public CityPark(float xPositionPixel, float yPositionPixel, float latitude, float longitude, float Weight)
  {
    //Konstruktur der Basisklasse aufrufen
    super(xPositionPixel, yPositionPixel, latitude, longitude);
       
    this.lineWeight = Weight;
        
    //TODO: Farben auswählen1!!!!!!"!"
    //Standardfarben setzen
    super.SetColor(colorGreen);
    
    super.SetVisibility(true);
  }
 
  public float GetLineWeight()
  {
    return this.lineWeight;
  }
} 
  
  
public class CityStreet extends MapObject
{
  private float lineWeight;
  private String streetName;
  
  //public CityStreet(PShape streetObj, String streetName)
  //{
  //  //Konstruktur der Basisklasse aufrufen
  //  //super(xPositionPixel, yPositionPixel, latitude, longitude);
  //  super();
       
  //  this.streetObj = streetObj;
  //  this.streetName = streetName;
    
  //  //Standardfarben setzen
  //  super.SetColor(colorGray);
    
  //  super.SetVisibility(true);
  //}
  
  
  public CityStreet(float xPositionPixel, float yPositionPixel, float latitude, float longitude, float Weight, String streetName)
  {
   //Konstruktur der Basisklasse aufrufen
   super(xPositionPixel, yPositionPixel, latitude, longitude);
       
   this.lineWeight = Weight;
   this.streetName = streetName;
   //TODO: Farben auswählen1!!!!!!"!"
   //Standardfarben setzen
   super.SetColor(colorGray);
    
   super.SetVisibility(true);
  }
 
  public String GetStreetName()
  {
    return this.streetName;
  }
 
  public float GetLineWeight()
  {
    return this.lineWeight;
  }

  
}  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
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
    super.SetColor(colorBlue);
    super.SetHighlightColor(colorBlue);
    
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
}  
  
  
  
  
public class BusStation extends MapObject
{
  private float objWidth;
  private float objHeight;
  private float objSizeHover;
 
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
    }
    
    //Größe festlegen
    this.objWidth = xWidth;
    this.objHeight = xWidth;
    this.objSizeHover = xWidth * 2;
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
          information.get("hausnummer").toString(),
          information.get("plz").toString(),
          "",
          "",
          "");
  }
  
  public String[] GetBusLines()
  {
    return this.busLines;
  }
  
  public float GetHoverWidth()
  {
    return this.objSizeHover;
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
  
  //FIXME: Anpassungen gemacht
  void draw()
  {
    if(super.GetVisibility() == true)
    {
      pushStyle();
      //noStroke();
      
      if (super.GetSelected() == false)
      {
        //fill(super.GetColor());
        stroke(super.GetColor());
      }
      else
      {
        //fill(super.GetHighlightColor());
        stroke(super.GetHighlightColor());
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
        
    //Standardfarben setzen
    super.SetColor(colorBrown);
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
    super.SetColor(colorLightBlue);
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
    super.SetColor(colorPurple);
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
    super.SetColor(colorGreen);
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