class ObjectCursor 
{ 
  int columns = 3; 
  int rows = 3; 
  int size = 32; 
  int halfSize = size / 2; 
  int objectCount = rows * columns; 
  float sizeX; 
  float sizeY; 
  float randomStrength = 0; 
 
  RandomObject[][] form = new RandomObject[rows][columns]; 
  Boolean[][] draw = new Boolean[rows][columns]; 
 
 //FIXME: Tests
  ObjectCursor() 
  { 
    
    setDraw(columns * rows); //FIXME: von Seite 25 
 
    for (int row = 0; row < rows; row++) 
    { 
      for (int column = 0; column < columns; column++) 
      { 
        form[row][column] = new RandomCircle(column * (size+2) + halfSize, row * (size+2) + halfSize, size, rows, color(0, .8, .8, .8)); 
      } 
    } 
  }
 
 
  ArrayList<RandomObject> getCursorObjectsAt(float x, float y) 
  { 
    ArrayList<RandomObject> objects = new ArrayList<RandomObject>(); 
    //objects = new ArrayList<RandomObject>(); 
    
    for (int row = 0; row < rows; row++) 
    { 
      for (int column = 0; column < columns; column++) 
      { 
        if (draw[row][column]) //FIXME: Eingefügt von Seite 25 
        { 
          RandomObject object; 
          object = new RandomCircle(form[row][column]); 
          object.x = x - sizeX / 2 + form[row][column].xWithJitter(randomStrength); 
          object.y = y - sizeY / 2 + form[row][column].yWithJitter(randomStrength); 
          object.objectColor = object.colorWithJitter(randomStrength); 
          object.randomStrength = 0; 
          object.sizeVariation = 2; 
          objects.add(object); 
        } 
      } 
    } 
    return(objects); 
  } 
 
  void setColor(color myColor) 
  { 
    for (int row = 0; row < rows; row++) 
    { 
      for (int column = 0; column < columns; column++) 
      { 
        form[row][column].setColor(myColor); 
      } 
    } 
    
    
  } 
 
  void drawAt(float x, float y) 
  { 
    pushMatrix(); 
    translate(x - sizeX / 2, y - sizeY / 2); 
    for (int row = 0; row < rows; row++) 
    { 
      for (int column = 0; column < columns; column++) 
      { 
        //FIXME: Auskommentiert --> Seite 25 
        form[row][column].drawWithEffectStrength(0, 2); 
 
        if (draw[row][column]) 
        { 
          form[row][column].drawWithEffectStrength(randomStrength, 2); 
        } 
 
 
      } 
    } 
    popMatrix(); 
  } 
 
 
  void setDraw(int myObjectCount) 
  { 
    objectCount = myObjectCount; 
    int count = 0; 
 
    for (int row = 0; row < rows; row++) 
    { 
      for (int column = 0; column < columns; column++) 
      { 
        if (count < objectCount) 
        { 
          draw[row][column] = true; 
        } 
        else 
        { 
          draw[row][column] = false; 
        } 
        count += 1; 
      } 
    } 
  } 
 
  void setRandomStrength(float r) 
  { 
    randomStrength = r * size/2; 
  } 
} 
