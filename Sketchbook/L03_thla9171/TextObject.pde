class TextObject
{
  String text;
  PFont font;
  
  TextObject(String t)
  {
    this.text = t;
  }
  
  void appendText(String t)
  {
    this.text += t;
  }
  
  int textLength()
  {
    return this.text.length();
  }
  
  void drawAt(float x, float y, float letter, float angle)
  {
    fill(130, 0.8, 0.8, 0.8);
    pushMatrix();
    translate(x, y);
    rotate(radians(-90));
    //text(text, 0, 0);
    drawTextWithParsing(letter, angle);
    popMatrix();
  }
  
  void drawTextWithParsing(float letter, float angle)
  {
    char c = '\0';
    float letterWidth = 0.0;
    int lineLength = 0;
    
    for(int i = 0; i < text.length(); i++)
    {
      c = text.charAt(i);
      letterWidth = textWidth(c);
      lineLength = text.length();
      
      if(lineLength % 2 == 1)
      {
        rotate(radians(1 * i * letter));
      }
      else
      {
        rotate(radians(-1 * i * letter));
      }
      
      if(c >= 'A' && c <= 'Z')
      {
        int lettercolor = c - 'A';
        fill(map(lettercolor, 1, 26, 100, 240), 0.8, 0.8, 0.8);
      }
      
      switch(c)
      {
        case ' ':
          if(i % 2 == 1)
          {
            rotate(radians(25 * angle));
          }
          else
          {
            rotate(radians(-25 * angle));
          }
          translate(letterWidth, 0);
          break;
        
        case '.':
          rotate(radians(45));
          translate(letterWidth, 0);
          break;
        
        case ',':
          rotate(radians(-45));
          translate(letterWidth, 0);
          break;
        
        default:
          text(c, 0, 0);
          translate(letterWidth, 0);
      }
    }
  }
}
