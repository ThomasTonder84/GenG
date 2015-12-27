
/**
// Einlesen der Csv Daten
*/

public class DataReader
{
  private String csvFile;
  private String csvDir;
  private String[] rawData;
  
  public void SetFolder(String csvDir)
  {
    //FIXME: Pfad auf abschließenden Backslash prüfen
    this.csvDir = csvDir;
    
    //Auf abschließenden Bachshlash prüfen
    if (this.csvDir.endsWith("\\") == false)
    {
      this.csvDir += "\\";
    }
    
    //FIXME: Debugging
    println("Pfad --> " + this.csvDir);
    
  }
    
  public ArrayList<HashMap> getAllDataPoi(String[] fileNames)
  {
    ArrayList<HashMap> allObjectData = new ArrayList<HashMap>();
    ArrayList<HashMap> tmpObjectData = new ArrayList<HashMap>();
    
    for (String fileName: fileNames)
    {
      //FIXME: Debugging
      println("<<<<<<<<<<<<<< " + fileName + "  >>>>>>>>>>>>>>>>>>>>>>>>>");
      tmpObjectData = getDataPoi(fileName);
      
      for (HashMap poiObject : tmpObjectData)
      {
        allObjectData.add(poiObject);
      }
    }
    
    return allObjectData;
    
  }
  

  //FIXME: void muss durch DataObject ersetzt werden, da dieses Objekt am Ende zurückgegeben werden soll
  //Muss zeilenweise verarbeitet werden
  public ArrayList<HashMap> getDataPoi(String fileName)
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
      //Zu verarbeitende Zeile (Datensatz)
      String tmpRawData = rawData[i];
      int startCounter = 0;
      int endCounter = 0;
      
      HashMap tmpData = new HashMap();
      
      println("Länge des aktuellen Satzes --> " + tmpRawData.length());
      println("Auszug aus RawData --> Index:"+i+" --> " + tmpRawData);
      
      
      for (int j=0; j < headDescription.length; j++)
      {
        String tmpColData = "";
        
        //TODO:
        //Abfrage ob endCounter == lastindexOf(',') --> Dann letzten SubString lesen
        //Sonst wie gewohnt weiter
        
        println("Position des letzten Kommas --> " + tmpRawData.lastIndexOf(','));
        
        if ((tmpRawData.length()-1) != startCounter)
        {
        
          if (endCounter != tmpRawData.lastIndexOf(','))
          {
            endCounter = tmpRawData.indexOf(',',startCounter);
          }
          else
          {
            endCounter = tmpRawData.length()-1;
          }
          
          //TODO:
          //Prüfen ob StartCounter == " 
          //Prüfen ob EndCounter Inhalt == "
          if (tmpRawData.charAt(startCounter) == '"')
          {
            
            int tmpCounter  = endCounter + 1;
            println ("XXXXXXXXXX In Abfrage Anführungszeichen! tmpCounter --> " + tmpCounter);
            endCounter = tmpRawData.indexOf(',',tmpCounter);
            
            //if (tmpRawData.charAt(endCounter-1) == '"')
            //{
            //  endCounter--;
            //}
          }
          
          
          if ((endCounter-startCounter)==1)
          {
            tmpData.put(headDescription[j],"");
          }
                    
          //Auslesen des Substring
          tmpColData = tmpRawData.substring(startCounter,endCounter);
          
          //Für weitere Verarbeitung speichern
          tmpData.put(headDescription[j],tmpColData);
                    
          //FIXME: Debugging
          println("Head Length --> " + headDescription.length);
          println("StartCounter --> " + startCounter + " | EndCounter --> " + endCounter);
          println("Start Inhalt --> " + tmpRawData.charAt(startCounter) + " | End Inhalt --> " + tmpRawData.charAt(endCounter));
          println("Substring --> " + tmpColData);
                    
          //StartCounter erhöhen
          startCounter = endCounter+1;
        }
      }
 //<>//
      objectData.add(tmpData); //<>//
      
      
      
