class dmStructure extends dmAbstractMemory
{
  public int id;
  
  public ArrayList patterns;
  
  public Vec3D topLeft;
  public Vec3D bottomRight;
  
  public Vec3D dimension;
  
  dmStructure()
  {
    this.id = -1;
    this.serverMethod = "structure";
    this.patterns = new ArrayList();
    
    
    this.topLeft = new Vec3D(9999,9999,0);
    this.bottomRight = new Vec3D(0,0,0);
  }
  
  dmStructure(float w, float h)
  {
    this();
    this.dimension = new Vec3D(w, h, 0);
    //this.density = 0;
  }
  
  public int patternCount()
  {
    return this.patterns.size();
  }
  
  public dmPattern getPattern(int i)
  {
    if (this.patterns != null && i < this.patterns.size() && i >= 0)
    {
      return (dmPattern)this.patterns.get(i);
    }
    
    return null;
  }

  public float getWidth(){return this.bottomRight.x - this.topLeft.x; }
  public float getHeight(){return this.bottomRight.y - this.topLeft.y; }
  
  public void log(float x, float y, boolean newPattern, boolean newStroke, dmBrush b)
  {
    if (newPattern || (this.patterns.size() == 0))
    {
      this.patterns.add(new dmPattern());
      debug("Pattern Count: " + this.patterns.size());
    }
    
    dmPattern p = (dmPattern)this.patterns.get(this.patterns.size() - 1);
    p.log(x, y, newStroke, b);
    
    if (topLeft.x > x) {topLeft.x = x;}
    if (topLeft.y > y) {topLeft.y = y;}
    if (bottomRight.x < x) {bottomRight.x = x;}
    if (bottomRight.y < y) {bottomRight.y = y;}
  }
  
  public String memorize()
  {
    this.setData("patternCount",this.patternCount());
    this.setData("width",this.getWidth());
    this.setData("height",this.getHeight());
    this.setData("dimension",this.dimension.toString());
    this.setData("offset", this.topLeft.toString());
    
    int newId = -1;
    String result = super.memorize().trim();

    newId = int(result);

    if (newId > 0 && this.patternCount() > 0)
    {      
      for (int i = 0; i < this.patternCount() ; i++)
      {
        dmPattern p = this.getPattern(i);
        
        if (p != null)
        {
          p.memorize(newId, this.topLeft);
        }
      }
      
      return newId + "";
    }
    else
    {
      return "nah";
    }
    
  }
  
  dmStructure recall()
  {
    Hashtable params = new Hashtable();

    String input = super.recall(params);
    try
    {
      JSONObject json = new JSONObject(input);
      this.id = json.getInt("id");
      this.topLeft = decodeVec3D(json.getString("offset"));
      this.bottomRight = this.topLeft.add(json.getLong("width"), json.getLong("height"), 0);
      this.dimension = decodeVec3D(json.getString("dimension"));
      
      debug("loaded structure: #" + this.id);
      
      dmPattern tempPattern = new dmPattern();
      this.patterns = tempPattern.recall(this.id);
      
      debug("loaded sub pattern: " + this.patterns.size() + " Total");

      return this;
    }
    catch(JSONException e)
    {
      debug(e.getMessage());
      return null;
    }
  }

  public void display(dmCanvas c, Vec3D offset)
  {
    for (int i = 0; i < this.patternCount() ; i++)
    {
      dmPattern pat = this.getPattern(i);
      
      //pat.display(c, this.topLeft.add(offset));
      pat.display(c, offset);
    }
    
    /*    
    stroke(100,0,0);
    noFill();
    rect(this.topLeft.x + offset.x, this.topLeft.y + offset.y, this.getWidth(), this.getHeight());
    */
  }
}