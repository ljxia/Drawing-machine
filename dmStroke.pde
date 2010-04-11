class dmStroke extends dmAbstractMemory
{
  public int id;
  public PointList trail;
  public float brushSize;
  public TColor brushColor;
  
  public Vec3D topLeft;
  public Vec3D bottomRight;
  
  dmStroke()
  {
    this.serverMethod = "stroke";
    this.reset();
  }
  
  dmStroke(dmBrush b)
  {
    this();
    
    this.brushSize = b.getScale();
    this.brushColor = b.getColor();
  }
  
  public void log(float x, float y)
  {
    this.trail.add(new Vec3D(x, y, (this.trail.size() == 0) ? 1 : 0));
    
    if (this.topLeft.x > x) {this.topLeft.x = x;}
    if (this.topLeft.y > y) {this.topLeft.y = y;}
    if (this.bottomRight.x < x) {this.bottomRight.x = x;}
    if (this.bottomRight.y < y) {this.bottomRight.y = y;}
  } 
  
  private void reset()
  {
    this.id = -1;
    
    this.trail = new PointList();
    this.brushSize = 3;
    this.brushColor = TColor.BLACK.copy();
    
    this.topLeft = new Vec3D(9999,9999,0);
    this.bottomRight = new Vec3D(0,0,0);
  }
  
  public String memorize(int patternId)
  {
    this.setData("pattern_id", patternId);
    this.setData("trail",this.trail);
    this.setData("brushSize",this.brushSize);
    this.setData("brushColor",this.brushColor.toARGB());
    this.setData("density", 0);
    
    return super.memorize();
  }
}