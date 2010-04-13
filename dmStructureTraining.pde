class dmStructureTraining extends dmAbstractTraining
{
  public ArrayList patterns;
  
  dmStructureTraining(dmCanvas c)
  {
    super(c);
  }
  
  void log(float x, float y, boolean newStroke)
  {
    dmPattern pattern = new dmPattern();
    
    if (newStroke || this.patterns.size() == 0)
    {
      this.patterns.add(pattern);
    }
    else if (this.patterns.size() > 0)
    {
      pattern = (dmPattern)this.patterns.get(this.patterns.size() - 1);
    }
    
    pattern.log(x, y, newStroke, this.canvas.getBrush());
  }
  
  void reset()
  {
    this.patterns = new ArrayList(); // array list of dmPatterns
    
    this.canvas.changeColor(new TColor(TColor.BLACK));
    this.canvas.changeSize(10);
    
    super.reset();
  }
  
  void update()
  {
    
  }
  
  void feedback()
  {
    
  }
  
  void display()
  {
    
  }
  
}
