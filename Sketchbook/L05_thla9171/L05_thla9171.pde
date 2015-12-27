import gab.opencv.*; //<>//
import java.util.Calendar;
import processing.pdf.*;
import processing.video.*;
import controlP5.*;  
import java.awt.Rectangle;

//main 
ObjectCursor objectCursor; 
PushPullCursor pushPullCursor;
 
ArrayList<RandomObject> objects;  
float lastX = -1; 
float lastY = -1; 
boolean toolCreate = false; 
 
//Gui Elements 
ControlP5 cp5; 
Button guiCreateButton; 
Button guiColor; 
Button guiPullButton; 
Button guiPushButton;

//Gui Props
int guiWidth = 200; 
float guiHue = 180; //FIXME zu float geändert
float guiSaturation = 0.7; 
float guiBrightness = 0.7; 
float guiAlpha = 1; 
int guiCount = 5; 
float guiJitter = 0.5;

float guiCursorSize = 20; 
float guiAmount = 0.5; 
 
boolean toolPush = false; 
boolean toolPull = false; 

//Movie
Movie movie;
PImage videoImage;
OpenCV opencv;
RectangleTracer tracer;

color colors[] = new color[19];
float aspectRatioX, aspectRatioY; 


 
void setup() 
{ 
  size(1024, 768, P2D); 
  colorMode( HSB, 360, 1, 1, 1); 
  objectCursor = new ObjectCursor(); 
  objectCursor.setColor(color(180, .8, .8, .8)); 
 
  //init RandomObject Array 
  objects = new ArrayList<RandomObject>(); 

 //init PushPullCursor
  pushPullCursor = new PushPullCursor(guiCursorSize);
 
 //init movie
   //size(300,100);
   movie = new Movie(this, "people_in_frankfurt-hd.mp4");
   movie.loop();
   movie.speed(1);
 
    videoImage  =  movie;
      
    readFrame();  
    aspectRatioY  =  height  /   float(videoImage.height);  
    aspectRatioX  =  width  /   float(videoImage.width);  
    //  Start  OpenVC  
    opencv  =   new  OpenCV(this,  videoImage.width,  videoImage.height);  
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
 
    colors = initColors();
   
   tracer = new RectangleTracer();
 
 //init ControlP%
  cp5 = new ControlP5(this); 
  setupGUI(); 
 

 
} 

////////////////////////////////////////////// 
// Video
//////////////////////////////////////////////
void  readFrame()  
{  
      
  if  (((Movie)videoImage).available())  
  {  
      ((Movie)videoImage).read();  
  }  
      
}
////////////////////////////////////////////// 
// Ende Video
//////////////////////////////////////////////

 
////////////////////////////////////////////// 
// GUI 
////////////////////////////////////////////// 
void setupGUI() 
{ 
  int x = 10; 
  int y = 10; 
  int buttonSpacing = 30; 
  int sliderSpacing = 20; 
 
  guiCreateButton = cp5.addButton("guiCreate").setCaptionLabel("create").setPosition(x, y); 
  y += buttonSpacing; 
 
  cp5.addSlider("setguiCount", 1, 9).setValue(guiCount).setCaptionLabel("count").setPosition(x, y); 
  y += sliderSpacing; 
 
  cp5.addSlider("setguiJitter", 0, 1).setValue(guiJitter).setCaptionLabel("jitter").setPosition(x, y); 
  y += sliderSpacing; 
 
  cp5.addSlider("setguiHue", 0, 360).setValue(guiHue).setCaptionLabel("hue").setPosition(x, y); 
  y += sliderSpacing; 
 
  cp5.addSlider("setguiSaturation", 0, 1).setValue(guiSaturation).setCaptionLabel("saturation").setPosition(x, y); 
  y += sliderSpacing; 
 
  cp5.addSlider("setguiBrightness", 0, 1).setValue(guiBrightness).setCaptionLabel("brightness").setPosition(x, y); 
  y += sliderSpacing; 
 
  cp5.addSlider("setguiAlpha", 0, 1).setValue(guiAlpha).setCaptionLabel("alpha").setPosition(x, y); 
  y += sliderSpacing; 
 
  guiColor = cp5.addButton("setguiColor").setCaptionLabel("").setSize(100,20).setColorBackground(color(guiHue,guiSaturation,guiBrightness)).setPosition(x, y); 
  y += buttonSpacing; 
  y += sliderSpacing; 
 
  guiPushButton = cp5.addButton("guiPush").setCaptionLabel("push").setPosition(x, y); 
 
  guiPullButton = cp5.addButton("guiPull").setCaptionLabel("pull").setPosition(x + 80, y); 
  y += buttonSpacing; 
 
  cp5.addSlider("setguiCursorSize", 10, 100).setValue(guiCursorSize).setCaptionLabel("Size").setPosition(x, y); 
  y += sliderSpacing; 
 
  cp5.addSlider("setguiAmount", 0, 1).setValue(guiAmount).setCaptionLabel("amount").setPosition(x, y); 
  y += sliderSpacing; 
 
 
} 

 //Änderungen aus der GUI übernehmen
void setguiHue(int value) 
{ 
  guiHue = value; 
  objectCursor.setColor(color(guiHue, guiSaturation, guiBrightness, guiAlpha));
  //guiColor.setColorBackground(color(guiHue, guiSaturation, guiBrightness)); 
} 
 
void setguiSaturation(float value) 
{ 
  guiSaturation = value; 
  objectCursor.setColor(color(guiHue, guiSaturation, guiBrightness, guiAlpha));
  //guiColor.setColorBackground(color(guiHue, guiSaturation, guiBrightness)); 
} 
 
