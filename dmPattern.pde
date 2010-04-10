class dmPattern extends dmAbstractMemory
{
  dmPattern()
  {
    this.serverMethod = "pattern";
  }
  
  public String memorize(dmPatternTraining training)
  {
    this.setData("trail",training.trail.toString());
    this.setData("steps",training.trail.size());
    
    return super.memorize();
  }
  
  PointList recall(Vec3D vector)
  {
    Hashtable params = new Hashtable();

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
      
      
      this.setData("trail", JsonUtil.decodePointList(json.getString("trail")));
      
      return (PointList)this.getData("trail");
    }
    catch(JSONException e)
    {
      debug(e.getMessage());
      return null;
    }
  }
}