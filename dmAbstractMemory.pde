abstract class dmAbstractMemory
{
  public String serverUrlBase = "http://localhost/~liangjie/impersonal/index.php/learn/";
  protected String serverMethod = "abstract"; 
  private Hashtable _data;
  
  dmAbstractMemory(){_data = new Hashtable();}
  abstract Object recall();
 
  public String memorize()
  {
    HttpRequest req = new HttpRequest();
    String url = serverUrlBase + serverMethod;
    debug("-----------------");
    debug("ping url: " + url);
    try
    {
      return req.send(url,"POST",this.getData(),null);
    }
    catch (Exception e){return "error: " + e.getMessage();}
  }
  
  public void setData(String dataKey, Object dataValue){this._data.put(dataKey, dataValue);}
  public void setData(Hashtable data){this._data = data;}
  public Hashtable getData(){return this._data;}
}