import java.util.Hashtable;

class dmAbstractComposer
{
  protected PApplet applet;
  protected dmCanvas canvas;
  
  public dmContext context;
  public dmAbstractStrategy strategy;
  public dmEvaluation evaluation;
  
  dmAbstractComposer(PApplet applet, dmCanvas canvas)
  {
    this.applet = applet;
    this.canvas = canvas;
    this.context = new dmContext(applet, canvas);
    this.strategy = new dmInstinctiveStrategy(this.context);

    this.evaluation = new dmEvaluation();
    
    evaluation.addRule("CHAOS", new dmAbstractEvaluationRule(), 1);
    evaluation.addRule("SYMME", new dmSymmetryRule(), 5);

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
  
  void review()
  {
    if (millis() > this.context.lastReviewTime + this.context.nextReviewTime)
    {
      float score = this.evaluation.evaluate(this.context);
      
      if (this.evaluation.lastScore > 0)
      {
        this.context.adjustMotivation(score - this.evaluation.lastScore);
        
        if (score - this.evaluation.lastScore < 0)
        {
          this.context.setReviewTime(1000);
        }
        
      }
      
      this.evaluation.applyScore();
      
    }
  }
  
  protected boolean update()
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
        this.review();
        this.compose();
        return false;
      }
      else
      {
        this.save();
        this.reset();
        return true;
      }
    }
    
    return false;
  }
  
  protected void save()
  {
    SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd-HHmmss");
    String name = "drawings/" + df.format(new Date()) + ".png";
    this.canvas.pushBuffer();
    this.canvas.dumpBuffer(name);
    
    this.evaluation.reset();
    
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
  
  protected void finish()
  {

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