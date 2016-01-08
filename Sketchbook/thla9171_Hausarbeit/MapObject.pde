




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
  
  
  public MapObject(){}
  
  public MapObject(float xPositionPixel, float yPositionPixel, float latitude, float longitude)
  {
    //Init der Props
    this.isVisible = true;
    this.isSelected = false;
    this.xOffset = 0f;
    this.yOffset = 0f;
      
    
    //Zuweisen der übergebenen Parameter
    this.xPosition = xPositionPixel;
    this.yPosition = yPositionPixel;
    this.latitude = latitude;
    this.longitude = longitude;   
  }
  
  public void DisplayInformation()
  {
    //TODO: Übergeben der Informationen an InfoPanel
  }
  
  //Setter
  public void SetOffset(float xOffset, float yOffset)
  {
    this.xOffset = xOffset;
    this.yOffset = yOffset;
    
    //Setzen der neuen Position
    //this.xPosition += this.xOffset;
    //this.yPosition += this.yOffset;
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
    return this.xPosition;
  }
  
  public float GetYPosition()
  {
    return this.yPosition;
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
  
  
public class BusStation extends MapObject
{
  

}


public class PoiTouristenInfo extends MapObject
{
  private float rectWidth;
  private float rectHeight;
    
  public PoiTouristenInfo(float xPositionPixel, float yPositionPixel, float latitude, float longitude, float xWidth, float yHeight)
  {
    //Konstruktur der Basisklasse aufrufen
    super(xPositionPixel, yPositionPixel, latitude, longitude);
    
    //Größe festlegen
    this.rectWidth = xWidth;
    this.rectHeight = yHeight;
        
    //TODO: Farben auswählen1!!!!!!"!"
    //Standardfarben setzen
    super.SetColor(#1630FF);
    super.SetHighlightColor(#7209FF);
  }
  
   
  //Setzen der zusätzlichen Informationen für Infobereich
  public void SetInformation(HashMap<String,Object> information)
  {
    //Todo: Aufbereiten der Infos und Zuweisen
    
    //FIXME: Debugging
    //println("Ausgabe in SetInformation --> ");
    //printArray(information);
    
    super.DisplayInformation();
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
      
      rect((super.GetXPosition()+super.GetXOffset()),(super.GetYPosition()+super.GetYOffset()),rectWidth,rectHeight);
      popStyle();
    }
  }

  ////Setter
  //public void SetOffset(float xOffset, float yOffset)
  //{
  //  super.SetOffset(xOffset,yOffset);
  //}
  
  //public void SetColor(color myColor)
  //{
  //  super.SetColor(myColor);
  //}

  //public void SetVisibility(Boolean isVisible)
  //{
  //  super.SetVisibility(isVisible);
  //}
  
  //public void SetSelected(Boolean isSelected)
  //{
  //  super.SetSelected(isSelected);
  //}

 
  //Getter
  //public float GetXPosition()
  //{
  //  return super.GetXPosition();
  //}
  
  //public float GetYPosition()
  //{
  //  return super.GetYPosition();
  //}  
}