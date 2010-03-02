public class dmBrush extends AbstractBrush
{ 
  
  public VerletParticle tail;
  public VerletParticle left;
  public VerletParticle right;

  public Vec3D last_tail;
  public Vec3D last_left;
  public Vec3D last_right;


  public Vec3D motionStart;
  public Vec3D motionEnd = null;
  public Path motionCurve = null;
  
  public float localSpeedVar = 1.0;
  
  boolean closeShape = false;
  
  
  

  dmBrush(Vec3D center, VerletPhysics physics, float _size)
  {
    super(center,physics,_size);
  }
  
  void setPos(int x, int y)
  {
    setPos(new PVector(x,y));
  }
  
  void setPos(Vec3D _target)
  {
    setPos(new PVector(_target.x, _target.y, _target.z));
  }
  
  void setPos(PVector _target)
  {
    super.moveTo(_target);
  }
  
  void moveTo(Vec3D _target)
  {
   this.motionEnd = new Vec3D(_target);
    
    this.motionCompleted = false;
    
    this.motion.vel.mult(0);
    
    this.motion.maxforce = FORCE_STRAIGHT;
    this.motion.maxspeed = SPEED_STRAIGHT * localSpeedVar;
    println("motion moveTo started");
  }
  
  void lineTo(Vec3D _target)
  {
    this.automated = true;
    this.motionEnd = new Vec3D(_target);
    
    this.motion.vel.mult(0);
    this.motionCompleted = false;
    
    this.motion.maxforce = FORCE_STRAIGHT;
    this.motion.maxspeed = SPEED_STRAIGHT * localSpeedVar;
    
    println("motion lineTo started");
  }
  
  void drawAlong(Path path)
  {
    this.automated = true;
    this.motionCurve = path;
    
    //this.motion.vel.mult(0);
    this.motionCompleted = false;
    this.motion.pathProgress = 0;
    this.motion.maxforce = FORCE_CURVE;
    this.motion.maxspeed = SPEED_CURVE;
    
    if (path.points.size() > 1)
    {
      PVector a = (PVector) path.points.get(0);
      PVector b = (PVector) path.points.get(1);
      
      PVector aug = PVector.sub(b,a);
      aug.normalize();
      this.motion.vel.add(aug);
      this.motion.vel.x = this.motion.vel.x * (1 + random(-0.4, 0.4));
      this.motion.vel.y = this.motion.vel.y * (1 + random(-0.4, 0.4));
    }
    
    println("motion drawAlong started");
  }

  void reset()
  {
    super.reset();

/*    this.automated = true;*/

    this.motion = new Boid(new PVector(this.anchor.x, this.anchor.y), SPEED_STRAIGHT,FORCE_STRAIGHT);

    this.tail = new VerletParticle(this.anchor);
    this.tail.y += this.getSize() * 3;
    this.world.addParticle(this.tail);

    this.left = new VerletParticle(this.anchor);
    this.left.x -= this.getSize() * 0.8;
    this.left.y -= this.getSize() * 0.5;
    this.world.addParticle(this.left);

    this.right = new VerletParticle(this.anchor);
    this.right.x += this.getSize() * 0.8;
    this.right.y -= this.getSize() * 0.5;
    this.world.addParticle(this.right);


    this.tips.add(this.tail);
    this.tips.add(this.left);
    this.tips.add(this.right);


    VerletSpring tailSpring = new VerletConstrainedSpring(this.anchor, this.tail, this.anchor.distanceTo(this.tail),1.4);
    VerletSpring leftSpring = new VerletConstrainedSpring(this.anchor, this.left, this.anchor.distanceTo(this.left), 1);
    VerletSpring rightSpring = new VerletConstrainedSpring(this.anchor, this.right, this.anchor.distanceTo(this.right), 1);

    VerletSpring headpring = new VerletSpring(this.left, this.right, this.left.distanceTo(this.right), 0.5);
    VerletSpring leftSideSpring = new VerletSpring(this.tail, this.left, this.tail.distanceTo(this.left), 0.5);
    VerletSpring rightSideSpring = new VerletSpring(this.tail, this.right, this.tail.distanceTo(this.right), 0.5);

    this.world.addSpring(tailSpring);
    this.world.addSpring(leftSpring);
    this.world.addSpring(rightSpring);
    this.world.addSpring(headpring);
    this.world.addSpring(leftSideSpring);
    this.world.addSpring(rightSideSpring);


    this.springs.add(tailSpring);     
    this.springs.add(leftSpring);     
    this.springs.add(rightSpring);    
    this.springs.add(headpring);      
    this.springs.add(leftSideSpring); 
    this.springs.add(rightSideSpring);

    this.update();
  }

  void update()
  {
    this.motion.run();
    
    this.last_tail = new Vec3D(this.tail);
    this.last_left = new Vec3D(this.left);
    this.last_right = new Vec3D(this.right);
    
    if (this.motion != null && this.motionEnd != null && !motionCompleted) // line to and move to
    {
      if (this.motion.arrive(new PVector(motionEnd.x, motionEnd.y)))
      {
        motionCompleted = true;
        this.motionEnd = null;
        this.automated = false;
        println("motion completed");
      }      
      this.setPos(this.motion.loc);
    }
    else if (this.motion != null && this.motionCurve != null && !motionCompleted) // curve following
    {
      if (this.motion.follow(motionCurve, closeShape) || this.motion.travelLength > (1.3 * this.motionCurve.length()))
      {
        
        if (this.motion.travelLength > (0.5 * this.motionCurve.length()))
        {
          motionCompleted = true;

          this.automated = false;
          println("motion completed");

          if (this.motion.travelLength < (1.2 * this.motionCurve.length()) && random(0,1) < 0.6)
          {
            //complete the stroke
            /*PVector p = (PVector)this.motionCurve.points.get(0);
                        this.lineTo(new Vec3D(p.x, p.y, 0));*/
          }

          this.motionCurve = null;
        }
        
      }
      this.setPos(this.motion.loc);
    }
    
    
      
  }
  
  float getTravelLength()
  {
    return this.motion.travelLength;
  }
  
  void resetTravelLength()
  {
    this.motion.travelLength = 0;
  }

  void draw()
  {
    if (this.automated || mousePressed)
    {
      noStroke();
      //fill(0,10);
      //stroke(this._color.toARGB());
      fill(this._color.toARGB());
      
      //rect(width - 40, 40,20,20);
      
      beginShape();
      vertex(tail.x, tail.y);
      vertex(left.x, left.y);
      vertex(right.x, right.y);
      endShape(CLOSE);

      beginShape();
      vertex(tail.x, tail.y);
      vertex(last_tail.x, last_tail.y);
      vertex(last_right.x, last_right.y);
      vertex(right.x, right.y);
      endShape(CLOSE);

      beginShape();
      vertex(tail.x, tail.y);
      vertex(last_tail.x, last_tail.y);
      vertex(last_left.x, last_left.y);
      vertex(left.x, left.y);
      endShape(CLOSE);
    }
    
     //noStroke();
     //fill(255,0,0);
    
    //ellipse(this.anchor.x, this.anchor.y, 2,2);

    //stroke(0,0,255);
    //noFill();
    //ellipse(this.motion.loc.x, this.motion.loc.y, 5,5);

    
  }


}