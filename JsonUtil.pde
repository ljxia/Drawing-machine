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
      JSONObject json = new JSONObject(input);
      //println(json.getString("trail"));
      JSONArray array = new JSONArray(json.getString("trail"));
      //println(array.length() + array.toString());
      for (int i = 0; i < array.length() ; i++)
      {
        Vec3D v = JsonUtil.decodeVec3D(array.getString(i));
        if (v != null)
        {
          println(v.toString());
          pl.add(v);
        }
      } 
      
      return pl;
    }
    catch(JSONException e)
    {
      println(e.getMessage());
      return null;
    }
    
    
  }
}