class dmTraining
{
  public boolean active = false;
  public PointList trail;
  
  protected boolean isLogging = false;
  protected float startLog = -1;
  protected float lastLog = -1;
  
  dmTraining()
  {
    this.active = false;
    this.trail = new PointList();
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