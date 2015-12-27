

/////////////////////////////////////////////////////////////// 
// Klasse RandomObject 
/////////////////////////////////////////////////////////////// 
class RandomObject 
{ 
  float size; 
  float x,y; 
  float angle; 
  float jitterX; 
  float jitterY; 
  color objectColor;
  color jitterColor;
  float isTarget = 0;
  
  //FIXME hinzugefügt
  float sizeVariation;
  float randomStrength;
 
  RandomObject(float myX, float myY, float mySize, float amount, color myobjectColor) 
  { 
    size = mySize; 
    x = myX; 
    y = myY; 
    objectColor = myobjectColor;
    isTarget = 0;
 
    angle = amount * random(-2,+2); 
    jitterX = amount * 0.5 * random(-1,+1); 
    jitterY = amount * 0.5 * random(-1,+1); 
    
    jitterColor = color(hue(objectColor) + random(amount*30), saturation(objectColor), brightness(objectColor), alpha(objectColor));
    
  } 
  
   
  RandomObject(RandomObject source)
  {  
    x = source.x;
    y = source.y;
    size = source.size;
    angle = source.angle;
    jitterX = source.jitterX;
    jitterY = source.jitterY;
    objectColor = source.objectColor;
    jitterColor = source.jitterColor;
    randomStrength  =  source.randomStrength;  
    sizeVariation  =  source.sizeVariation; 
    isTarget = 0;  
  } 
 
   /*void draw() 
  { 
    pushMatrix(); 
    translate(x,y); 
    rotate(radians(angle)); 
    rectMode(CENTER); 
    fill(lerpColor(objectColor,jitterColor, angle));
    rect(0,0,size,size); 
    popMatrix(); 
  }*/
 
 
  void draw(float strengthX, float strengthY) 
  { 
    pushMatrix(); 
    translate(x + jitterX * strengthX,y + jitterY * strengthX); 
    rotate(radians(angle * strengthX)); 
    
    noFill();
    //color  myColor  =   color(hue(objectColor)  +  jitterColor  *  randomStrength, saturation(objectColor),  brightness(objectColor), alpha(objectColor));
    //fill(lerpColor(objectColor,jitterColor,strengthY));
    //fill(objectColor);
    ellipseMode(CENTER); 
    ellipse(0,0,size,size); 
    popMatrix(); 
  } 
 
 
 
 //FIXME: ursprüngliche Methode 
 /*
  void draw(float strengthX, float strengthY) 
  { 
    pushMatrix(); 
    translate(x + jitterX * strengthX,y + jitterY * strengthX); 
    rotate(radians(angle * strengthX)); 
    rectMode(CENTER); 
    fill(lerpColor(objectColor,jitterColor,strengthY));
    rect(0,0,size,size); 
    popMatrix(); 
  }*/ 
  
  void  drawWithEffectStrength(float randomStrength,  float sizeVariation)  
   {    
      pushMatrix();  
      translate(x  +  jitterX  *  randomStrength,  y  +  jitterY  *  randomStrength);  
      color  myColor  =   color(hue(objectColor)  +  jitterColor  *  randomStrength, saturation(objectColor),  brightness(objectColor), alpha(objectColor));     
      stroke(myColor);  
      strokeWeight(sizeVariation);  
      //fill(objectColor); //FIXME Test
      noFill();
      ellipseMode(CENTER);  
      ellipse(0,  0,  size,  size); 
      popMatrix();  
    }
 
  float xWithJitter(float randomStrength) 
  { 
    return(x + jitterX * randomStrength); 
  } 
   
  float yWithJitter(float randomStrength) 
  { 
    return(y + jitterY * randomStrength); 
  } 
   
  color colorWithJitter(float randomStrength) 
  { 
    color myColor = color(hue(objectColor) + jitterColor * randomStrength, saturation(objectColor), brightness(objectColor), alpha(objectColor)); 
   
    return(myColor); 
  } 
  
  //FIXME: Hinzugefügt
  void setColor(color mycolor)
  {
    objectColor = mycolor;
  }
}
