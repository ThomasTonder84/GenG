
class RandomCircle extends RandomObject
{
    RandomCircle(float  myX,  float  myY,  float  mySize,  float  amount,  color _color)  
    {  
      super(myX,  myY,  mySize,  amount,  _color);  
    }
  
    RandomCircle(RandomObject source)
    {
      super(source);
    }

 /*
    void  draw(float  strength,  float  sizeStrength)  
    {    
      pushMatrix();  
      stroke(lerpColor(objectColor,  jitterColor,  strength));  
      strokeWeight(1  +  32  *  sizeStrength);  
      noFill();  
      translate(x  +  jitterX  *  strength,  y  +  jitterY  *  strength);  
      ellipseMode(CENTER);  
      ellipse(0,  0,  size,  size);  
      popMatrix();  
    }
  */
}   
