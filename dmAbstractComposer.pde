import java.util.Hashtable;

class dmAbstractComposer
{
  protected dmCanvas canvas;
  
  public boolean paused = false;
  
  protected float startTime;
  protected float pauseTime;
  
  protected float pauseLength;
  
  protected boolean inMotion = false;
  
  protected float gaugeUptime;
  protected float gaugeStepCount;
  protected float gaugeMotivation;
  protected float gaugeCommandQueue;
  
  protected float thresholdUptime;
  protected float thresholdStepCount;
  protected float thresholdMotivation;
  protected float thresholdCommandQueue;
  
  private Vec3D refPoint = null;
  
  
  dmAbstractComposer(dmCanvas canvas)
  {
    this.canvas = canvas;
    
    
    
    thresholdUptime = 5 * 60 * 1000;
    thresholdStepCount = 500;
    thresholdMotivation = 100;
    thresholdCommandQueue = 50;
    
    this.reset();
  }
  
  void reset()
  {
    this.canvas.clear();
    this.startTime = millis();
    this.pauseTime = 0;
    this.pauseLength = 0;
    
    this.thresholdUptime = random(1, 10) * 60 * 1000;
    this.thresholdStepCount = random(10,1000);
    
    this.gaugeUptime = -1;
    this.gaugeStepCount = 0;
    this.gaugeMotivation = 100;
  }
  
  void draw()
  {
    this.update();
    this.canvas.draw(0,0);
  }
  
  public void drawGauge(float x, float y)
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
    popMatrix();
  }
  
  protected void update()
  {
    this.canvas.update();
    this.updateGauges();
    
    if (!paused)
    {
      if (this.inMotion && !this.canvas.inMotion())
      {
        this.gaugeStepCount++;
      }

      this.inMotion = this.canvas.inMotion();

      if (!this.inMotion)
      {
        this.review();
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
  }
  
  protected void updateGauges()
  {
    if (!paused)
    {
      this.gaugeUptime = millis() - this.startTime - this.pauseLength;
    }
    
    this.gaugeCommandQueue = this.canvas.commands.size();
  }
  
  protected void save()
  {
    SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd-HHmmss");
    String name = "drawings/" + df.format(new Date()) + ".png";
    this.canvas.pushBuffer();
    this.canvas.dumpBuffer(name);
    
    sendMail(savePath(name));
  }
  
  protected void review()
  {
    
  }
  
  protected boolean isDone()
  {
    if (this.gaugeUptime > this.thresholdUptime)
    {
      return true;
    }
    else if (this.gaugeStepCount > this.thresholdStepCount)
    {
      return true;
    }
    return false;
  }
  
  protected void compose()
  {
    if (this.canvas.commands.size() > 5)
    {
      return;
    }
    // take one command and execute
    
    // or, drop one or all commands in the queue
    
    // generate new commands
    
    // FOR NOW: Generate a random line command
    Vec3D startPoint = null;
    
    if (random(1) < 0.8 && refPoint != null && refPoint.distanceTo(new Vec3D(this.canvas.width / 2, this.canvas.height / 2, 0)) < this.canvas.width / 2)
    {
      startPoint = new Vec3D(refPoint);
    }
    else
    {
      startPoint = new Vec3D(random(this.canvas.width), random(this.canvas.height), 0);
    }
    dmLineMemory memory = new dmLineMemory();

    Vec3D vec = Vec3D.randomVector();
    float lngth = random(10, this.canvas.width / 2);
    refPoint = startPoint.add(vec.scale(lngth * random(1)));
    vec.scaleSelf(lngth);
    
    if (random(1) < 0.95)
    {
      CTL_BRUSH_SIZE = random(map(lngth,10,this.canvas.width / 3,1,8));
    }
    else if (lngth < 100)
    {
      CTL_BRUSH_SIZE = random(10,20);
    }
    
    CTL_BRUSH_SHADE = int(random(6)) * 50 + 5;
    if (random(1) < 0.30)
    {
      // chance to draw line twice
      canvas.line(startPoint, startPoint.add(vec));
    }
    canvas.line(startPoint, startPoint.add(vec));
    
  }
  
  void pause()
  {
    paused = true;
    pauseTime = millis();
  }
  
  void play()
  {
    paused = false;
    pauseLength = pauseLength + (millis() - pauseTime);
  }
}