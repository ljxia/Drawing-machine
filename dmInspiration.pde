class dmInspiration extends dmAbstractMemory
{
  public String TYPE_FILE = "file";
  public String TYPE_WEB = "web";
  
  public String type;
  public String url;
  
  public PImage image;
  
  dmInspiration(String source)
  {
    this.serverMethod = "inspiration";
    this.image = loadImage(source);
    
    debug("image loaded from " + source);
    debug(this.image.width + ", " + this.image.height);
    
    if (source.substring(0,4).toLowerCase().equals("http"))
    {
      this.type = TYPE_WEB;
    }
    else
    {
      this.type = TYPE_FILE;
    }
    
    this.url = savePath("data/" + source);    
  }
  
  
  public int getWidth()
  {
    if (this.image != null)
    {
      return this.image.width;
    }
    return -1;
  }
  
  public int getHeight()
  {
    if (this.image != null)
    {
      return this.image.height;
    }
    return -1;
  }
  
  private String uploadImageFile(int inspirationId)
  {
    if (this.type.equals(TYPE_FILE))
    {
      String serverUrl = serverUrlBase + "upload/" + serverMethod + "/" + inspirationId;
      debug("sending file to " + serverUrl);
      debug("file: " + this.url);
      return uploadFile(serverUrl, this.url);
    }
    else
    {
      return "not implemented yet";
    }
  }
  
  public String memorize()
  {
    this.setData("width",this.getWidth());
    this.setData("height",this.getHeight());
    this.setData("type",this.type);
    this.setData("url",this.url);
    
    int newId = -1;
    
    debug("saving inspiration....");
    
    String result = super.memorize().trim();

    newId = int(result);

    if (newId > 0)
    {      
      //upload the file
      debug("inspiration saved: #" + newId);
      uploadImageFile(newId);
      return "ok";
    }
    else
    {
      return "nah";
    }
    
  }
  
}