import java.util.Hashtable;

class dmAbstractComposer
{
  protected dmCanvas canvas;
  protected float gaugeMotivation;
  
  dmAbstractComposer(dmCanvas canvas)
  {
    this.canvas = canvas;
  }
  
  void draw()
  {
    this.update();
    this.canvas.draw(0,0);
  }
  
  protected void update()
  {
    this.canvas.update();
    
    this.review();
    if (!this.isDone())
    {
      this.compose();
    }
  }
  
  protected void review()
  {
    
  }
  
  protected boolean isDone()
  {
    return false;
  }
  
  protected void compose()
  {
    //generate new commands
  }
}