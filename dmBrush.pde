public class dmBrush extends dmAbstractBrush
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
  
  public PointList trail = null;
  
  public float localSpeedVar = 1.0;
  
  private boolean closeShape = false;
  private PointList _lineInterpolation = null;
  private Vec3D _offset = null;

  dmBrush(Vec3D center, VerletPhysics physics, float _size)
  {
    super(center,physics,_size);
  }

  void clearInterpolation()
  {
    this._lineInterpolation = null;
  }
  
  void setInterpolation(PointList pl)
  {
    this._lineInterpolation = pl;
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
    this.anchor.unlock();
    if (super.moveTo(_target))
    {
      if (this.tail.getWeight() > 1)
      {
        this.left.setWeight(0.1);
        this.right.setWeight(0.1);
        this.tail.setWeight(0.1);
        this.anchor.setWeight(0.001);
      }
      
      if (!this.tail.isLocked())
      {
        this.tail.lock();
      }
    }
    else
    {
      this.left.setWeight(5);
      this.right.setWeight(5);
      this.tail.setWeight(5);
      this.anchor.setWeight(10);
      
      this.tail.unlock();      
    }
  }
  
  boolean moveTo(Vec3D _target, Vec3D offset)
  {
    this.anchor.unlock();
    if (this.anchor.distanceTo(_target.add(offset)) < 5)
    {
      //if already close enough, dont bother doing anything
      return true;
    }
    
    this.motion.vel.mult(0);
    this.motionCompleted = false;
    this.motionEnd = new Vec3D(_target.add(offset));
    
    this.motion.maxforce = FORCE_STRAIGHT;
    this.motion.maxspeed = SPEED_STRAIGHT * localSpeedVar;
    info("motion moveTo started");
    
    return true;
  }
  
  void lineTo(Vec3D _target)
  {
    this.anchor.unlock();
    this.automated = true;
        
    this.motion.vel.mult(0);
    this.motionCompleted = false;
    this.motionEnd = new Vec3D(_target);
    
    this.motion.maxforce = FORCE_STRAIGHT;
    this.motion.maxspeed = SPEED_STRAIGHT * localSpeedVar;
    
    info("motion lineTo started");
  }

  void drawAlong(PointList pl)
  {
/*    this.anchor.unlock();
    this.automated = true;
    //this.motionCurve = path;
    
    //this.motion.vel.mult(0);
    this.motionCompleted = false;
    this.motion.pathProgress = 0;
    this.motion.maxforce = FORCE_CURVE;
    this.motion.maxspeed = SPEED_CURVE;
    
    if (pl.size() > 1)
    {
      PVector a = new PVector(pl.get(0).x, pl.get(0).y);
      PVector b = new PVector(pl.get(1).x, pl.get(1).y);
      
      PVector aug = PVector.sub(b,a);
      aug.normalize();
      this.motion.vel.add(aug);
      this.motion.vel.x = this.motion.vel.x * (1 + random(-0.4, 0.4));
      this.motion.vel.y = this.motion.vel.y * (1 + random(-0.4, 0.4));
    }
    
    info("motion drawAlong started");*/
  }
  
  void drawAlong(Path path)
  {
    this.anchor.unlock();
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
    
    info("motion drawAlong started");
  }
  
  void trace(PointList pl, Vec3D offset)
  {
    this.automated = true;
    this.trail = pl;
    this.motionCompleted = false;
    this._offset = offset.copy();
/*    
    if (!delayOffset)
    {
      this._offset = offset.copy();
    }
    else
    {
      this._offset = this.getPos().copy();
    }
*/
    
    info("motion trace started");
  }

  void reset()
  {
    super.reset();

/*    this.automated = true;*/

    this.motion = new Boid(new PVector(this.anchor.x, this.anchor.y), SPEED_STRAIGHT,FORCE_STRAIGHT);

    this.tail = new VerletParticle(this.anchor);
    this.tail.y += this.getSize() * 3;
    this.tail.setWeight(5);
    this.world.addParticle(this.tail);

    this.left = new VerletParticle(this.anchor);
    this.left.x -= this.getSize() * 0.8;
    this.left.y -= this.getSize() * 0.5;
    this.left.setWeight(5);
    this.world.addParticle(this.left);

    this.right = new VerletParticle(this.anchor);
    this.right.x += this.getSize() * 0.8;
    this.right.y -= this.getSize() * 0.5;
    this.right.setWeight(5);
    this.world.addParticle(this.right);


    this.tips.add(this.tail);
    this.tips.add(this.left);
    this.tips.add(this.right);


    VerletSpring tailSpring = new VerletConstrainedSpring(this.anchor, this.tail, this.anchor.distanceTo(this.tail),0.5);
    VerletSpring leftSpring = new VerletConstrainedSpring(this.anchor, this.left, this.anchor.distanceTo(this.left), 0.5);
    VerletSpring rightSpring = new VerletConstrainedSpring(this.anchor, this.right, this.anchor.distanceTo(this.right), 0.5);

    VerletSpring headpring = new VerletSpring(this.left, this.right, this.left.distanceTo(this.right), 0.1);
    VerletSpring leftSideSpring = new VerletSpring(this.tail, this.left, this.tail.distanceTo(this.left), 0.05);
    VerletSpring rightSideSpring = new VerletSpring(this.tail, this.right, this.tail.distanceTo(this.right), 0.05);

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
    
    this.springLengths.add(tailSpring.restLength);     
    this.springLengths.add(leftSpring.restLength);     
    this.springLengths.add(rightSpring.restLength);    
    this.springLengths.add(headpring.restLength);      
    this.springLengths.add(leftSideSpring.restLength); 
    this.springLengths.add(rightSideSpring.restLength);

    this.update();
  }

  void update()
  {
    super.update();
    
    this.motion.run();
    
    this.last_tail = new Vec3D(this.tail);
    this.last_left = new Vec3D(this.left);
    this.last_right = new Vec3D(this.right);
    
    if (this.trail != null)
    {
      if (this.trail.size() > 0)
      {
        Vec3D pos = (Vec3D)this.trail.remove(0);
        this.setPos(pos.add(this._offset));
        this.motion.stopAt(pos.x + this._offset.x, pos.y + this._offset.y);
      }
      else
      {
        this.trail = null;
        this.motionCompleted= true;
        this.automated = false;
        
        this._offset.scaleSelf(0);
        
        info("trace completed");
      }
    }
    else if (this.motion != null && this.motionEnd != null && !motionCompleted) // line to and move to
    {
      if (this.motion.arrive(new PVector(motionEnd.x, motionEnd.y)))
      {
        motionCompleted = true;
        this.anchor.lock();
        this.motionEnd = null;
        this.automated = false;
        info("motion completed");
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
          this.anchor.lock();
          this.automated = false;
          info("motion completed");

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
    
    if (this.motion != null && motionCompleted)
    {
      //non-boid movement
      //sync motion location to current brushh location
      this.motion.stopAt(this.anchor.x, this.anchor.y);
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
  
  void drawPosition()
  {
    noStroke();
    fill(255,0,0);
    ellipse(this.anchor.x, this.anchor.y, this.getScale() * 5,this.getScale() * 5);
    
    //fill(200,0,0);
    //ellipse(this.motion.loc.x, this.motion.loc.y, 4,4);
  }
  
  void draw(PGraphics graphic)
  {
    graphic.beginDraw();
    
    if (this.automated)
    {      
      graphic.noStroke();
      graphic.fill(this._color.toARGB());
      
      graphic.beginShape();
      graphic.vertex(tail.x, tail.y);
      graphic.vertex(left.x, left.y);
      graphic.vertex(right.x, right.y);
      graphic.endShape(CLOSE);

      graphic.beginShape();
      graphic.vertex(tail.x, tail.y);
      graphic.vertex(last_tail.x, last_tail.y);
      graphic.vertex(last_right.x, last_right.y);
      graphic.vertex(right.x, right.y);
      graphic.endShape(CLOSE);

      graphic.beginShape();
      graphic.vertex(tail.x, tail.y);
      graphic.vertex(last_tail.x, last_tail.y);
      graphic.vertex(last_left.x, last_left.y);
      graphic.vertex(left.x, left.y);
      graphic.endShape(CLOSE);
    }
    
    graphic.endDraw();
  }

  void draw()
  {
    if (this.automated || mousePressed)
    {      
      if (!CTL_DEBUG_MODE)
      {
        noStroke();
        //stroke(this._color.toARGB(), 60);
        fill(this._color.toARGB());
        //fill(0,10);
        //stroke(this._color.toARGB());
      }
      else
      {
        stroke(100);
        noFill();
      }
      
      
      //rect(width - 40, 40,20,20);
      
      beginShape();
      vertex(tail.x, tail.y);
      vertex(left.x, left.y);
      vertex(right.x, right.y);
      endShape(CLOSE);

      if (CTL_DEBUG_MODE)
      {
        stroke(this._color.toARGB(),60);
        fill(this._color.toARGB(),20);
      }
      

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
    
    if (CTL_SHOW_BRUSH)
    {
      drawPosition();
    }
    
    
    if (false && CTL_DEBUG_MODE)
    {
      noStroke();
       fill(255,0,0);
       ellipse(this.anchor.x, this.anchor.y, 5,5);

       noStroke();
       fill(0,255,0);
       ellipse(this.target.x, this.target.y, 5,5);


       fill(0,0,255);
       ellipse(this.motion.loc.x, this.motion.loc.y, 2,2);

       stroke(150);
       noFill();
       if (mousePressed)
       {
         line(this.target.x, this.target.y, this.anchor.x, this.anchor.y);
       }
       else
       {
         line(this.anchor.x, this.anchor.y, this.motion.loc.x, this.motion.loc.y);
       }  
    }
     
     

    
  }


}