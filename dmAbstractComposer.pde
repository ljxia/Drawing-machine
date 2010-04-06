class dmAbstractComposer
{
  protected dmCanvas canvas;
  
  dmAbstractComposer(dmCanvas canvas)
  {
    this.canvas = canvas;
  }
  
  void draw()
  {
    this.update();
    this.canvas.draw(0,0);
  }
  
  private void update()
  {
    this.canvas.update();
    
    this.review();
    if (!this.isDone())
    {
      this.compose();
    }
  }
  
  private void review()
  {
    
  }
  
  private boolean isDone()
  {
    return false;
  }
  
  private void compose()
  {
    //generate new commands
  }
}