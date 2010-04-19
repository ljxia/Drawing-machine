class dmContext
{
  protected PApplet applet;
  protected dmCanvas canvas;
  
  public boolean paused = false;
  public PImage snapshot;
  
  protected boolean inMotion = false;
  
  protected float startTime;
  protected float pauseTime;
  protected float pauseLength;
  
  protected float gaugeUptime;
  protected float gaugeStepCount;
  protected float gaugeMotivation;
  protected float gaugeCommandQueue;
  
  protected float thresholdUptime;
  protected float thresholdStepCount;
  protected float thresholdMotivation;
  protected float thresholdCommandQueue;
  
  protected float lastReviewTime;
  protected float nextReviewTime;
  
  dmContext(PApplet applet, dmCanvas canvas)
  {
    this.applet = applet;
    this.canvas = canvas;
    
    this.snapshot = createImage(this.canvas.width, this.canvas.height, ARGB);
    
    this.thresholdUptime = 5 * 60 * 1000;
    this.thresholdStepCount = 500;
    this.thresholdMotivation = 100;
    this.thresholdCommandQueue = 50;
  }
  
  public void adjustMotivation(float motif)
  {
    this.gaugeMotivation += motif;
  }
  
  protected void reset()
  {
    this.startTime = millis();
    this.pauseTime = 0;
    this.pauseLength = 0;
    this.inMotion = false;
    
    this.thresholdUptime = random(1, 10) * 60 * 1000;
    this.thresholdStepCount = random(10,1000);
    
    this.gaugeUptime = -1;
    this.gaugeStepCount = 0;
    this.gaugeMotivation = random(70,90);
    
    this.setReviewTime();
  }
  
  public boolean isFinished()
  {
    if (this.gaugeUptime > this.thresholdUptime)
    {
      if (this.gaugeUptime > 1000 || this.gaugeMotivation < 50)
      {
        return true;
      }
      else
      {
        //procrastinate
        this.thresholdUptime += floor(this.gaugeMotivation * random(0,1) * 1000);
      }
    }
    
    if (this.gaugeStepCount > this.thresholdStepCount)
    {
      if (this.gaugeStepCount > 1000 || this.gaugeMotivation < 50)
      {
        return true;
      }
      else
      {
        //procrastinate a bit
        this.thresholdStepCount += floor(this.gaugeMotivation * random(0.5,1));
      }
      
    }
    
    if (this.gaugeMotivation < 0)
    {
      return true;
    }
    
    return false;
  }
  
  public boolean isPaused()
  {
    return this.paused;
  }
  
  public boolean isIdle()
  {
    return !this.paused && !this.inMotion;
  }
  
  public void pause()
  {
    this.paused = true;
    this.pauseTime = millis();
  }
  
  public void resume()
  {
    this.paused = false;
    this.pauseLength = pauseLength + (millis() - pauseTime);
  }
  
  public void setReviewTime()
  {
    this.setReviewTime(random(5, 10) * 1000);
  }
  
  public void setReviewTime(float timespan)
  {
    this.lastReviewTime = millis();
    this.nextReviewTime = timespan;
  }

  public void update()
  {
    if (!paused)
    {
      this.gaugeUptime = millis() - this.startTime - this.pauseLength;
    }
    
    this.gaugeCommandQueue = this.canvas.commands.size();
    
    
    if (!this.paused)
    {
      if (this.inMotion && !this.canvas.inMotion())
      {
        this.gaugeStepCount++;
      }

      this.inMotion = this.canvas.inMotion();
    }
  }
  
  public void display(float x, float y)
  {
    pushMatrix();
    translate(x,y);    
    
    int vertical = 10;
    
    fill(0);
    textAlign(RIGHT);
    text("UP TIME: " + int(this.gaugeUptime / 1000), 0, vertical + 8);
    textAlign(LEFT);
    text(int(this.thresholdUptime / 1000), 120, vertical + 8);
    fill(200);
    rect(20, vertical, 90, 10);
    fill(255,100,100);
    rect(20, vertical, map(this.gaugeUptime, 0, this.thresholdUptime, 0, 90), 10);
    
    vertical += 15;
    
    fill(0);
    textAlign(RIGHT);
    text("STEP COUNT: " + int(this.gaugeStepCount), 0, vertical + 8);
    textAlign(LEFT);
    text(int(this.thresholdStepCount), 120, vertical + 8);
    fill(200);
    rect(20, vertical, 90, 10);
    fill(255,100,100);
    rect(20, vertical, map(this.gaugeStepCount, 0, this.thresholdStepCount, 0, 90), 10);
    
    vertical += 15;
    
    fill(0);
    textAlign(RIGHT);
    text("MOTIVATION: " + int(this.gaugeMotivation), 0, vertical + 8);
    fill(200);
    rect(20, vertical, 90, 10);
    fill(255,100,100);
    rect(20, vertical, map(this.gaugeMotivation, 0, this.thresholdMotivation, 0, 90), 10);
    
    vertical += 15;
    
    fill(0);
    textAlign(RIGHT);
    text("CMD QUEUE: " + int(this.gaugeCommandQueue), 0, vertical + 8);
    fill(200);
    rect(20, vertical, 90, 10);
    fill(255,100,100);
    rect(20, vertical, map(this.gaugeCommandQueue, 0, this.thresholdCommandQueue, 0, 90), 10);
    
    textAlign(CORNER);
    
    
    if (this.snapshot != null)
    {
      image(this.snapshot, -200, 8, (this.canvas.width * 60) / this.canvas.height,60);
    }
    
    
    popMatrix();
  }
}