class dmLineTraining extends dmTraining
{
  Vec3D startPoint;
  Vec3D endPoint;
  
  int margin = 50;
  int side = 400;
  
  int feedbackIndex = 0;
  
  dmLineTraining()
  {
    super();
    
    this.margin = 50;
    this.side = (width - 50 * 3) / 2;
    
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
    while (this.startPoint.distanceTo(this.endPoint) < 30)
    {
      generatePoints();
    }
    this.active = true;
    this.reset();
  }
  
  void reset()
  {
    this.feedbackIndex = 0;
    super.reset();
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
        if (mousePressed)
        {
          this.start();
        }
        else
        {
          this.stop();
        }

        super.update();
      }
    }
  }
  
  void feedback()
  {
    PointList pl = (PointList)this.trail;
    pl = pl.addSelf(new Vec3D(side + margin, 0, 0));
    canvas.trace(pl);
    this.lastLog = -1;
  }
  
  void display()
  {
    stroke(200);
    noFill();
    rect(margin, (height - side) / 2, side, side);
    rect(margin + side + margin, (height - side) / 2, side, side);
    
    if (this.active)
    {
      noStroke();
      fill(255,0,0);
      
      pushMatrix();
      translate(margin, (height - side) / 2);
      ellipse(this.startPoint.x, this.startPoint.y, 5,5);
      ellipse(this.endPoint.x, this.endPoint.y, 5,5);
      popMatrix();
    }
  }
}