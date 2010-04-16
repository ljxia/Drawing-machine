class dmAbstractStrategy
{
  public dmDrawingContext context;
  
  dmAbstractStrategy(dmDrawingContext context)
  {
    this.context = context;
  }
  
  dmCanvas canvas()
  {
    return this.context.canvas;
  }
  
  public void update()
  {
    
  }
  
  public boolean compose()
  {
    return false;
  }
}