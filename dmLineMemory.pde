class dmLineMemory extends dmAbstractMemory
{
  dmLineMemory()
  {
    this.serverMethod = "interpolation";
  }
  
  public String memorize(dmLineTraining training)
  {
    Vec3D vector = training.endPoint.sub(training.startPoint);
    float orientation = vector.angleBetween(new Vec3D(1,0,0), true) * 180 / PI;
    
    if (vector.y < 0) orientation = 360 - orientation;
    
    this.setData("vector", vector.toString());
    this.setData("deviation", training.trailDeviation());
    this.setData("orientation",orientation);
    this.setData("length",vector.magnitude());
    this.setData("normalizedVector",vector.normalize().toString());
    this.setData("trail",training.trail.toString());
    this.setData("steps",training.trail.size());
    
    debug("deviation: " + this.getData("deviation"));
    
    return super.memorize();
  }
  
  PointList recall(Vec3D vector)
  {
    Hashtable params = new Hashtable();
    float orientation = vector.angleBetween(new Vec3D(1,0,0), true) * 180 / PI;
    
    if (vector.y < 0) orientation = 360 - orientation;
    
    params.put("vector",vector);
    params.put("orientation", orientation);
    params.put("length",vector.magnitude());
    
    String result = super.recall(params);
    //debug(result);
    return JsonUtil.decodePointList(result);
  }
}