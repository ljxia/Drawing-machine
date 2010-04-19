class dmInstinctiveStrategy extends dmAbstractStrategy
{
  private Vec3D refPoint = null;
  private Vec3D refVec = null;
  
  dmInstinctiveStrategy(dmContext context)
  {
    super(context);
  }
  
  boolean compose()
  {
    dmCanvas canvas = this.canvas();
    
    if (canvas.commands.size() > 2)
    {
      return false;
    }

    Vec3D startPoint = null;
    
    if (random(1) < 0.95 && refPoint != null && refPoint.distanceTo(new Vec3D(canvas.width / 2, canvas.height / 2, 0)) < canvas.width / 2)
    {
      startPoint = new Vec3D(refPoint);
    }
    else
    {
      startPoint = new Vec3D(random(canvas.width), random(canvas.height), 0);
    }
    dmLine memory = new dmLine();

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
    
    refPoint = startPoint.add(vec.scale(lngth * random(1)));
    refVec = vec.copy();
    
    vec.scaleSelf(lngth);
    
    if (random(1) < 0.95)
    {
      CTL_BRUSH_SIZE = random(map(lngth,10,canvas.width / 2,1,10));
    }
    else if (lngth < 100)
    {
      CTL_BRUSH_SIZE = random(10,25);
    }
    
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
    
    
    if (random(1) < 0.40)
    {
      // chance to draw line twice
      canvas.line(startPoint, startPoint.add(vec));
    }
    canvas.line(startPoint, startPoint.add(vec));
    
    return true;
  }
}