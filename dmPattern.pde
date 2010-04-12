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
    if (newStroke)
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
  
  dmPattern recall()
  {
    Hashtable params = new Hashtable();

    String input = super.recall(params);
    try
    {
      JSONObject json = new JSONObject(input);
      this.id = json.getInt("id");
      
      dmStroke tempStroke = new dmStroke();
      this.strokes = tempStroke.recall(this.id);
      
      debug("loaded pattern: " + this.id);
      
      
      this.setData("trail", decodePointList(json.getString("trail")));
      
      return this;
    }
    catch(JSONException e)
    {
      debug(e.getMessage());
      return null;
    }
  }
}