class dmLine extends dmAbstractMemory
{
  dmLine()
  {
    this.serverMethod = "interpolation";
  }
  
  public String memorize(dmLineTraining training)
  {
    Vec3D vector = training.endPoint.sub(training.startPoint);
    
    this.setData("vector", vector.toString());
    this.setData("deviation", training.trailDeviation());
    this.setData("orientation",getOrientation(vector));
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

    params.put("vector",vector.toString());
    params.put("orientation", getOrientation(vector));
    params.put("length",vector.magnitude());
    
    String input = super.recall(params);
    //debug(input);
    try
    {
      JSONObject json = new JSONObject(input);
      this.setData("id",json.getString("id"));
      this.setData("vector",json.getString("vector"));

      this.setData("deviation",json.getString("deviation"));
      this.setData("steps",json.getString("steps"));
      
      debug("loaded interpolation: " + this.getData("id").toString());
      
      
      this.setData("trail", decodePointList(json.getString("trail")));
      
      return (PointList)this.getData("trail");
    }
    catch(JSONException e)
    {
      debug(e.getMessage());
      return null;
    }
  }
}