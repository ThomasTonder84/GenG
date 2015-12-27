class  PushPullCursor  
{  
  float size;  
  
  //Konstruktor
  PushPullCursor(float  _size)  
  {  
      size  =  _size;  
  }
  
  void  setSize(float _size)  
  {  
      size  =  _size;  
  }

  void  drawAt(float  x,  float  y)  
  {  
      pushStyle();  
      ellipseMode(RADIUS);  
      noFill();  
      stroke(0,  0,  1,  1);  
      strokeWeight(3);  
      ellipse(x,  y,  size,  size);  
      stroke(0,  0,  0,  1);  
      strokeWeight(1);  
      ellipse(x,  y,  size,  size);  
      popStyle();  
    }
  
  void  calcIsTarget(ArrayList<RandomObject>  objects,  float  x,  float  y)  
  {  
    for  (int  i= 0;  i  <  objects.size();  i++)  
    {  
        float  dist  =   sqrt(sq(x - objects.get(i).x)  + sq(y - objects.get(i).y)); 
        
        //FIXME von cursorSize auf size geändert
        if (dist < size)  
        {  
            objects.get(i).isTarget  =  (1 - dist / size); //FIMXE von cursorSize auf size geändert   
        }   
        else 
        {  
            objects.get(i).isTarget  =  0;  
        }  
    }  
  }
  
  
   void  showVectors(ArrayList<RandomObject>  objects  ,   float  x,  float  y)  
   {  
      pushStyle();  
      for  (int  i= 0;  i  <  objects.size();  i++)  
      {  
        if  (objects.get(i).isTarget  >  0)  
        {  
          stroke(222,  1,  1,  0.2  +  objects.get(i).isTarget);  
          strokeWeight(1);  
          line(x,  y,  objects.get(i).x,  objects.get(i).y);  
        }  
      }  
      popStyle();  
    }
    
    void  pushPull(ArrayList<RandomObject>  objects, float  centerX,  float  centerY,  float  amount)  
    {     
        for  (int  i= 0;  i  <  objects.size();  i++)  
        {  
            float  x  =  objects.get(i).x;  
            float  y  =  objects.get(i).y;  
            PVector  v;  
            v  =   new  PVector(x - centerX,  y - centerY);  
            PVector  newPos  =  PVector.mult(v, objects.get(i).isTarget  *  0.1  *  amount);     
            objects.get(i).x  +=  newPos.x;  
            objects.get(i).y  +=  newPos.y;  
        }  
    }   
}