void setguiBrightness(float value) 
{ 
  guiBrightness = value; 
  objectCursor.setColor(color(guiHue, guiSaturation, guiBrightness, guiAlpha)); 
  //guiColor.setColorBackground(color(guiHue, guiSaturation, guiBrightness)); 
} 
 
void setguiAlpha(float value) 
{ 
  guiAlpha = value; 
  objectCursor.setColor(color(guiHue, guiSaturation, guiBrightness, guiAlpha)); 
  //guiColor.setColorBackground(color(guiHue, guiSaturation, guiBrightness)); 
} 
  
void setguiCount(int value) 
{ 
  guiCount = value; 
  objectCursor.setDraw(value); 
} 
 
void setguiJitter(float value) 
{ 
  guiJitter = value; 
  objectCursor.setRandomStrength(value); 
} 
 
void guiCreate() 
{ 
  toolCreate = true; 
  toolPull = false; 
  toolPush = false; 
} 
 
void guiPull() 
{ 
  toolCreate = false; 
  toolPull = true; 
  toolPush = false; 
} 
 
void guiPush() 
{ 
  toolCreate = false; 
  toolPull = false; 
  toolPush = true; 
} 
 
void setguiCursorSize(float value) 
{ 
  guiCursorSize = value; 
  pushPullCursor.setSize(value);
} 
 
////////////////////////////////////////////// 
// ENDE GUI 
////////////////////////////////////////////// 


boolean savePDF = false; 
 
 
void keyReleased() 
{ 
 
  if (key == 's' || key == 'S') saveFrame(timestamp() + "-F##.png"); 
  if (key=='p' || key=='P') savePDF = true;
 
    
}

// timestamp 
String timestamp()
{ 
  Calendar now = Calendar.getInstance(); 
  return String.format("%1$tY%1$tm%1$td-%1$tH%1$tM%1$tS", now); 
}
 
void beginPDF() 
{ 
  if (savePDF) beginRecord(PDF, timestamp()+".pdf"); 
} 

void endPDF() 
{ 
  if (savePDF) { savePDF = false; endRecord();} 
} 



 
void draw() 
{ 
  
  background(360);

  noFill(); 

  // GUI stuff 
  pushStyle(); 
  noStroke(); 
  fill(0, 0, .7); 
  rect(0, 0, guiWidth, height); 
  popStyle(); 


  //Movie Stuff
  
  //tint(255,20);
  //image(movie, 0, 1024, movie.width * 0.5, movie.height * 0.5);

   readFrame();  
   opencv.loadImage(videoImage);  
    //image(videoImage,  0,  0,  300,  100);
  
  //FIXME: ERmitteln der Detect Koords
  
  Rectangle[] faces = opencv.detect();

  for (int i = 0; i < faces.length; i++) {
    int id = tracer.addRectangle(faces[i].x * aspectRatioX, faces[i].y * aspectRatioY, 
    faces[i].width * aspectRatioX, faces[i].height * aspectRatioY);
  }
  

  /*ArrayList<Trace> traces = tracer.getTraces();
  for (Trace trace : traces) {
    grid.calcInteraction(trace.x, trace.y, trace.width, trace.height, trace.objectColor, trace.id);
  }*/




   beginPDF(); 
   
  // Cursor 
  if (mouseX > guiWidth) 
  { 
   noCursor(); 
    
   if (toolCreate)
   {
     objectCursor.drawAt(mouseX, mouseY);
   }
   
   if (toolPush || toolPull)
   {
      pushPullCursor. calcIsTarget(objects,  mouseX,  mouseY);  
      pushPullCursor. showVectors(objects,  mouseX,  mouseY); 
      pushPullCursor.drawAt(mouseX, mouseY);
   } 
  } 
  else 
  { 
    cursor(); 
  }

  //Erstellen neuer Objekte
  if (mousePressed && toolCreate) 
  { 
      boolean posChanged = (mouseX != lastX) || (mouseY != lastY); 
      if (mouseX > guiWidth && posChanged) 
      { 
        lastX = mouseX; 
        lastY = mouseY; 
        ArrayList<RandomObject> newObjects = new ArrayList<RandomObject>(); 
        newObjects = objectCursor.getCursorObjectsAt(mouseX, mouseY); 
        
        
        objects.addAll(newObjects); 
      }
      
  } 
  
  //Werkzeug aufrufen
   if  (mousePressed  &&  toolPush  &&  mouseX  >  guiWidth)  
   {  
      pushPullCursor.pushPull(objects,  mouseX,  mouseY,  guiAmount);  
   }
    
   if  (mousePressed  &&  toolPull  &&  mouseX  >  guiWidth)  
   {  
      pushPullCursor.pushPull(objects,  mouseX,  mouseY,  -guiAmount);  
   }


  //Objekte zeichnen
  for (int i = 0; i < objects.size (); i++) 
  { 
    if (objects.get(i).x > guiWidth) 
    { 
      //FIXME statische Werte übergeben
      //objects.get(i).draw(); 
      //objects.get(i).draw(random(0,2), random (0,2));
      objects.get(i).draw(1,1);
      
    } 

  }
  
 
  //Button Farbe
  if (toolCreate) 
  { 
    guiCreateButton.setColorBackground(color(190, 1, 1));
    
  } 
  else 
  { 
    guiCreateButton.setColorBackground(color(190, 1, .5));
   
  } 
 
  if (toolPull) 
  { 
    guiPullButton.setColorBackground(color(190, 1, 1)); 
  } 
  else 
  { 
    guiPullButton.setColorBackground(color(190, 1, .5)); 
  } 
 
  if (toolPush) 
  { 
    guiPushButton.setColorBackground(color(190, 1, 1)); 
  } 
  else 
  { 
    guiPushButton.setColorBackground(color(190, 1, .5)); 
  } 
  
 
  endPDF(); 
  
} 
