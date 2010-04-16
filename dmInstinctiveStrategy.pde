class dmInstinctiveStrategy extends dmAbstractStrategy
{
  private Vec3D refPoint = null;
  
  dmInstinctiveStrategy(dmDrawingContext context)
  {
    super(context);
  }
  
  boolean compose()
  {
    dmCanvas canvas = this.canvas();
    
    if (canvas.commands.size() > 5)
    {
      return false;
    }

    Vec3D startPoint = null;
    
    if (random(1) < 0.8 && refPoint != null && refPoint.distanceTo(new Vec3D(canvas.width / 2, canvas.height / 2, 0)) < canvas.width / 2)
    {
      startPoint = new Vec3D(refPoint);
    }
    else
    {
      startPoint = new Vec3D(random(canvas.width), random(canvas.height), 0);
    }
    dmLine memory = new dmLine();

    Vec3D vec = Vec3D.randomVector();
    float lngth = random(10, canvas.width / 3);
    refPoint = startPoint.add(vec.scale(lngth * random(1)));
    vec.scaleSelf(lngth);
    
    if (random(1) < 0.95)
    {
      CTL_BRUSH_SIZE = random(map(lngth,10,canvas.width / 3,1,8));
    }
    else if (lngth < 100)
    {
      CTL_BRUSH_SIZE = random(10,20);
    }
    
    CTL_BRUSH_SHADE = int(random(6)) * 50 + 5;
    if (random(1) < 0.30)
    {
      // chance to draw line twice
      canvas.line(startPoint, startPoint.add(vec));
    }
    canvas.line(startPoint, startPoint.add(vec));
    
    return true;
  }
}