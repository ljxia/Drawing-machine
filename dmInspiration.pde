class dmInspiration extends dmAbstractMemory
{
  public String TYPE_FILE = "file";
  public String TYPE_WEB = "web";
  
  public String type;
  public String url;
  public String filehash;
  
  public int id;
  
  public PImage image;
  
  dmInspiration(String source)
  {
    this.id = 0;
    
    this.serverMethod = "inspiration";
    this.image = loadImage(source);
        
    for (int i = 0; i < this.image.width; i++) {
      this.image.pixels[i] = color(255,255,255); 
      this.image.pixels[this.image.width + i] = color(255,255,255); 
      this.image.pixels[(this.image.height - 2) * this.image.width + i] = color(255,255,255); 
      this.image.pixels[(this.image.height - 1) * this.image.width + i] = color(255,255,255); 
    }

    for (int i = 0; i < this.image.height; i++) {
      this.image.pixels[i * this.image.width] = color(255,255,255); 
      this.image.pixels[i * this.image.width + 1] = color(255,255,255); 
      this.image.pixels[i * this.image.width + this.image.width - 2] = color(255,255,255); 
      this.image.pixels[i * this.image.width + this.image.width - 1] = color(255,255,255); 
    }

    this.image.updatePixels();
   
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
    if (this.type.equals(TYPE_FILE))
    {
      this.setData("filehash", getFileSHA1(this.url));
    }
    
    
    int newId = -1;
    
    debug("saving inspiration....");
    
    String result = super.memorize().trim();

    newId = int(result);

    if (newId > 0)
    {
      this.id = newId;      
      //upload the file
      info("inspiration saved: #" + newId);
      uploadImageFile(newId);
      return this.id + "";
    }
    else if (newId < 0)
    {
      this.id = -1 * newId;
      info("existing inspiration found: #" + newId);
      return this.id + "";
    }
    else
    {
      return "nah";
    }
    
  }
  
}