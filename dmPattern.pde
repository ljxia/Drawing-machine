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
    if (this.strokes != null)
      return this.strokes.size();
    
    return 0;  
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
    
    int newId = -1;
    newId = int(super.memorize());
    
    if (newId > 0 && this.strokeCount() > 0)
    {
      for (int i = 0; i < this.strokeCount() ; i++)
      {
        dmStroke s = this.getStroke(i);
        if (s != null)
        {
          s.memorize(newId);
        }
      }
      
      return "ok";
    }
    else
    {
      return "nah";
    }
    
  }
  
  PointList recall(Vec3D vector)
  {
    return null;
    /*    
    Hashtable params = new Hashtable();

    String input = super.recall(params);
    try
    {
      JSONObject json = new JSONObject(input);
      this.setData("id",json.getString("id"));
      this.setData("vector",json.getString("vector"));

      this.setData("deviation",json.getString("deviation"));
      this.setData("steps",json.getString("steps"));
      
      debug("loaded interpolation: " + this.getData("id").toString());
      
      
      this.setData("trail", JsonUtil.decodePointList(json.getString("trail")));
      
      return (PointList)this.getData("trail");
    }
    catch(JSONException e)
    {
      debug(e.getMessage());
      return null;
    }
    */
  }
}