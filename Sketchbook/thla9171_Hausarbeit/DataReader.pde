
/**
// Einlesen der Csv Daten
*/

public class DataReader
{
  private String csvFile;
  private String csvDir;
  private String[] rawData;
  
  DataReader(String csvDir)
  {
    //FIXME: Pfad auf abschließenden Backslash prüfen
    this.csvDir = csvDir;
    
    //Auf abschließenden Bachshlash prüfen
    if (this.csvDir.endsWith("/") == false)
    {
      this.csvDir += "\\";
    }
    
    
  }

  //FIXME: void muss durch DataObject ersetzt werden, da dieses Objekt am Ende zurückgegeben werden soll
  //Muss zeilenweise verarbeitet werden
  public void getData(String fileName)
  {
    ArrayList<HashMap> objectData = new ArrayList<HashMap>();
    
    this.csvFile = fileName;   
    rawData = loadStrings(csvDir+this.csvFile);
        
    //objectData = new HashMap[(rawData.length-1)];
   
   
   
    //INFO: Ausgabe der eingelesenen Csv Daten
    //printArray(rawData[0]);
    
    //Auslesen der Feldbeschreibungen
    String[] headDescription = split(rawData[0], ',');
    
    //TODO: 
    //Leerzeichen mit trim(String) vorne und hinten entfernen
    //Anführungszeichen mit String.replace('old','new') entfernen
    
    //TODO:
    //statt split muss jeder String bis zum jeweiligen Komma durchgeganen und aufgeteilt werden.
    
    
    
    //Aufbereiten der Csv-Daten
    for (int i=1; i < rawData.length; i++)
    {
      HashMap tmpData = new HashMap();
      //String[] tmpRawData = split(rawData[i], ',');
      String tmpRawData = rawData[i];
      //String tmpRawData = rawData[i].replace('"',' ');
      
      println("Auszug aus RawData --> Index:"+i+" --> " + tmpRawData);
      for (int j=0; j < headDescription.length; j++)
      {
        //tmpData.put(headDescription[j],tmpRawData[j]);
      }
      
      //printArray(tmpRawData); //<>//
      //printArray(tmpData);
      //objectData[i-1].putAll(tmpData);
      objectData.add(tmpData); //<>//
    }
    
    
    printArray(headDescription);
    printArray(objectData);
    //println("Header --> " + split(rawData[0], ','));
  }
  
  //FIXME: Prüfung auf Existenz der Datei prüfen und korrekten Wert zurückgeben
  public Boolean isCurrentPathCorrect()
  {
    return true;
  }
    
  //Ausgabe des aktuellen Pfades
  public String getCurrentPath()
  {   
    return this.csvDir; 
  }

}