class dmPattern extends dmAbstractMemory
{
  public int id;
  public int inspiration_id;
  
  public ArrayList strokes;
  
  public Vec3D topLeft;
  public Vec3D bottomRight;
  
  public Vec3D globalOffset;
  
  dmPattern()
  {
    this.id = -1;
    this.inspiration_id = -1;
    this.serverMethod = "pattern";
    this.strokes = new ArrayList();
    
    this.topLeft = new Vec3D(9999,9999,0);
    this.bottomRight = new Vec3D(0,0,0);
    this.globalOffset = new Vec3D(0,0,0);
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

  public float getWidth(){return max(this.bottomRight.x - this.topLeft.x, 1); }
  public float getHeight(){return max(this.bottomRight.y - this.topLeft.y, 1); }
  
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
    return this.memorize(structure_id, new Vec3D(0,0,0));
  }
  
  public String memorize(int structure_id, Vec3D offset)
  {
    this.setData("structure_id", structure_id);
    this.globalOffset = offset.copy();
    return this.memorize();
  }
  
  public String memorize()
  {
    this.setData("strokeCount",this.strokeCount());
    this.setData("width",this.getWidth());
    this.setData("height",this.getHeight());
    this.setData("density",this.getDensity());
    this.setData("offset", this.topLeft.sub(this.globalOffset).toString());
    
    if (this.inspiration_id > 0)
    {
      this.setData("inspiration_id",this.inspiration_id);
    }
    
    int newId = -1;
    
    String result = super.memorize().trim();

    newId = int(result);
        
    if (newId > 0 && this.strokeCount() > 0)
    {
      this.id = newId;
      
      debug("Pattern #" + newId + " Saved.");
      debug("Saving " + this.strokeCount() + " strokes...");
      for (int i = 0; i < this.strokeCount() ; i++)
      {
        dmStroke s = this.getStroke(i);
        
        if (s != null)
        {
          result = s.memorize(newId, this.topLeft);
        }
      }
      
      return newId + "";
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

      debug("loaded pattern: #" + this.id + ", with " + this.strokes.size() + " Strokes");
      debug("Top Left: " + this.topLeft.toString());
      debug("Botom Right: " + this.bottomRight.toString());
    }
  }
  
  dmPattern recallSelf(Hashtable params)
  {
    String input = super.recall(params);
    debug(input);
    this.load(input);
    return this;
  }
  
  dmPattern recall()
  {
    return this.recallSelf(new Hashtable());
  }
  
  dmPattern recallRandom()
  {
    Hashtable params = new Hashtable();
    params.put("random","1");
    return this.recallSelf(params);
  }

  public void display(dmCanvas c)
  {
    this.display(c, this.topLeft.copy().scaleSelf(-1), false);
  }
  
  public void display(dmCanvas c, Vec3D offset)
  {
    this.display(c,offset,true);
  }

  public void display(dmCanvas c, Vec3D offset, boolean useOriginalBrush)
  {
    if (useOriginalBrush)
      c.setPlaybackMode(true);
    
    for (int i = 0; i < this.strokeCount() ; i++)
    {
      dmStroke stk = this.getStroke(i);      
      stk.display(c, this.topLeft.add(offset), useOriginalBrush);
    }
    
    if (useOriginalBrush)
      c.setPlaybackMode(false);
    
    /*    
    stroke(255,0,0);
    noFill();
    rect(this.topLeft.x + offset.x, this.topLeft.y + offset.y, this.getWidth(), this.getHeight());
    */
  }

  void scaleSelf(float factor)
  {
    this.topLeft.scaleSelf(factor);
    this.bottomRight.scaleSelf(factor);
    
    for (int i = 0; i < this.strokeCount() ; i++)
    {
      dmStroke s = this.getStroke(i);
      
      if (s != null)
      {
        s.scaleSelf(factor);
      }
    }
  }

  public void fitInRect(Rect area)
  {
    float srcRatio = this.getWidth() / this.getHeight();
    float dstRatio = area.width / area.height;
    
    float scaling = 1.0;
    
    if (srcRatio < dstRatio)
    {
      scaling = area.height / this.getHeight();
    }
    else
    {
      scaling = area.width / this.getWidth();
    }
    
    debug("fit pattern in rect, scale by " + scaling);
    this.scaleSelf(scaling);
  }

}