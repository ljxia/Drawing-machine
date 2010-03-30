class dmLineTraining extends dmAbstractTraining
{
  Vec3D startPoint;
  Vec3D endPoint;
  
  int margin = 50;
  int side = 400;
  
  private Vec3D boundOffsetA;
  private Vec3D boundOffsetB;
  
  dmLineTraining()
  {
    super();
    
    this.margin = 50;
    this.side = (width - 50 * 3) / 2;
    
    this.boundOffsetA = new Vec3D(this.margin, (height - side) / 2, 0);
    this.boundOffsetB = new Vec3D(margin + side + margin, (height - side) / 2, 0);
    
    this.reset();
    this.generatePoints();
  }
  
  void generatePoints()
  {
    this.startPoint = new Vec3D(random(this.side), random(this.side),0);
    this.endPoint = new Vec3D(random(this.side), random(this.side),0);
  }
  
  void activate()
  {
    generatePoints();
    while (this.startPoint.distanceTo(this.endPoint) < 15)
    {
      generatePoints();
    }
    
    debug("Start: " + startPoint.toString());
    debug("End: " + startPoint.toString());
    debug("Normalized: " + endPoint.sub(startPoint).normalize().toString());
    debug("Orientation: " + endPoint.sub(startPoint).normalize().angleBetween(new Vec3D(1,0,0)) * 180 / PI);
    this.active = true;
    this.reset();
  }

  void update()
  {
    if (this.active)
    {
      if (this.lastLog > 0 && millis() - this.lastLog > 2000)
      {
        this.feedback();
      }
      else //accept logging
      {
        boolean paused = false;
        if (mousePressed)
        {
          if (!this.isLogging) //previously not logging, is a pause
          {
            paused = true;
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
          this.log(mouseX - this.boundOffsetA.x, mouseY - this.boundOffsetA.y, paused ? 1 : 0);
          //debug("Line Training Log: " + mouseX + "," + mouseY);
          this.lastLog = millis();
        }
      }
    }
  }
  
  void feedback()
  {
    PointList pl = this.trail.subSelf(this.startPoint);
    canvas.trace(pl, this.boundOffsetB.add(this.startPoint));

    this.save();
    
    this.reset();
  }
  
  void display()
  {
    stroke(200);
    noFill();
    rect(this.boundOffsetA.x, this.boundOffsetA.y, side, side);
    rect(this.boundOffsetB.x, this.boundOffsetB.y, side, side);
    
    if (this.active)
    {
      noStroke();
      fill(255,0,0);
      
      pushMatrix();
      translate(this.boundOffsetA.x, this.boundOffsetA.y);
      ellipse(this.startPoint.x, this.startPoint.y, 5,5);
      
      fill(0,0,255);
      
      ellipse(this.endPoint.x, this.endPoint.y, 5,5);
      popMatrix();
      
      pushMatrix();
      fill(255,0,0);
      translate(this.boundOffsetB.x, this.boundOffsetB.y);
      rect(this.startPoint.x, this.startPoint.y, 3,3);
      
      fill(0,0,255);
      
      rect(this.endPoint.x, this.endPoint.y, 3,3);
      popMatrix();
    }
  }


  boolean save()
  {
    dmLineMemory mem = new dmLineMemory();
    String result = mem.memorize(this);
    
    debug(result);
    
    if (result.equals("ok"))
    {
      return true;
    }
    return false;
  }
  
  float trailDeviation()
  {
    float dev = 0;
    Vec3D vector = this.endPoint.sub(this.startPoint);
    
    if (this.trail != null && this.trail.size() > 0)
    {
      for (int i = 0; i < this.trail.size() ; i++)
      {
        Vec3D segment = this.trail.get(i);
        dev += sin(vector.angleBetween(segment, true)) * segment.magnitude();
      }
      
      return dev / this.trail.size();
    }
    return 0;
  }
}