
/**
// Einlesen der Csv Daten
*/

public class DataReader
{
  private String csvFile;
  private String csvDir; //FIXME: Prop kann raus
  private String[] rawData;
  private ArrayList<String> busLinesAvailable;
  
  //FIXME: Methode kann raus
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
    rawData = loadStrings(/*csvDir+*/this.csvFile);
        
    
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
      
      for (int j=0; j < headDescription.length; j++)
      {
        String tmpColData = "";
        
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
                    
          //StartCounter erhöhen
          startCounter = endCounter+1;
        }
       
      }
      
      //Aufbereitete Daten zur ArrayList hinzufügen //<>//
      objectData.add(tmpData); //<>//
    }
   
    return objectData;
    
  }


    //Einlesen der Strassen
  public ArrayList<HashMap<String,String>> getCityStreets(String fileName)
  {
    String triggerText = "";
    String tmpColData = "";
    String tmpSplitCoords = "";
    String streetName = "";
    
    int startCounter = 0, endCounter = 0;
    //int startIndex = 3, endIndex = 0;
    HashMap tmpData;
    ArrayList<HashMap<String,String>> streetData = new ArrayList<HashMap<String,String>>();
    
    this.csvFile = fileName;   
    rawData = loadStrings(this.csvFile);
    
    
       ////Substring aufsplitten
    //tmpSplitData = tmpColData.split(",");
    println (">>>>>>>>>>>>>>>>>>>>>>>>> START");
    for (int i = 1; i < rawData.length; i++)
    {
     tmpData = new HashMap();
     tmpColData = rawData[i];
     
     //Bezeichnung auslesen
     endCounter = tmpColData.lastIndexOf(",");
     startCounter = tmpColData.lastIndexOf(",",endCounter-1) + 1;
     streetName = tmpColData.substring(startCounter,endCounter);
     tmpData.put("bezeichnung",streetName);
     
     //Koordinaten vorverarbeiten und ausschneiden
     triggerText = "((";
     startCounter = tmpColData.indexOf(triggerText) + triggerText.length();
     triggerText = "))\",";
     endCounter = tmpColData.indexOf(triggerText);
     tmpSplitCoords = tmpColData.substring(startCounter,endCounter).replace("),(",";");
     
     tmpData.put("coords",tmpSplitCoords);
      
     streetData.add(tmpData);
      
     //FIXME: Debugging
     //println ("Bezeichnung --> " + tmpData.get("bezeichnung") + " | start --> " + startCounter + " | end --> " + endCounter);
     //println (" | start --> " + startCounter + " | end --> " + endCounter + " | String L --> " + tmpColData.length());
     //println (tmpSplitCoords);
     //println("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
     //println(tmpColData);
     //printArray(tmpSplitData);
    }
    
    
    
    
    
    return streetData;
  }




    //Einlesen der Parks
  public ArrayList<HashMap<String,String>> getCityBusLines(String fileName)
  {
    String triggerText = "";
    String tmpColData = "";
    String tmpSplitCoords = "";
    int startCounter = 0, endCounter = 0;
    HashMap tmpData;
    ArrayList<HashMap<String,String>> busData = new ArrayList<HashMap<String,String>>();
    
    
    this.csvFile = fileName;   
    rawData = loadStrings(this.csvFile);
    
    for (int i = 1; i < rawData.length; i++)
    {
      tmpData = new HashMap();
      
      tmpData.put("id",String.valueOf(i));
      
      //Bezeichnung auslesen
      tmpColData = rawData[i];
      startCounter = tmpColData.lastIndexOf(",") + 1;
      endCounter = tmpColData.length();
      tmpData.put("linien",tmpColData.substring(startCounter,endCounter).replace("-"," "));
      
      //Koordinaten vorverarbeiten und ausschneiden
      triggerText = " ((";
      startCounter = tmpColData.indexOf(triggerText) + triggerText.length();
      triggerText = "))\",";
      endCounter = tmpColData.indexOf(triggerText);
      
      tmpSplitCoords = tmpColData.substring(startCounter,endCounter).replace("),(",",");
      
      ////Koordinaten speichern
      tmpData.put("coords",tmpSplitCoords);
      
      busData.add(tmpData);

    }
    
    return busData;
  }



















  
    //Einlesen der Parks
  public ArrayList<HashMap<String,String>> getCityParks(String fileName)
  {
    String triggerText = "";
    String tmpColData = "";
    String tmpSplitCoords = "";
    String[] tmpSplitData;
    int startCounter = 0, endCounter = 0;
    int startIndex = 3, endIndex = 0;
    HashMap tmpData;
    ArrayList<HashMap<String,String>> parkData = new ArrayList<HashMap<String,String>>();
    
    
    this.csvFile = fileName;   
    rawData = loadStrings(this.csvFile);
    endIndex = rawData.length - 3;
    //Benötigte Daten aus String ausschneiden
    //startCounter = rawData[4].indexOf(triggerText) + triggerText.length();
    //triggerText = "] ] } }";
    //endCounter = rawData[4].indexOf(triggerText);
    //tmpColData = rawData[4].substring(startCounter,endCounter);
    
    ////Substring aufsplitten
    //tmpSplitData = tmpColData.split(",");
    
    for (int i = startIndex; i <= endIndex; i++)
    {
      tmpData = new HashMap();
      
      //Bezeichnung auslesen
      triggerText = "bezeichnung";
      tmpColData = rawData[i];
      startCounter = tmpColData.indexOf(triggerText) + triggerText.length() + 2;
      triggerText = " }, ";
      endCounter = tmpColData.indexOf(triggerText,startCounter);
      tmpData.put("bezeichnung",tmpColData.substring(startCounter,endCounter));
      
      //Koordinaten vorverarbeiten und ausschneiden
      triggerText = "[ [ [ [ ";
      startCounter = tmpColData.indexOf(triggerText) + triggerText.length();
      triggerText = " ] ] ] ] } }";
      endCounter = tmpColData.indexOf(triggerText);
      
      tmpSplitCoords = tmpColData.substring(startCounter,endCounter).replace(" ], [",";");
      tmpSplitCoords = tmpSplitCoords.replace("[","").replace("]","").replace(" ","");
      
      //Koordinaten aufbereiten
      //tmpSplitData = tmpSplitCoords.split(";");
      tmpData.put("coords",tmpSplitCoords);
      
      parkData.add(tmpData);
      
      //FIXME: Debugging
      //println ("Bezeichnung --> " + tmpData.get("bezeichnung") + " | start --> " + startCounter + " | end --> " + endCounter);
     //println("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
      //println(tmpSplitCoords);
      //printArray(tmpSplitData);
    }
    
    //HashMap test = parkData.get(0);
    //String hoschi = String.valueOf(test.get("coords"));
    ////FIXME: Debugging
    //println ("Park Data --> ");
    //printArray (parkData.get(0).get("coords"));
    //println ("Ende der Datensätze --> " + rawData.length + " | Inhalt last --> " + rawData[endIndex]);
    
    
    return parkData;
  }
  
  
  
  
  //Einlesen der Stadtgrenzen
  public ArrayList<HashMap<String,String>> getCityBorder(String fileName)
  {
    String triggerText = "[ [ ";
    String tmpColData = "";
    String tmpSplitCoords = "";
    String[] tmpSplitData;
    int startCounter = 0, endCounter = 0;
    int tmpIndex = 0;
    HashMap<String, String> tmpData;
    ArrayList<HashMap<String,String>> borderData = new ArrayList<HashMap<String,String>>();
    
    
    this.csvFile = fileName;   
    rawData = loadStrings(this.csvFile);
        
    //Benötigte Daten aus String ausschneiden
    startCounter = rawData[4].indexOf(triggerText) + triggerText.length();
    triggerText = "] ] } }";
    endCounter = rawData[4].indexOf(triggerText);
    tmpColData = rawData[4].substring(startCounter,endCounter);
    
    ////Substring aufsplitten
    tmpSplitData = tmpColData.split(",");
    
    for (int i=0; i < tmpSplitData.length; i=i+2)
    {
      if ((i+1) < tmpSplitData.length)
      {
         tmpData = new HashMap<String,String>();
         tmpData.put("id",String.valueOf(i));
         
         //Longitude
         tmpSplitCoords = tmpSplitData[i];
         tmpIndex = tmpSplitCoords.indexOf("[")+2;
         tmpColData = tmpSplitCoords.substring(tmpIndex);
         tmpData.put("longitude",tmpColData);

         //Latitude
         tmpSplitCoords = tmpSplitData[i+1];
         tmpIndex = tmpSplitCoords.indexOf("]")-1;
         tmpColData = tmpSplitCoords.substring(0, tmpIndex);
         tmpData.put("latitude",tmpColData);
          
         borderData.add(tmpData);
      }
    }
    
    return borderData;
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  //TODO: Auslesen der Haltestellennamen, etc.
  //Einlesen der Busverbindungen
  public ArrayList<HashMap> getDataBus(String fileName)
  {
    String busCategory = "Stadtbus";
    String tmpColData = "";
    String[] tmpBusLines;
    int startCounter = 0, endCounter = 0;
    int commaMAX = 20, commaStrasse = 13, commaHnr = 15, commaPlz = 17, commaBez = 18, commaBetr = 19;
    HashMap<String, Object> tmpData;
    ArrayList<String> busRawData = new ArrayList<String>();
    ArrayList<HashMap> busData = new ArrayList<HashMap>();
    
    busLinesAvailable = new ArrayList<String>();
    
    
    this.csvFile = fileName;   
    rawData = loadStrings(/*csvDir+*/this.csvFile);
    
    //FIXME: Debugging
    //println("<<<<<<<<<<<<<Haltestellen>>>>>>>>>>>>>>>");
    //printArray(rawData);
    
    for (int i=1; i < rawData.length; i++)
    {
      //FIXME: Debugging
      //println("Enthält Stadtbus --> " + rawData[i].contains(busCategory));
      if (rawData[i].contains(busCategory) == true)
      {
        busRawData.add(rawData[i]);
      }
    }
      
    //FIXME: Debugging
    //println("Verbleibend --> " + busRawData.size());
    
    
    for (String bus : busRawData)
    {
      tmpData = new HashMap<String, Object>();
      
      //Latitude auslesen
      endCounter = bus.indexOf(',');
      tmpColData = bus.substring(startCounter,endCounter);
      tmpData.put("latitude",tmpColData);
      
      //FIXME: Debugging
      //println ("Bus --> Latitude --> " + tmpColData);
      
      
      
      //Longitude auslesen
      startCounter = endCounter + 1;
      endCounter = bus.indexOf(',',startCounter);
      tmpColData = bus.substring(startCounter,endCounter);
      tmpData.put("longitude",tmpColData);
      
      //FIXME: Debugging
      //println ("Bus --> Longitude --> " + tmpColData);
      
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
      
      //FIXME: Anpassung String mit Buslinien, statt Array
      tmpData.put("linien",tmpColData);
      
      tmpBusLines = new String[tmpColData.split(",").length];
      tmpBusLines = tmpColData.split(",");
      
      //Leerzeichen entfernen
      for (int i=0; i < tmpBusLines.length; i++)
      {
        String tmpLine = tmpBusLines[i].trim();
        tmpBusLines[i] = tmpLine;
        
        //FIXME: Debugging
        //println("Ausgabe hoffentlich ohne Leerzeichen -->" + tmpLine + "|" );
        
      }
      
      //Aufnehmen der Buslinien
      for (String line : tmpBusLines)
      {
        if (busLinesAvailable.contains(line) == false && line.equals("") != true && line.equals("Schulschwimmen") != true)
        {
          busLinesAvailable.add(line);
        }
      }
      
      endCounter = 0;
      startCounter = 0;
      
      for (int i=0; i < commaMAX; i++)
      {
        endCounter = bus.indexOf(',',startCounter);
        
        
        if (i == commaStrasse)
        {
          tmpColData = bus.substring(startCounter,endCounter);
          tmpData.put("strasse",tmpColData);
        }
        
        if (i == commaHnr)
        {
          tmpColData = bus.substring(startCounter,endCounter);
          tmpData.put("hausnummer",tmpColData);
        }
        
        if (i == commaPlz)
        {
          tmpColData = bus.substring(startCounter,endCounter);
          tmpData.put("plz",tmpColData);
        }
        
        if (i == commaBez)
        {
          tmpColData = bus.substring(startCounter,endCounter);
          tmpData.put("bezeichnung",tmpColData);
        }
        
        if (i == commaBetr)
        {
          tmpColData = bus.substring(startCounter,endCounter);
          tmpData.put("betreiber",tmpColData);
        }
        
                
        startCounter = endCounter + 1;
        
      }
      
      
      
      
      
      
      //FIXME: Debugging
      /*println ("Buslinien komplett:");
      printArray(busLinesAvailable);
      println("\n\n");
      println ("Anzahl ------------------------------------------> " + tmpBusLines.length + " ||| Buslinien --> ");
      printArray(tmpBusLines);*/      
      
      //FIXME: Auskommentiert
      //tmpData.put("linien",tmpBusLines);
      
      //FIXME: Debugging
      //println ("StartCounter Position --> " + startCounter + " | EndCounter Position --> " + endCounter + " || Länge Stadtbus --> " + busCategory.length() + " || Neuer Index --> " + (startCounter+busCategory.length()));
      //println ("Bus --> Linien --> " + tmpColData + "\n");
     
      busData.add(tmpData);
      
      //Counter zurücksetzen
      startCounter = 0;
      endCounter = 0;
    }
    
    /*
    //FIXME: Debugging
    println("\n\nDie eingelesenen Buslinien --> ");  
    for (HashMap bus : busData)
    {
      println("\nLatitude --> " + bus.get("latitude"));
      println("Longitude --> " + bus.get("longitude"));
      println("Linien --> ");
      printArray(bus.get("linien"));
    }*/
    
    
    return busData;
    
  }

}