abstract class dmAbstractMemory
{
  public String serverUrlBase = "http://localhost/~liangjie/impersonal/index.php/";
  protected String serverMethod = "abstract"; 
  private Hashtable _data;
  
  dmAbstractMemory(){_data = new Hashtable();}
  
  public String recall(Hashtable params)
  {
    HttpRequest req = new HttpRequest();
    String url = serverUrlBase + serverMethod + "/get";
    debug("-----------------");
    debug("load from url: " + url);
    try
    {
      return req.send(url,"POST",params,null);
    }
    catch (Exception e){return "error: " + e.getMessage();}
  }
 
  public String memorize()
  {
    HttpRequest req = new HttpRequest();
    String url = serverUrlBase + "learn/" + serverMethod;
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