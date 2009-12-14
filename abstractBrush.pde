public class AbstractBrush
{
  public VerletParticle anchor;
  public VerletParticle target;
  public VerletPhysics world;
  
  public Boid motion;
  public boolean automated = false;
  public boolean motionCompleted = true;
  
  public ArrayList tips;
  public ArrayList springs;
  
  private float _size = 10;
  public TColor _color;
  
  
  
  AbstractBrush(VerletPhysics physics)
  {
    this.world = physics;
    this.anchor = new VerletParticle(0,0,0);
    this.world.addParticle(this.anchor);
    this.target = new VerletParticle(0,0,0);
    this.world.addParticle(this.target);
    
    this.world.addSpring(new VerletConstrainedSpring(this.anchor, this.target, 0, 0.5));
    
    this.tips = new ArrayList();
     this.springs = new ArrayList();
    this._color = TColor.newRandom();
    this.reset();
  }
  
  AbstractBrush(Vec3D center, VerletPhysics physics, float _size)
  {
    this.world = physics;
    this.anchor = new VerletParticle(center);
    this.world.addParticle(this.anchor);
    this.target = new VerletParticle(center);
    this.world.addParticle(this.target);
    
    this.world.addSpring(new VerletConstrainedSpring(this.anchor, this.target, 0, 0.5));
    
    this._size = _size;
    
    this.tips = new ArrayList(); 
    this.springs = new ArrayList(); 
    this._color = TColor.BLACK;
    
    this.reset();
  }
  
  void setSize(float new_size)
  {
    
    for (int i = 0; i < this.springs.size() ; i++)
    {
      VerletSpring sp = ((VerletSpring)this.springs.get(i));
      sp.restLength = sp.restLength * new_size / this._size;
      this.springs.set(i, sp);
    }
    
    this._size = new_size;
  }
  
  float getSize()
  {
    return this._size;
  }
  
  void reset()
  {
    for (int i = 0; i < this.tips.size() ; i++)
    {
      this.world.removeParticle((VerletParticle)this.tips.get(i));
    }
    for (int i = 0; i < this.springs.size() ; i++)
    {
      this.world.removeSpring((VerletSpring)this.springs.get(i));
    }
    // to be implemented
  }
  
  void moveTo(PVector target)
  {
    moveTo(target.x, target.y);
  }
  
  void moveTo(Vec3D target)
  {
    moveTo(target.x, target.y);
  }
  
  void moveTo(float x, float y)
  {
    this.target.x = x;
    this.target.y = y;
    
    if (this.anchor.distanceTo(this.target) > 2)
    {
      this.target.lock();
    }
    else
    {
      this.target.unlock();
    }
  }
  
  void draw()
  {
    println("abstract draw");
  }
  
  void draw(PGraphics canvas)
  {
    println("abstract draw on canvas");
  }
  
  void setGray(float shade)
  {
    this._color = TColor.newRGBA(shade / 255, shade / 255,shade / 255,1);
  }
  
  void setColor(TColor c)
  {
    this._color = c;
  }
  
  void setColor(float r, float g, float b, float a)
  {
    this._color = TColor.newRGBA(r,g,b,a);
  }
  
  void setAlpha(float alfa)
  {
    this._color.setAlpha(alfa);
  }
  
  void shuffleColor()
  {
    this._color = TColor.newRandom();
    this._color.setBrightness(100);
  }
  
  void automate(boolean _auto)
  {
    this.automated = _auto;
  }
  
}