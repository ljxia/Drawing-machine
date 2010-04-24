class dmCanvasMemory extends dmCanvas
{
  //directly draws to buffer than onto the screen
  PGraphics content;
  
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
  
  public void draw(int x, int y)
  {
    this.corner.set(x,y,0); 
  }
  
  void callback()
  {
    this.content.save("tmp/" + millis() + ".png");
  }
  
}