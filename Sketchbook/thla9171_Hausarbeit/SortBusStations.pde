
//TODO:
//HashMap erstellen, sortiert nach Buslinien
//

class SortBusStations
{
  private ArrayList<HashMap> myUnsortedStations;
  private ArrayList<String> allBusLines;
  private HashMap<String, HashMap<String, Object>> mySortedStations;
  
  SortBusStations(ArrayList<HashMap> busStations, ArrayList<String> allBusLines)
  {
      
      this.myUnsortedStations = busStations;
      this.allBusLines = allBusLines;
      
      
      //Initialisieren der ArrayList mit den Buslinien
      InitSortedList();
      
      SplitBusStations();
      
      //FIXME: Debugging
      println("aus sort ");
      printArray(this.allBusLines);
      //printArray(this.myUnsortedStations);
      println(myUnsortedStations.get(0));
      println(busStations.get(0));
  }

  private void InitSortedList()
  {
     mySortedStations = new HashMap<String, HashMap<String, Object>>();
    
    for (String station : allBusLines)
    {
      mySortedStations.put(station, new HashMap<String, Object>()); 
    }
    
    //FIXME: Debugging
    //mySortedStations.get("23").put("22","Hey Hey!");
    
    printArray(mySortedStations);

    println ("Manueller Zugriff --> " + mySortedStations.get("23"));
    
    
  }

  private void SplitBusStations()
  {
    //TODO: Buslinien müssen nicht gesplittet werden --> geht mit .contains()
    
    for (HashMap map : myUnsortedStations)
    {
      String test = map.get("linien").toString(); 
      
      if (test.contains("F1A") == true)
      {
        println(map.get("latitude") + " | " + map.get("longitude") + " | " + map.get("linien"));
      }
      
      //for (int i=0; i < map.get("linien"). ; i++)
      //{}
      
      //FIXME: Debugging
      /*println("Lines --> " + test);
      println("Contains --> " + test.contains("45"));
      println("Matches --> " + test.matches("45"));
      printArray(map.get("linien").getClass() );
      */
    }
  }


  public HashMap<String, HashMap<String, Object>> getSortedStations()
  {
    
    
   return mySortedStations;
  }
  
  

}