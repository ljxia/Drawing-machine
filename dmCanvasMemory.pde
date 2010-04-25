class dmCanvasMemory extends dmCanvas
{
  //directly draws to buffer than onto the screen
  PGraphics content;
  String serverUrl;
  
  dmCanvasMemory(int w, int h)
  {
    super(w, h);
    this.content = createGraphics(this.width, this.height, JAVA2D);
  }
  
  boolean isDone()
  {
    return !this.inMotion() && this.commands.size() == 0;
  }
  
  boolean update()
  {
    super.update();
    this._brush.draw(this.content);
    this._brush.update();
    
    if (this.isDone())
    {
      this.callback();
      return true;
    }
    
    return false;
  }
  
  public void popBuffer()
  {
    return;
  }
  
  public void draw(int x, int y)
  {
    return;
    //this.corner.set(x,y,0); 
  }
  
  public void setRemoteUrl(String url)
  {
    this.serverUrl = url;
  }
  
  void callback()
  {
    String filename = "tmp/" + millis() + ".png";
    this.content.save(filename);
    
    
    if (!this.serverUrl.equals(""))
    {
      filename = savePath(filename);
      uploadFile(serverUrl, filename);
    }
  }
  
}