
public class DistanceConverter
{
  //Größe der Zeichenfläche
  private float mapWidth;
  private float mapHeight;
  
  //Ursprung linke Ecke
  private float xOrigin;
  private float yOrigin;
  
  //Linke Ecke
  private float MaxLatitude;
  private float MinLongitude;
  
  //Rechte Ecke
  private float MinLatitude;
  private float MaxLongitude;
  
  public DistanceConverter(float latitudeTop, float longitudeTop, float latitudeBottom, float longitudeBottom, float widthDrawing, float heightDrawing, float originX, float originY)
  {
    
    //Zuweisen der Größe der Zeichenfläche
    this.mapWidth = widthDrawing;
    this.mapHeight = heightDrawing;
    
    //Ursprung linke obere Ecke zuweisen
    this.xOrigin = originX;
    this.yOrigin = originY;
    
    //Zuweisen der Ecke links oben (Geo)
    this.MaxLatitude = latitudeTop;
    this.MinLongitude = longitudeTop;
    
    //Zuweisen der Ecke rechts unten (Geo)
    this.MinLatitude = latitudeBottom;
    this.MaxLongitude = longitudeBottom;
    
  }
  
  //Get Methoden für Origin x und y
  public float getOriginX()
  {
   return this.xOrigin;
  }
  
  public float getOriginY()
  {
   return this.yOrigin;
  }
    
  
  //Umrechnen von Grad zu Radiant
  private float DegreeToRadian(float degreeCoord)
  {
    return (degreeCoord * PI / 180f);
  }
  
  //Latitude zu x
  //public float LatitudeToX(float longitude)
  public float LatitudeToX(float latitude)
  {  
    //TODO: Hier muss noch OriginX draufgerechnet werden, damit die Punkte in der Zeichenfläche sind
    //return (((MaxLongitude - longitude) + 180f)*(mapWidth/360f));
    
    float tmpCalc = latitude - MaxLatitude;
    float ratio = mapWidth / (MaxLatitude - MinLatitude);
    float xCoord = tmpCalc * ratio; 
    
    if (xCoord < 0f)
    {
      xCoord *= -1f;
    }
    //FIXME: Debugging
    //println ("xCoord --> " + xCoord);
    
    return (xCoord + xOrigin);
  }
  
  //Longitude zu y
  public float LongitudeToY(float longitude)
  {
    float tmpCalc = longitude - MinLongitude;
    float ratio = mapHeight / (MaxLongitude - MinLongitude);
    float yCoord = tmpCalc * ratio;
    
    if (yCoord < 0f)
    {
      yCoord *= -1;
    }
    
    
    //FIXME: Debugging
    //println ("yCoord --> " + yCoord);
    
    return (yCoord + yOrigin);
  }
  
  //FIXME: Kann eigentlich gelöscht werden
  ////Longitude zu y
  //public float LongitudeToY(float longitude)
  //{
  //  float yCoord = 0f;
  //  float latRadian = 0f;
  //  float mercN = 0f;
  //  float tmpLatitude = MaxLongitude - longitude;
    
  //  latRadian = DegreeToRadian(tmpLatitude);
  //  mercN = log(tan((PI/4f)+(latRadian/2f)));
  //  yCoord = (mapHeight/2f)-(mapWidth*mercN/(2*PI));
    
  //  return yCoord;
  //}

  //public float LongitudeToY(float latitude)
  //{
  //  float yCoord = 0f;
  //  float latRadian = 0f;
  //  float mercN = 0f;

    
  //  latRadian = DegreeToRadian(latitude);
  //  mercN = log(tan((PI/4f)+(latRadian/2f)));
  //  yCoord = (mapHeight/2f)-(mapWidth*mercN/(2*PI));
    
  //  return yCoord;
  //}

  
  
  
  
  
  //FIXME: Sehen ob das hier überhaupt gebraucht wird
  public HashMap PixelToGeo(float xPixel, float yPixel)
  {
    HashMap geoCoords = new HashMap();
    
    
    return geoCoords;
  }

}