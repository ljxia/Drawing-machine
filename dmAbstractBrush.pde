public class dmAbstractBrush
{
  public dmCanvas parentCanvas;
  public VerletParticle anchor;
  public VerletParticle target;
  public VerletPhysics world;
  
  public Boid motion;
  public boolean automated = false;
  public boolean motionCompleted = true;
  
  public ArrayList tips;
  public ArrayList springs;
  protected ArrayList springLengths;
  
  private float _size = 1;
  public TColor _color;
  
  protected Integrator _scale;
  
  dmAbstractBrush(VerletPhysics physics)
  {
    this.parentCanvas = null;
    
    this.world = physics;
    this.anchor = new VerletParticle(0,0,0,10);
    this.world.addParticle(this.anchor);
    this.target = new VerletParticle(0,0,0,1);
    this.world.addParticle(this.target);
    
    this.world.addSpring(new VerletConstrainedSpring(this.anchor, this.target, 0, 0.3));
    
    this.tips = new ArrayList();
    this.springs = new ArrayList();
    this.springLengths = new ArrayList();
    this._color = TColor.newRandom();
    this._scale = new Integrator(1,0.3,0.1);
    this.reset();
  }
  
  dmAbstractBrush(Vec3D center, VerletPhysics physics, float _size)
  {
    this.parentCanvas = null;
    
    this.world = physics;
    this.anchor = new VerletParticle(center);
    this.world.addParticle(this.anchor);
    this.target = new VerletParticle(center);
    this.world.addParticle(this.target);
    
    this.world.addSpring(new VerletConstrainedSpring(this.anchor, this.target, 0, 0.3));
    
    this._size = _size;
    
    this.tips = new ArrayList(); 
    this.springs = new ArrayList(); 
    this.springLengths = new ArrayList();
    this._color = TColor.BLACK.copy();
    this._scale = new Integrator(1,0.3,0.1);
    this.reset();
  }
  
  Vec3D getPos()
  {
    return (Vec3D)this.anchor;
  }
  
  void setSize(float new_size, boolean force)
  {
    //TODO: affect CTL_BRUSH_SIZE wisely
    
    if (force)
    {
      this._scale.set(new_size);
      this.update();
      debug("brush size force changed to " + new_size);
    }
    else
    {
      this.setSize(new_size);
    }
  }
  
  void setSize(float new_size)
  {
    this._scale.target(new_size);
    //debug("size: " + this._size + ", scale: " + this._scale.get());
    //this._size = new_size;
  }
  
  float getSize()
  {
    return this._size;// * this._scale.get();
  }
  
  float getScale()
  {
    return this._scale.get();
  }
  
  TColor getColor()
  {
    return this._color;
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
  
  void update()
  {
    this._scale.update();
    
    for (int i = 0; i < this.springs.size() ; i++)
    {
      VerletSpring sp = ((VerletSpring)this.springs.get(i));
      float sl = float(this.springLengths.get(i).toString());
      sp.restLength = sl * this._scale.get();
      this.springs.set(i, sp);
    }
    if (CTL_PLAYBACK)
    {
      debug("all brush strings are updated with new scale: " + this._scale.get());
    }
    
  }
  
  boolean moveTo(PVector target)
  {
    return moveTo(target.x, target.y);
  }
  
  boolean moveTo(Vec3D target)
  {
    return moveTo(target.x, target.y);
  }
  
  boolean moveTo(float x, float y)
  {
    if (this.target.distanceTo(new Vec3D(x,y,0)) > 0)
    {
      this.target.x = x;
      this.target.y = y;

      if (this.anchor.distanceTo(this.target) > 4)
      {
        this.target.lock();
        return false;
      }
      else
      {
        this.target.unlock();
        return true;
      }
    }
    return true;
  }
  
  void draw()
  {
    debug("abstract draw");
  }
  
  void draw(PGraphics canvas)
  {
    debug("abstract draw on canvas");
  }
  
  void setGray(float shade)
  {
    this._color = TColor.newRGBA(shade / 255, shade / 255,shade / 255,1);
  }
  
  void setColor(TColor c)
  {
    this._color = c;
    
    debug("brush color changed to " + this._color.toString());
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