////////////////////////////////////////////////////////////////////////////////////////////////
//  Generatives Gestalten
//  Labor 1 vom 2.10.2014
////////////////////////////////////////////////////////////////////////////////////////////////
//  Autor: Thomas Tonder
//  Login: thla9171
////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////
//  Variablen
////////////////////////////////////////////////////////////////////////////////////////////////
//Ellipse
float pointSize;
float pointDistance; 
float pointRadius;
 
//Zeichenbereich 
float areasizeFull; 
float areasizeHalfPos; 
float areasizeHalfNeg; 
 
//Noise
float noiseXstart;
float noiseYstart;
float noiseStep;
float noiseX;
float noiseY;
float noisePositionFactor;

//Control Variables
boolean runonce;


////////////////////////////////////////////////////////////////////////////////////////////////
//  Setup
////////////////////////////////////////////////////////////////////////////////////////////////
void setup() 
{
 println("Aufruf von Setup"); 
  //Sketchgröße festlegen und P3D als Renderer setzen 
  size(800,800,P3D); 
 
  //Setzen der Hintergrundfarbe 
  background(150,250,150); 
 
  //Füllungsfarbe (leicht transparent) 
  fill(255,20,20,80); 
 
  //Linienfarbe (leicht transparent) 
  stroke(0,0,0,80); 

  //Init Noise
  noiseXstart =  random(0,1);
  noiseYstart  = random(0,1);  
  noiseStep = 0.02;
  noiseX = noiseXstart;
  noiseY = random(0,1);
  noisePositionFactor = 4;
  
  //Ellipse
  pointSize = random(0,26);
  pointDistance = 3; 
  pointRadius = 0;//pointSize / 2;
  
  //Zeichenbereich
  areasizeFull = (width / 8) * 2; 
  areasizeHalfPos = areasizeFull / 2; 
  areasizeHalfNeg = areasizeHalfPos * (-1); 

  //Control Variables
  runonce = false;

} 

////////////////////////////////////////////////////////////////////////////////////////////////
//  Draw
//////////////////////////////////////////////////////////////////////////////////////////////// 
void draw() 
{ 
  if (runonce == false)
  {
     println("Aufruf von Draw");
     
     runonce = true;
     
     //Setzen der Hintergrundfarbe 
     background(150,250,150); 
    
    
     //Aufruf von drawPoints(); 
     drawPoints(); 
  }
} 

void drawPoints() 
{ 
  
  noiseX = noiseXstart;
  noiseY = noiseYstart;
   
  
   
  //Debugausgabe 
  println("Size of Draw area Full: " + areasizeFull); 
  println("Size of Draw area Half: " + areasizeHalfPos); 
  println("Size of Draw area Half: " + areasizeHalfNeg); 
  println("Size of ellipse X     : " + pointSize);
  
  //Sichern des ursprünglichen Koordinatensystems (0,0)
  pushMatrix(); 
 
  //Ursprung in die Mitte des Sketches setzen 
  translate(width/2,height/2); 
 
 //Zeichnen der Punkte  
  for (float y = (areasizeHalfNeg + pointRadius); y <= areasizeHalfPos; y += pointRadius + pointDistance) 
  { 
    //Noise X zurücksetzen
    noiseX = noiseXstart;
    
    //Noise Y erhöhen
    noiseY += noiseStep;
    
    for (float x = (areasizeHalfNeg + pointRadius); x <= areasizeHalfPos; x += pointRadius + pointDistance) 
    { 
      noiseX += noiseStep;
    
    
      
      pushMatrix(); 
      translate(x * noise(noiseX,noiseY) * noisePositionFactor, y * noise(noiseX, noiseY) * noisePositionFactor, y); 
      //ellipse(0,0,pointSize,pointYsize);
     
      ellipse(0, 0, noise(noiseX,noiseY) * pointSize, noise(noiseX, noiseY) * pointSize); 
      popMatrix(); 
     
  
 
    } 
  } 
 
  //Wiederherstellen des ursprünglichen Koordinatensystems (0,0)
  popMatrix(); 
} 
 
////////////////////////////////////////////////////////////////////////////////////////////////
//  Mouse
//////////////////////////////////////////////////////////////////////////////////////////////// 
void mouseClicked()
{
  
   runonce = false;
  
   noiseXstart = random(0,1);
   noiseYstart = random(0,1);
  
  
   noiseStep = noise(0.1,float(mouseX));
   
   println("Mouse X: "+mouseX );
   
   pointSize = random(0,26);
   
   println("noiseStep: "+noiseStep );
  
   redraw();
}
 
