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
    this.trail.clear();
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
      println("Training Log: " + mouseX + "," + mouseY);
      this.lastLog = millis();
    }
  }
  
  void log(float _x, float _y)
  {
    this.trail.add(new Vec3D(_x, _y, 0));
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
}