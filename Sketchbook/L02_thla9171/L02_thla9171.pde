/////////////////////////////////////////////////////////////// 
// Imports 
/////////////////////////////////////////////////////////////// 
import processing.pdf.*; 
import java.util.Calendar; 
 
 
/////////////////////////////////////////////////////////////// 
// Variablen Deklaration 
/////////////////////////////////////////////////////////////// 
int columns; 
int rows; 
float padding; 
float halfSize; 
float rectSize; 
color objectColor;
RandomObject[][] form; 
int windowWidth;
int windowHeight;
 
 
/////////////////////////////////////////////////////////////// 
// Main 
/////////////////////////////////////////////////////////////// 
void setup() 
{ 
  //Init 
  columns = int(random(5,15)); 
  rows = int(random(5,15)); 
  padding = random(0,10); 
  rectSize = random(30,60); 
  halfSize = rectSize / 2;  
  form = new RandomObject[rows][columns]; 
  objectColor = color(random(30,200),random(30,200),random(30,200),random(30,200));
  
  colorMode(HSB,360,1,1);
  
  windowWidth = columns * (int(rectSize) + 2) + 2 * int(padding); 
  windowHeight = rows * (int(rectSize) + 2) + 2 * int(padding);
  
  size (windowWidth, windowHeight);

  
  for (int row = 0; row < rows; row++) 
  { 
    
    
    for (int column = 0; column < columns; column++) 
    { 
      form[row][column] = new RandomObject(column *(rectSize+2) + halfSize, row * (rectSize + 2) + halfSize, rectSize, row, objectColor); 
    } 
  } 
} 
 
boolean savePDF = false; 
 
 
void keyReleased() 
{ 
 
  if (key == 's' || key == 'S') saveFrame(timestamp() + "-F##.png"); 
  if (key=='p' || key=='P') savePDF = true; 
} 
 
void beginPDF() 
{ 
  if (savePDF) beginRecord(PDF, timestamp()+".pdf"); 
} 

void endPDF() 
{ 
  if (savePDF) { savePDF = false; endRecord();} 
} 

// timestamp 
String timestamp()
{ 
  Calendar now = Calendar.getInstance(); 
  return String.format("%1$tY%1$tm%1$td-%1$tH%1$tM%1$tS", now); 
} 
 
 
void draw() 
{ 
  beginPDF(); 
  //colorMode( HSB, 360, 1, 1); 
  background(360); 
  stroke(0); 
  noFill(); 
 
  float strengthY = map(mouseY, 0, height, 0, 4); 
  float strengthX = map(mouseX, 0, width, 0, 4); 
 
  translate(padding, padding); 
  
  for (int row = 0; row < rows; row++) 
  { 
    for (int column = 0; column < columns; column++) 
    { 
      form[row][column].draw(strengthX,strengthY); 
    } 
  } 
 
  endPDF(); 
} 
 
 
 
 
