class dmPattern extends dmAbstractMemory
{
  public int id;
  
  public ArrayList strokes;
  
  public Vec3D topLeft;
  public Vec3D bottomRight;
  
  dmPattern()
  {
    this.id = -1;
    this.serverMethod = "pattern";
    this.strokes = new ArrayList();
    
    this.topLeft = new Vec3D(9999,9999,0);
    this.bottomRight = new Vec3D(0,0,0);
    //this.density = 0;
  }
  
  public int strokeCount()
  {
    return this.strokes.size();
  }
  
  public dmStroke getStroke(int i)
  {
    if (this.strokes != null && i < this.strokes.size() && i >= 0)
    {
      return (dmStroke)this.strokes.get(i);
    }
    
    return null;
  }

  public float getWidth(){return this.bottomRight.x - this.topLeft.x; }
  public float getHeight(){return this.bottomRight.y - this.topLeft.y; }
  
  public float getDensity()
  {
    return -1;
  }
  
  public void log(float x, float y, boolean newStroke, dmBrush b)
  {
    if (newStroke || (this.strokes.size() == 0))
    {
      this.strokes.add(new dmStroke(b));
    }
    
    dmStroke s = (dmStroke)this.strokes.get(this.strokes.size() - 1);
    s.log(x, y);
    
    if (topLeft.x > x) {topLeft.x = x;}
    if (topLeft.y > y) {topLeft.y = y;}
    if (bottomRight.x < x) {bottomRight.x = x;}
    if (bottomRight.y < y) {bottomRight.y = y;}
  }
  
  public String memorize(int structure_id)
  {
    this.setData("structure_id", structure_id);
    return this.memorize();
  }
  
  public String memorize()
  {
    this.setData("strokeCount",this.strokeCount());
    this.setData("width",this.getWidth());
    this.setData("height",this.getHeight());
    this.setData("density",this.getDensity());
    
    int newId = -1;
    
    String result = super.memorize().trim();

    newId = int(result);
        
    if (newId > 0 && this.strokeCount() > 0)
    {
      debug("Pattern #" + newId + " Saved.");
      debug("Saving " + this.strokeCount() + " strokes...");
      for (int i = 0; i < this.strokeCount() ; i++)
      {
        dmStroke s = this.getStroke(i);
        
        s.trail.subSelf(this.topLeft);
        
        if (s != null)
        {
          result = s.memorize(newId);
        }
      }
      
      return "ok";
    }
    else
    {
      return "nah";
    }
    
  }
  
  void copy(dmPattern p)
  {
    this.id = p.id;
    this.topLeft = p.topLeft.copy();
    this.bottomRight = p.bottomRight.copy();
  }
  
  ArrayList recall(int structureId)
  {
    Hashtable params = new Hashtable();
    params.put("structure_id",structureId);
    
    String input = super.recall(params);
    
    ArrayList patterns = new ArrayList();
    
    try
    {
      JSONArray array = new JSONArray(input);
      for (int i = 0; i < array.length() ; i++)
      {
        dmPattern p = new dmPattern();
        p.load(array.getString(i));
        if (p != null)
        {
          patterns.add(p);
        }
      }
      
      return patterns;
    }
    catch(JSONException e)
    {
      debug(e.getMessage());
      return null;
    }
  }
  
  void load(String input)
  {
    dmPattern p = decodePattern(input);
    if (p != null)
    {
      this.copy(p);

      dmStroke tempStroke = new dmStroke();
      this.strokes = tempStroke.recall(this.id);

      debug("loaded pattern: #" + this.id + " with " + this.strokes.size() + " Strokes");
    }
  }
  
  dmPattern recall()
  {
    Hashtable params = new Hashtable();

    String input = super.recall(params);

    this.load(input);
    return this;
  }

  public void display(dmCanvas c, Vec3D offset)
  {
    c.setPlaybackMode(true);
    
    for (int i = 0; i < this.strokeCount() ; i++)
    {
      dmStroke stk = this.getStroke(i);
      
      c.changeColor(stk.brushColor);
      c.changeSize(stk.brushSize);
      
      c.trace(stk.trail, this.topLeft.add(offset));
    }
    
    c.setPlaybackMode(false);
  }
}