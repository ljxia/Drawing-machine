class dmLineMemory extends dmAbstractMemory
{
  dmLineMemory()
  {
    this.serverMethod = "interpolation";
  }
  
  public String memorize(dmLineTraining training)
  {
    Vec3D vector = training.endPoint.sub(training.startPoint);
    this.setData("vector", vector.toString());
    this.setData("orientation",vector.angleBetween(new Vec3D(1,0,0), true) * 180 / PI);
    this.setData("length",vector.magnitude());
    this.setData("normalizedVector",vector.normalize().toString());
    this.setData("trail",training.trail.toString());
    this.setData("steps",training.trail.size());
    return super.memorize();
  }
  
  Object recall()
  {
    return null;
  }
}