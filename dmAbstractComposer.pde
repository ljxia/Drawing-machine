class dmAbstractComposer
{
  protected dmCanvas _canvas;
  
  dmAbstractComposer(dmCanvas canvas)
  {
    this._canvas = canvas;
  }
  
  void draw()
  {
    this.update();
  }
  
  private void update()
  {
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