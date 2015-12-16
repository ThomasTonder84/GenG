public class WriteLog
{
  
  
  public void WriteEntry(String Message)
  {
    PrintLog(Message);
    WriteLog(Message);
  }
  
  
  private void PrintLog(String Message)
  {
    println(Message);
  }
  
  private void WriteLog(String Message)
  {
  
  }
  
  public void CreateLog(String logPath)
  {
    
  }
}