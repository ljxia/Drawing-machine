public abstract class dmAbstractMemory
{
  public String serverUrlBase = Config.API_URL;
  protected String serverMethod = "abstract"; 
  protected Hashtable _data;
  
  dmAbstractMemory(){_data = new Hashtable();}
  
  public String recall(Hashtable params)
  {
    HttpRequest req = new HttpRequest();
    String url = serverUrlBase + serverMethod + "/get";
    debug("-----------------");
    debug("load from url: " + url);
    debug("POST param:" + params.toString());
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
    //debug("ping url: " + url);
    //debug("POST param:" + this.getData().toString());
    try
    {
      String res = req.send(url,"POST",this.getData(),null);
      debug(res);
      return res;
    }
    catch (Exception e){return "error: " + e.getMessage();}
  }
  
  public String update(int id)
  {
    if (id > 0)
    {
      HttpRequest req = new HttpRequest();
      String url = serverUrlBase + serverMethod + "/update/" + id;
      debug("-----------------");
      debug("ping url: " + url);
      debug("POST param:" + this.getData().toString());
      try
      {
        String res = req.send(url,"POST",this.getData(),null);
        debug(res);
        return res;
      }
      catch (Exception e){return "error: " + e.getMessage();}
    }
    else
    {
      return "Id is required to update " + this.serverMethod;
    }
  }
  
  public void setData(String dataKey, Object dataValue){this._data.put(dataKey, dataValue);}
  public void setData(Hashtable data){this._data = data;}
  public Hashtable getData(){return this._data;}
  public Object getData(String datakey){return this._data.get(datakey);}
}