class dmPatternTraining extends dmAbstractTraining
{
  public int timeout = 5000;
  
  void log(float x, float y)
  {
    
  }
  
  void update()
  {
    if (this.active)
    {
      if (this.lastLog > 0 && millis() - this.lastLog > this.timeout)
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
          //this.log(mouseX - this.boundOffsetA.x, mouseY - this.boundOffsetA.y, paused ? 1 : 0);
          //debug("Line Training Log: " + mouseX + "," + mouseY);
          this.lastLog = millis();
        }
      }
    }
  }
  
  void feedback()
  {
    
  }
  
  void display()
  {
    
  }
}