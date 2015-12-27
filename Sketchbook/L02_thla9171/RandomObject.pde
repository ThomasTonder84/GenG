/////////////////////////////////////////////////////////////// 
// Klasse RandomObject 
/////////////////////////////////////////////////////////////// 
class RandomObject 
{ 
  private float size; 
  private float x,y; 
  private float angle; 
  private float jitterX; 
  private float jitterY; 
  private color ColorObject;
  private color ColorJitter;
 
 
  RandomObject(float myX, float myY, float mySize, float amount, color objectColor) 
  { 
    this.size = mySize; 
    this.x = myX; 
    this.y = myY; 
    this.ColorObject = objectColor;
 
    angle = amount * random(-2,+2); 
    jitterX = amount * 0.5 * random(-1,+1); 
    jitterY = amount * 0.5 * random(-1,+1); 
    
    ColorJitter = color(hue(objectColor) + random(amount*30), saturation(ColorObject), brightness(ColorObject), alpha(ColorObject));
    
  } 
 
  void draw(float strengthX, float strengthY) 
  { 
    pushMatrix(); 
    translate(x + jitterX * strengthX,y + jitterY * strengthX); 
    rotate(radians(angle * strengthX)); 
    rectMode(CENTER); 
    fill(lerpColor(ColorObject,ColorJitter,strengthY));
    rect(0,0,size,size); 
    popMatrix(); 
  } 
} 
