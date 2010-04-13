class dmStructureTraining extends dmAbstractTraining
{
  public int timeout = 10000;
  public dmStructure structure;
  private float brushShade = -1;
  
  dmStructureTraining(dmCanvas c)
  {
    super(c);
  }

  void reset()
  {
    this.structure = new dmStructure(); // array list of dmPatterns
    
    this.canvas.changeColor(new TColor(TColor.BLACK));
    this.canvas.changeSize(10);
    
    super.reset();
  }
    
  void log(float x, float y, boolean newPattern, boolean newStroke)
  {
    structure.log(x, y, newPattern, newStroke, this.canvas.getBrush());
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
        boolean strokePaused = false;
        boolean colorChanged = false;
        
        
        if (brushShade < 0 || brushShade != CTL_BRUSH_SHADE)
        {
          colorChanged = true;
          debug("Pattern Count: " + this.structure.patterns.size());
          this.brushShade = CTL_BRUSH_SHADE;
        }
        
        if (mousePressed)
        {
          if (!this.isLogging) //previously not logging, is a pause
          {
            strokePaused = true;
            debug("New Stroke");
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
          this.log(mouseX, mouseY, colorChanged, strokePaused);
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
      this.structure.display(this.canvas, new Vec3D());
      
      this.save();
      this.stop();
      this.reset();
    }
  }
  
  boolean save()
  {
    return this.structure.memorize().equals("ok");
  }
  
  void display()
  {
    
  }
  
}
