import java.util.Hashtable;

class dmAbstractComposer
{
  protected PApplet applet;
  protected dmCanvas canvas;
  
  public dmDrawingContext context;
  public dmAbstractStrategy strategy;
  
  dmAbstractComposer(PApplet applet, dmCanvas canvas)
  {
    this.applet = applet;
    this.canvas = canvas;
    this.context = new dmDrawingContext(applet, canvas);
    this.strategy = new dmInstinctiveStrategy(this.context);
    this.reset();
  }
  
  void reset()
  {
    this.canvas.clear();
    this.context.reset();
  }
  
  void draw()
  {
    this.update();
    this.canvas.draw(0,0);
  }
  
  protected void update()
  {
    if (this.canvas.update())
    {
      this.canvas.saveImage(this.context.snapshot);
    }
    this.context.update();
    
    if (this.context.isIdle())
    {
      if (!this.isDone())
      {
        this.compose();
      }
      else
      {
        this.save();
        this.reset();
      }
    }
  }
  
  protected void save()
  {
    SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd-HHmmss");
    String name = "drawings/" + df.format(new Date()) + ".png";
    this.canvas.pushBuffer();
    this.canvas.dumpBuffer(name);
    
    sendMail(savePath(name));
  }
  
  protected boolean isDone()
  {
    return this.context.isFinished();
  }
  
  protected void compose()
  {
    this.strategy.compose();
  }
  
  boolean isPaused()
  {
    return this.context.isPaused();
  }
  
  void pause()
  {
    this.context.pause();
  }
  
  void play()
  {
    this.context.resume();
  }
}