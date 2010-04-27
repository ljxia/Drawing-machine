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
  
  private String summaryText = "";
  
  private DataPool recentScore;
  
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
  
  public String summary()
  {
    if (!this.summaryText.equals(""))
    {
      return this.summaryText;
    }
    else
    {
      return this.setSummary("");
    }
  }
  
  private String setSummary(String exitCondition)
  {
    this.summaryText = "";
    this.summaryText += "Dimension: " + this.canvas.width + " x " + this.canvas.height + "\n";
    this.summaryText += "Drawing Time: " + floor(this.gaugeUptime / 1000) + " seconds \n";
    this.summaryText += "Steps Used: " + int(this.gaugeStepCount) + "\n";
    this.summaryText += "Passion Gauge: " + int(this.gaugeMotivation) + "\n";
    
    if (!exitCondition.equals(""))
    {
      this.summaryText += "Exit Condition: " + exitCondition;
    }
    
    return this.summaryText;
  }
  
  public void adjustMotivation(float motif)
  {
    this.gaugeMotivation += motif;
    this.recentScore.log(motif);
    this.gaugeMotivation = constrain(this.gaugeMotivation, 0, this.thresholdMotivation);
  }
  
  protected void reset()
  {
    this.startTime = millis();
    this.pauseTime = 0;
    this.pauseLength = 0;
    this.inMotion = false;
    
    this.thresholdUptime = random(0, 2) * 60 * 1000;
    this.thresholdStepCount = random(10,1000);
    
    this.gaugeUptime = -1;
    this.gaugeStepCount = 0;
    this.gaugeMotivation = random(70,90);
    
    this.recentScore = new DataPool(25);
    
    this.setReviewTime();
  }
  
  public boolean isFinished()
  {
    if (this.gaugeUptime >= this.thresholdUptime)
    {
      if (this.gaugeUptime > 1000 * 1000 || this.gaugeMotivation < 60)
      {
        setSummary("Time is up, this is not exciting.");
        return true;
      }
      else
      {
        //procrastinate
        this.thresholdUptime = this.thresholdUptime + (this.gaugeMotivation * random(0,1) * 1000);
        info("procrastinate: more time: " + this.thresholdUptime);
      }
    }
    
    if (this.gaugeStepCount > this.thresholdStepCount)
    {
      if (this.gaugeStepCount > 1000 || this.gaugeMotivation < 50)
      {
        setSummary("This is a mess.");
        return true;
      }
      else
      {
        //procrastinate a bit
        this.thresholdStepCount = this.thresholdStepCount + (this.gaugeMotivation * random(0.5,1));
        info("procrastinate: more steps: " + this.thresholdStepCount);
      }
      
    }
    
    if (this.recentScore.full() && this.recentScore.average() < 0 && this.gaugeMotivation > 85)
    {
      setSummary("Maybe it's better to stop here.");
      return true;
    }
    
    if (this.gaugeMotivation < 20)
    {
      setSummary("Completely bored.");
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
    fill(200,0,0);
    rect(20, vertical, map(this.gaugeUptime, 0, this.thresholdUptime, 0, 90), 10);
    
    vertical += 15;
    
    fill(0);
    textAlign(RIGHT);
    text("STEP COUNT: " + int(this.gaugeStepCount), 0, vertical + 8);
    textAlign(LEFT);
    text(int(this.thresholdStepCount), 120, vertical + 8);
    fill(200);
    rect(20, vertical, 90, 10);
    fill(200,0,0);
    rect(20, vertical, map(this.gaugeStepCount, 0, this.thresholdStepCount, 0, 90), 10);
    
    vertical += 15;
    
    fill(0);
    textAlign(RIGHT);
    text("MOTIVATION: " + int(this.gaugeMotivation), 0, vertical + 8);
    fill(200);
    rect(20, vertical, 90, 10);
    fill(200,0,0);
    rect(20, vertical, map(this.gaugeMotivation, 0, this.thresholdMotivation, 0, 90), 10);
    
    vertical += 15;
    
    fill(0);
    textAlign(RIGHT);
    text("CMD QUEUE: " + int(this.gaugeCommandQueue), 0, vertical + 8);
    fill(200);
    rect(20, vertical, 90, 10);
    fill(200,0,0);
    rect(20, vertical, map(this.gaugeCommandQueue, 0, this.thresholdCommandQueue, 0, 90), 10);
    
    textAlign(CORNER);
    
    
    if (this.snapshot != null)
    {
      image(this.snapshot, -200, 8, (this.canvas.width * 60) / this.canvas.height,60);
    }
    
    noStroke();
    if (this.canvas.commandName.equals("IDLE"))
    {
      fill(0);
    }
    else
    {
      fill(200,0,0);
    }
    rect( - 220 - textWidth(this.canvas.commandName) - 6,10,textWidth(this.canvas.commandName) + 6,10);
    fill(255);
    textAlign(RIGHT);
    text(this.canvas.commandName, -220 - 3, 18);
    
    stroke(0);
    fill(CTL_BRUSH_SHADE);
    ellipseMode(CENTER);
    ellipse(-220 - 15, 40, CTL_BRUSH_SIZE, CTL_BRUSH_SIZE);
    
    popMatrix();
  }
}