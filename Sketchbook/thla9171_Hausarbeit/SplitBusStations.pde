
//TODO:
//HashMap erstellen, sortiert nach Buslinien
//Code aufräumen und entmüllen

class SplitBusStations
{
  private ArrayList<HashMap> myUnsortedStations;
  
  SplitBusStations(ArrayList<HashMap> busStations)
  {
      
      this.myUnsortedStations = busStations;

  }


  public ArrayList<HashMap> Split(String busLine)
  {
    //TODO: Buslinien müssen nicht gesplittet werden --> geht mit .contains()
    
    ArrayList<HashMap> currentLine = new ArrayList<HashMap>();
    HashMap<String, Object> tmpEntry;
    
    
    for (HashMap entry : myUnsortedStations)
    {
      
      String tmpLine = entry.get("linien").toString();
      
      if (tmpLine.contains(busLine) == true)
      {
        tmpEntry = new HashMap<String, Object>();
        tmpEntry.putAll(entry);
        tmpEntry.replace("linien",busLine);
        currentLine.add(tmpEntry);
        
        //FIXME: Debugging
        printArray(tmpEntry);
        
      }
      
    }
    
    return currentLine;
    
  }


  

}