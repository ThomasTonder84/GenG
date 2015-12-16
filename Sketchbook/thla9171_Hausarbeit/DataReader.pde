


public class DataReader
{
  private String csvFile;
  private String csvDir;
  private String[] rawData;
  
  DataReader(String csvDir)
  {
    //FIXME: Pfad auf abschließenden Backslash prüfen
    this.csvDir = csvDir;
  }

  //FIXME: void muss durch DataObject ersetzt werden, da dieses Objekt am Ende zurückgegeben werden soll
  public void getData(String fileName)
  {
    this.csvFile = fileName;   
    rawData = loadStrings(csvDir+this.csvFile);
    //(rawData);
    
    printArray(rawData);
    
  }
  
  //FIXME: Prüfung auf Existenz der Datei prüfen und korrekten Wert zurückgeben
  public Boolean isCurrentPathCorrect()
  {
    return true;
  }
 
   //FIXME: korrekte Anzahl ausgeben
  //Anzahl der CSV Dateien ausgeben
  public int getCsvCount()
  {
    return 10;
  }
  
  //FIXME: Dateinamen zurückgeben
  /*public String[] getCsvFileNames()
  {
    return {"jo",""};
  }*/
  
  //Ausgabe des aktuellen Pfades
  public String getCurrentPath()
  {   
    return this.csvDir; 
  }

}