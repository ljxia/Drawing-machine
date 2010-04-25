class dmPatternAnalysisTraining extends dmAbstractTraining
{
  public Field trainingField;
  
  dmPatternAnalysisTraining(dmCanvas c)
  {
    super(c);
  }
  
  void initVectorField()
  {
    Rect region = new Rect(this.canvas.width / 2, 0, this.canvas.width / 2, this.canvas.height);    
    this.trainingField = new Field(region, 20.0);
  }

  void reset()
  {
    this.initVectorField();
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
        
        if (this.startLog < 0)
        {
          this.startLog = millis();
        }

        if (this.isLogging)
        {
          this.log(mouseX, mouseY, pmouseX, pmouseY, paused ? true : false);
          this.lastLog = millis();
        }
      }
    }
  }
  
  void feedback()
  {
    if (this.canvas != null)
    {     
/*      this.save();
      this.stop();*/
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