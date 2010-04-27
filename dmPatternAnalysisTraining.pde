class dmPatternAnalysisTraining extends dmAbstractTraining
{
  public Field trainingField;
  public dmPattern pattern;
  public boolean manualMode = false;
  private Vec3D previousPosition;
  
  dmPatternAnalysisTraining(dmCanvas c)
  {
    super(c);
  }
  
  boolean toggleManualMode()
  {
    this.manualMode = !this.manualMode;
    return this.manualMode;
  }
  
  void initVectorField()
  {
    Rect region = new Rect(this.canvas.width / 2, 0, this.canvas.width / 2, this.canvas.height);    
    this.trainingField = new Field(region, 20.0);
  }
  
  void initPattern()
  {
    pattern = new dmPattern();
    pattern = pattern.recallRandom();
    pattern.fitInRect(new Rect(0, 0, this.canvas.width / 2, this.canvas.height));
    this.previousPosition = new Vec3D(-1, -1, -1);
  }

  void reset()
  {
    this.initVectorField();
    
    if (!this.manualMode)
    {
      this.initPattern();
      
      debug("pattern loaded: " + pattern.getWidth() + "x" + pattern.getHeight());
      this.pattern.display(this.canvas);
    }
    
    super.reset();
  }
  
  void log(int x, int y, int px, int py, boolean paused)
  {
    this.trainingField.log(x, y, px, py, paused, this.canvas.getBrush().getScale());
  }
  
  void update()
  {
    if (this.active)
    {
      if (this.lastLog > 0 && millis() - this.lastLog > 5000)
      {
        this.feedback();
      }
      else //accept logging
      {
        boolean paused = false;
        
        if (this.startLog < 0)
        {
          this.startLog = millis();
        }
        
        if (this.manualMode)
        {
          if (mousePressed)
          {
            if (!this.isLogging) //previously not logging, is a pause
            {
              paused = true;
            }
            this.start();
          }
          else
          {
            this.stop();
          }

          if (this.isLogging)
          {
            this.log(mouseX, mouseY, pmouseX, pmouseY, paused ? true : false);
            this.lastLog = millis();
          }
        }
        else //patter playback mode
        {
          if (this.canvas.commandName.equals("TRACE"))
          {
            
            if (!this.isLogging) //previously not logging, is a pause
            {
              paused = true;
            }
            this.start();
          }
          else
          {
            this.stop();
            this.previousPosition.z = -1;
          }
          
          if (this.isLogging)
          {
            if (this.previousPosition.z < 0)
            {
              this.previousPosition = this.canvas.getBrush().anchor.copy();
            }
            this.log(int(this.canvas.getBrush().anchor.x), int(this.canvas.getBrush().anchor.y), int(this.previousPosition.x), int(this.previousPosition.y), paused ? true : false);
            
            this.previousPosition.x = this.canvas.getBrush().anchor.x;
            this.previousPosition.y = this.canvas.getBrush().anchor.y;
            
            this.lastLog = millis();
          }
        }
      }
    }
  }
  
  void feedback()
  {
    if (this.canvas != null)
    {     
/*      this.save();*/
      this.stop();
      this.reset();
    }
  }
  
  boolean save()
  {
    return false;
  }
  
  void display()
  {
    this.trainingField.draw();
  }
  
}