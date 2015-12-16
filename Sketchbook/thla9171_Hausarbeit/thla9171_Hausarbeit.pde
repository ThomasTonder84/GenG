////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
// Includes
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
// Globale Variablen
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
// Größen der verschiedenen Elemente
////////////////////////////////////////////////////////////////
//Anzeige
int graphicWidth;
int graphicHeight;

//Tool
int toolWidth;
int toolHeight;

//Informationen
int infoWidth;
int infoHeight;


DataReader poiBrunnen;



////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
// Ablauflogik
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
//Init
void setup()
{
  size(1024,768);
  //poiBrunnen = new DataReader("D:\\FH\\GenG\\Daten\\poi\\");
  poiBrunnen = new DataReader("poi\\");
 
  println(poiBrunnen.getCurrentPath());
  
  poiBrunnen.getData("brunnen.csv");
  
  println("Sketch Path --> "+sketchPath());
  println("Data Path   --> "+dataPath(""));
  
  
}



void draw()
{
  background(255);
  
  rect(20f,20f,20f,20f);
}