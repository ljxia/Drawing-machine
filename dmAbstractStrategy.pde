class dmAbstractStrategy
{
  public dmContext context;
  
  dmAbstractStrategy(dmContext context)
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