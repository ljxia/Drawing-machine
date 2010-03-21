import org.json.*;

static class JsonUtil
{
  static Vec3D decodeVec3D(String input)
  {
    try
    {
      JSONObject json = new JSONObject(input);
      Vec3D vector = new Vec3D(json.optLong("x"),json.optLong("y"),json.optLong("z"));
      return vector;
    }
    catch(JSONException e)
    {
      return null;
    }
  }
  
  static PointList decodePointList(String input)
  {
    PointList pl = new PointList();
    try
    {
      JSONArray json = new JSONArray(input);
      
      for (int i = 0; i < json.length() ; i++)
      {
        Vec3D v = JsonUtil.decodeVec3D(json.getString(i));
        if (v != null)
        {
          pl.add(v);
        }
      } 
      
      return pl;
    }
    catch(JSONException e)
    {
      return null;
    }
    
    
  }
}