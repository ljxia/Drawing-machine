class dmPatternTraining extends dmAbstractTraining
{
  public int timeout = 5000;
  public dmPattern pattern;
  
  dmPatternTraining(dmCanvas c)
  {
    super(c);
  } 
  
  void reset()
  {
    pattern = new dmPattern();
    
    this.canvas.changeColor(new TColor(TColor.BLACK));
    this.canvas.changeSize(3);
    
    super.reset();
  }
  
  void log(float x, float y, boolean newStroke)
  {
    pattern.log(x, y, newStroke, this.canvas.getBrush());
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
          this.log(mouseX, mouseY, paused);
          //debug("Line Training Log: " + mouseX + "," + mouseY);
          this.lastLog = millis();
        }
      }
    }
  }
  
  void feedback()
  {
    if (this.canvas != null)
    {
      this.canvas.setPlaybackMode(true);
      
      /*      
      this.canvas.changeColor(new TColor(TColor.RED));
      this.canvas.changeSize(8);
      */
      
      for (int i = 0; i < this.pattern.strokeCount() ; i++)
      {
        dmStroke stk = this.pattern.getStroke(i);
        
        this.canvas.changeColor(stk.brushColor);
        this.canvas.changeSize(stk.brushSize);
        
        this.canvas.trace(stk.trail);
      }
      
      this.canvas.setPlaybackMode(false);
      
      stroke(255, 0, 0);
      noFill();
      rect(this.pattern.topLeft.x, this.pattern.topLeft.y, this.pattern.getWidth(), this.pattern.getHeight());
      
      this.save();
      this.stop();
      this.reset();
    }
  }
  
  boolean save()
  {
    return this.pattern.memorize().equals("ok");
  }
  
  void display()
  {
    
  }
}