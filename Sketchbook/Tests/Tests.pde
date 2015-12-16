
int curHour;
float nVal;

void setup()
{
  size(500,500);
  println("Stunde:"+hour()+" Minute: "+minute()+" Sekunde: "+second());
  curHour = hour();
  colorMode(HSB);
  
  nVal = noise(23);
}

void draw()
{
  
  //for (int i=1; i<=23; i++)
  //{
    
    
    println("Noise: "+nVal);
    
    background(200*nVal);
    
  //}
  
}