    println("Datensatz "+i);
    printArray(objectData.get(i-1));
      
    }
    
    
    
    printArray(headDescription);
    
    
    //TODO: Löschen nur zum Test
    HashMap test = objectData.get(1);
    println(test.get("bezeichnung"));
    println(test.keySet());
    println(test.values());
    
    
    return objectData;
    
  }
  
  //TODO: Rückgabe vom Typ ArrayList<HashMap>
  //Einlesen der Busverbindungen
  public void getDataBus(String fileName)
  {
    String busCategory = "Stadtbus";
    String tmpColData = "";
    String[] tmpBusLines;
    int startCounter = 0, endCounter = 0;
    HashMap tmpData;
    ArrayList<String> busRawData = new ArrayList<String>();
    ArrayList<HashMap> busData = new ArrayList<HashMap>();
    
    
    this.csvFile = fileName;   
    rawData = loadStrings(csvDir+this.csvFile);
    
    println("<<<<<<<<<<<<<Haltestellen>>>>>>>>>>>>>>>");
    printArray(rawData);
    
    for (int i=1; i < rawData.length; i++)
    {
      println("Enthält Stadtbus --> " + rawData[i].contains(busCategory));
      if (rawData[i].contains(busCategory) == true)
      {
        busRawData.add(rawData[i]);
      }
    }
      
    //FIXME: Debug
    println("Verbleibend --> " + busRawData.size());
    
    
    for (String bus : busRawData)
    {
      tmpData = new HashMap();
      
      //Latitude auslesen
      endCounter = bus.indexOf(',');
      tmpColData = bus.substring(startCounter,endCounter);
      tmpData.put("latitude",tmpColData);
      
      //FIXME: Debugging
      println ("Bus --> Latitude --> " + tmpColData);
      
      
      
      //Longitude auslesen
      startCounter = endCounter + 1;
      endCounter = bus.indexOf(',',startCounter);
      tmpColData = bus.substring(startCounter,endCounter);
      tmpData.put("longitude",tmpColData);
      
      //FIXME: Debugging
      println ("Bus --> Longitude --> " + tmpColData);
      
      
      //Linien auslesen
      startCounter = bus.indexOf(busCategory);
      startCounter += busCategory.length() + 1;
      
      //TODO: Auslesen der Linien bis " vor dem Komma
      if ((bus.charAt(startCounter)) == '"')
      {
        startCounter++;
        endCounter = bus.indexOf('"',startCounter);
        
      }
      else
      {
        endCounter = bus.indexOf(',',startCounter);
      }
      
      //TODO: Leerzeichen entfernen!!!!!!!
      tmpColData = bus.substring(startCounter,endCounter);
      
      for (int i=0; i < tmpColData.length(); i++)
      {
        String tmpLine = "";
        
        //TODO: Leerzeichen entfernen
      }
      
      
      //TODO: Vor hinzufügen der Werte müssen die Leerzeichen entfernt werden trim()
      tmpBusLines = new String[tmpColData.split(",").length];
      tmpBusLines = tmpColData.split(",");
      println ("Anzahl ------------------------------------------> " + tmpBusLines.length + " ||| Buslinien --> ");
      printArray(tmpBusLines);
      
      tmpData.put("linien",tmpBusLines);
      
      //FIXME: Debugging
      println ("StartCounter Position --> " + startCounter + " | EndCounter Position --> " + endCounter + " || Länge Stadtbus --> " + busCategory.length() + " || Neuer Index --> " + (startCounter+busCategory.length()));
      println ("Bus --> Linien --> " + tmpColData + "\n");
      
      if (tmpData.get("linien") != null || tmpData.get("linien") != "" )
      {
        busData.add(tmpData);
      }
      
      
      //Counter zurücksetzen
      startCounter = 0;
      endCounter = 0;
    }
    
    
    //FIXME: Debugging
    println("\n\nDie eingelesenen Buslinien --> ");
    
    for (HashMap bus : busData)
    {
      println("\nLatitude --> " + bus.get("latitude"));
      println("Longitude --> " + bus.get("longitude"));
      println("Linien --> ");
      printArray(bus.get("linien"));
    }
    
  }

}