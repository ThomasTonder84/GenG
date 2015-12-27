color[] initColors() 
{
  color colors[] = new color[19];
  
  colorMode(RGB, 255, 255, 255);
  colors[0] = color(255, 243, 111);    
  colors[1] = color(255, 218, 27);  
  colors[2] = color(236, 145, 45);  
  colors[3] = color(220, 62, 43);  
  colors[4] = color(197, 36, 43);  
  colors[5] = color(122, 25, 54);  


  colors[6] = color(169, 186, 57);  
  colors[7] = color(62, 164, 71);  
  colors[8] = color(0, 111, 67);  
  colors[9] = color(234, 147, 171);  
  colors[10] = color(216, 20, 107);  
  colors[11] = color(140, 43, 93);  


  colors[12] = color(163, 101, 45);  
  colors[13] = color(0, 136, 125);  
  colors[14] = color(147, 204, 175);  
  colors[15] = color(2, 176, 222);  
  colors[16] = color(65, 118, 174);  
  colors[17] = color(39, 56, 118);  
  colors[18] = color(0, 113, 179);  

  colorMode( HSB, 360, 1, 1);
  return colors;
}
