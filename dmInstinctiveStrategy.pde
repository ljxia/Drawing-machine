class dmInstinctiveStrategy extends dmAbstractStrategy
{
  private Vec3D startPoint = null;
  private Vec3D refPoint = null;
  private Vec3D refVec = null;
  
  dmInstinctiveStrategy(dmContext context)
  {
    super(context);
  }
  
  void tossLine(Vec3D suggestion)
  {
    //some randomness for color and size
    if (random(1) < 0.95)
    {
      CTL_BRUSH_SIZE = random(map(suggestion.magnitude(),10,canvas.width / 2,1,10));
    }
    else if (suggestion.magnitude() < 100)
    {
      CTL_BRUSH_SIZE = random(10,25);
    }

    //chance to draw the line twice
    if (random(1) < 0.40)
    {
      canvas.line(startPoint, startPoint.add(suggestion));
    }
    canvas.line(startPoint, startPoint.add(suggestion));
  }
  
  void tossPattern(Vec3D suggestion)
  {
    dmPattern pattern = new dmPattern();
    pattern = pattern.recall(suggestion);
    
    if (pattern.strokeCount() == 1)
    {
      dmStroke s = pattern.getStroke(0);
      
      int steps = s.trail.size();
      
      if (steps > 20)
      {
        int randomStart = 0;
        int randomEnd = steps - 1;
        
        int retry = 0;
        while ((randomEnd <= randomStart + 10 || randomEnd > randomStart + 100) && retry < 30)
        {
          randomStart = int(random(steps));
          randomEnd = int(random(randomStart, steps));
          retry ++;
        }
        
        PointList pl = new PointList();
        
        for (int i = randomStart; i <= randomEnd ; i++)
        {
          pl.add(s.trail.get(i));
        }
        
        s.trail = pl;
        if (random(1) < 5)
        {
          s.trail.scaleSelf(random(1, 5));
        }
        ((Vec3D)s.trail.get(0)).z = 1;
      }
    }
    
    //some randomness for color and size
    if (random(1) < 0.95)
    {
      CTL_BRUSH_SIZE = random(map(pattern.getArea(),100,sq(canvas.width / 3),1,10));
    }
    else if (pattern.getArea() > 100 * 100)
    {
      CTL_BRUSH_SIZE = random(10,25);
    }
    
    pattern.display(this.canvas(), this.startPoint.copy().sub(pattern.topLeft), false);
  }
  
  Vec3D getSuggestion()
  {
    Vec3D vec = Vec3D.randomVector();
    
    if (refVec != null)
    {
      vec = refVec.copy().rotateZ(random(PI / 3)).normalize();
    }
    
    float lngth = random(40, canvas.width / 3);
    
    if (random(1) < 0.2)
    {
      lngth = random(5,30);
    }
    else if (random(1) < 0.2)
    {
      lngth = random(canvas.width / 3,canvas.width);
    }
    
    vec.scaleSelf(lngth);
    
    return vec;
  }
  
  void generatePoints()
  {
    //setup start point
    startPoint = null;
    
    if (random(1) < 0.95 && refPoint != null && refPoint.distanceTo(new Vec3D(canvas.width / 2, canvas.height / 2, 0)) < canvas.width / 2)
    {
      startPoint = new Vec3D(refPoint);
    }
    else
    {
      startPoint = new Vec3D(random(canvas.width), random(canvas.height), 0);
    }
  }
  
  boolean compose()
  {
    dmCanvas canvas = this.canvas();
    
    if (canvas.commands.size() > 2)
    {
      return false;
    }
    
    Vec3D suggestion = this.getSuggestion();
    
    generatePoints();
    
    //save ref point on the line for future reference
    refPoint = startPoint.add(suggestion.scale(random(1)));
    refVec = suggestion.copy();

    
    
    if (random(1) < 0.6)
    {
      CTL_BRUSH_SHADE = int(random(6)) * 50 + 5;
    }
    else if (random(1) < 0.5)
    {
      CTL_BRUSH_SHADE = 0;
    }
    else
    {
      CTL_BRUSH_SHADE = 255;
    }

    if (random(1) < 0.4)
    {
      tossLine(suggestion);
    }
    else
    {
      tossPattern(suggestion);
    }
    
    return true;
  }
}