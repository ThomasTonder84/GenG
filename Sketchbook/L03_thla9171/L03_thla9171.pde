import controlP5.*;

//GUI
ControlP5 cp5;
int guiWidth = 200;

//Text
ArrayList<TextObject> objects;
PFont font;

float amountLetter;
float amountAngle;

void setup()
{
  colorMode(HSB, 360, 1, 1, 1);
  size(1024, 768, P3D);
  
  font = createFont("Myriad", 10);
  textAlign(LEFT);
  textFont(font, 12);
  
  objects = new ArrayList<TextObject>();
  aquireAndParse("mi-module.txt", objects);
  
  for(int i = objects.size() - 1; i >= 0; i--)
  {
    if(objects.get(i).textLength() < 100)
    {
      objects.remove(i);
    }
  }
  
  cp5 = new ControlP5(this);
  setupGUI(cp5);
}


void draw()
{
  hint(ENABLE_DEPTH_TEST);
  
  colorMode(HSB, 360, 1, 1, 1);
  background(360, 0, 1);
  
  // Kommentare entfernen um Veraenderungen von Mausposition abhaengig zu machen
  // Aufgrund von Gui-Verwendung auskommentiert
  //amountLetter = map(mouseX, 0, width, -0.01, 0.01);
  //amountAngle = map(mouseY, 0, width, 0, 1);
  
  for(int i = 0; i < objects.size(); i++)
  {
    objects.get(i).drawAt(20 + width / objects.size() * i, height * 0.8, amountLetter, amountAngle);
  }
  
  hint(DISABLE_DEPTH_TEST);
  pushStyle();
  noStroke();
  fill(0, 0, .7);
  rect(0, 0, guiWidth, height);
  popStyle();
  cp5.draw();
}


void aquireAndParse(String fileName, ArrayList<TextObject> objects)
{
  BufferedReader reader;
  String line;
  TextObject object;
  
  reader = createReader(fileName);
  object = new TextObject("");
  
  boolean done = false;
  
  while(!done)
  {
    try
    {
      line = reader.readLine();
    }
    catch(IOException e)
    {
      line = null;
      done = true;
    }
    
    if(line == null)
    {
      done = true;
    }
    else
    {
      if(line.indexOf("----") == 0)
      {
        objects.add(object);
        object = new TextObject("");
      }
      else
      {
        object.appendText(line + " ");
      }
    }
  }
}


void setupGUI(ControlP5 cp5)
{
  int x = 10;
  int y = 10;
  int sliderSpacing = 20;
  int buttonSpacing = 30;

  cp5.addSlider("amountLetter", 0.0, 10.0)
      .setCaptionLabel("Letters")
      .setPosition(x, y);
  y += sliderSpacing;

  cp5.addSlider("amountAngle", 0.0, 10.0)
    .setCaptionLabel("Spaces etc")
    .setPosition(x, y);
   y += buttonSpacing;
}
