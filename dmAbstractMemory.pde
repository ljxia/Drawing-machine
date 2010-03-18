abstract class dmAbstractMemory
{
  public String serverUrlBase = "http://localhost/~liangjie/impersonal/Learn/";
  protected String serverMethod = "abstract"; 
  private Hashtable _data;
  
  dmAbstractMemory(){}
  abstract void recall();
 
  public String memorize()
  {
    HttpRequest req = new HttpRequest();
    String url = serverUrlBase + serverMethod;

    try
    {
      return req.send(url,"POST",this.getData(),null);
    }
    catch (Exception e){return "";}
  }
  
  public void setData(Hashtable data){this._data = data;}
  public Hashtable getData(){return this._data;}
}