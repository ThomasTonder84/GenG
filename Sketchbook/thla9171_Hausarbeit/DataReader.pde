
/**
// Einlesen der Csv Daten
*/

public class DataReader
{
  private String csvFile;
  private String csvDir;
  private String[] rawData;
  private ArrayList<String> busLinesAvailable;
  
  public void SetFolder(String csvDir)
  {
    this.csvDir = csvDir;
    
    //Auf abschließenden Bachshlash prüfen
    if (this.csvDir.endsWith("\\") == false)
    {
      this.csvDir += "\\";
    }
    
    //FIXME: Debugging
    println("Pfad --> " + this.csvDir);
    
  }

  //Ausgabe der kompletten Buslinien
  public ArrayList<String> getAvailableBusLines()
  {
    return busLinesAvailable;
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
  

  //Muss zeilenweise verarbeitet werden
  public ArrayList<HashMap> getDataPoi(String fileName)
  {
    ArrayList<HashMap> objectData = new ArrayList<HashMap>();
    
    this.csvFile = fileName;   
    rawData = loadStrings(csvDir+this.csvFile);
        
    
    //Auslesen der Feldbeschreibungen
    String[] headDescription = split(rawData[0], ',');
    
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
        
        //FIXME: Debugging       
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
          
          if (tmpRawData.charAt(startCounter) == '"')
          {
            
            int tmpCounter  = endCounter + 1;
            println ("XXXXXXXXXX In Abfrage Anführungszeichen! tmpCounter --> " + tmpCounter); //FIXME: Debugging
            endCounter = tmpRawData.indexOf(',',tmpCounter);
            
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
      
      //Aufbereitete Daten zur ArrayList hinzufügen //<>//
      objectData.add(tmpData); //<>//
      
      
    //FIXME: Debugging
    println("Datensatz "+i);
    printArray(objectData.get(i-1));
      
    }
    
    
    //FIXME: Debugging
    printArray(headDescription);
    
    return objectData;
    
  }
  
  //TODO: verschiedene Buslinien in separatem Array speichern busLinesAvailable!!!!!!
  //Einlesen der Busverbindungen
  public ArrayList<HashMap> getDataBus(String fileName)
  {
    String busCategory = "Stadtbus";
    String tmpColData = "";
    String[] tmpBusLines;
    int startCounter = 0, endCounter = 0;
    HashMap tmpData;
    ArrayList<String> busRawData = new ArrayList<String>();
    ArrayList<HashMap> busData = new ArrayList<HashMap>();
    
    busLinesAvailable = new ArrayList<String>();
    
    
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
      
    //FIXME: Debugging
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
      
      //Auslesen der Linien bis " vor dem Komma
      //Damit die Aufteilung der Datenfelder korrekt ist
      if ((bus.charAt(startCounter)) == '"')
      {
        startCounter++;
        endCounter = bus.indexOf('"',startCounter);
        
      }
      else
      {
        endCounter = bus.indexOf(',',startCounter);
      }
      
      //Aufteilen und Hinzufügen der Buslinien
      tmpColData = bus.substring(startCounter,endCounter);
      tmpBusLines = new String[tmpColData.split(",").length];
      tmpBusLines = tmpColData.split(",");
      
      
      //Leerzeichen entfernen
      for (int i=0; i < tmpBusLines.length; i++)
      {
        String tmpLine = tmpBusLines[i].trim();
        tmpBusLines[i] = tmpLine;
        
        //FIXME: Debugging
        println("Ausgabe hoffentlich ohne Leerzeichen -->" + tmpLine + "|" );
        
      }
      
      //TODO: Aufnehmen der Buslinien
      for (String line : tmpBusLines)
      {
        if (busLinesAvailable.contains(line) == false && line.equals("") != true && line.equals("Schulschwimmen") != true)
        {
          busLinesAvailable.add(line);
        }
        //FIXME: Else nur für Debugging
        else
        {
          println("Buslinie schon vorhanden --> " + line);
        }
      }
      
      
      
      //FIXME: Debugging
      println ("Buslinien komplett:");
      printArray(busLinesAvailable);
      println("\n\n");
      println ("Anzahl ------------------------------------------> " + tmpBusLines.length + " ||| Buslinien --> ");
      printArray(tmpBusLines);      
      
      tmpData.put("linien",tmpBusLines);
      
      //FIXME: Debugging
      println ("StartCounter Position --> " + startCounter + " | EndCounter Position --> " + endCounter + " || Länge Stadtbus --> " + busCategory.length() + " || Neuer Index --> " + (startCounter+busCategory.length()));
      println ("Bus --> Linien --> " + tmpColData + "\n");
     
      busData.add(tmpData);
      
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
    
    
    return busData;
    
  }

}