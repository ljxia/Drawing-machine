class dmAbstractTraining
{
  protected dmCanvas canvas = null;
  public boolean active = false;
  public PointList trail;
  
  protected boolean isLogging = false;
  protected float startLog = -1;
  protected float lastLog = -1;
  
  dmAbstractTraining()
  {
    this.active = false;
    this.trail = new PointList();
    this.reset();
  }
  
  dmAbstractTraining(dmCanvas c)
  {
    this.active = false;
    this.trail = new PointList();
    this.canvas = c;
    this.reset();
  }
  
  void setCanvas(dmCanvas c)
  {
    this.canvas = c;
  }
  
  void reset()
  {
    this.reset(true);
  }
  
  void reset(boolean clearTrail)
  {
    if (clearTrail)
    {
      this.trail.clear();
    }
    this.isLogging = false;
    this.startLog = -1;
    this.lastLog = -1;
  }
  
  void update()
  {
    if (this.startLog < 0)
    {
      this.startLog = millis();
    }
    
    if (this.isLogging)
    {
      this.log(mouseX, mouseY);
      debug("Training Log: " + mouseX + "," + mouseY);
      this.lastLog = millis();
    }
  }
  
  void log(float _x, float _y)
  {
    this.log(_x,_y,0);
  }
  
  void log(float _x, float _y, float _z)
  {
    this.trail.add(new Vec3D(_x, _y, _z));
  }
  
  void activate()
  {
    this.active = true;
    this.reset();
  }
  
  void deactivate()
  {
    this.active = false;
    this.reset();
  }
  
  void start()
  {
    this.isLogging = true;
  }
  
  void stop()
  {
    this.isLogging = false;
  }
  
  void feedback()
  {
    
  }
  
  boolean save(){return false;}
  boolean load(){return false;}
}