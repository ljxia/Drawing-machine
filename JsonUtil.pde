import org.json.*;

dmStroke decodeStroke(String input)
{
  try
  {
    dmStroke s = new dmStroke();
    
    JSONObject json = new JSONObject(input);

    s.id = json.optInt("id");
    s.trail = decodePointList(json.getString("trail"));
    s.brushSize = json.optLong("brushSize");
    s.brushColor = TColor.BLACK.copy().setARGB(json.optInt("brushColor"));
    
    return s;
  }
  catch(JSONException e)
  {
    return null;
  }
}

dmPattern decodePattern(String input)
{
  try
  {
    dmPattern p = new dmPattern();
    JSONObject json = new JSONObject(input);
    p.id = json.getInt("id");
    p.topLeft = decodeVec3D(json.getString("offset"));
    p.bottomRight = p.topLeft.add(json.getLong("width"), json.getLong("height"), 0);
    return p;
  }
  catch(JSONException e)
  {
    return null;
  }
}


Vec3D decodeVec3D(String input)
{
  try
  {
    JSONObject json = new JSONObject(input);
    Vec3D vector = new Vec3D(json.optLong("x"),json.optLong("y"),json.optLong("z"));
    return vector;
  }
  catch(JSONException e)
  {
    return new Vec3D();
  }
}

PointList decodePointList(String input)
{
  PointList pl = new PointList();
  try
  {
    JSONArray array = new JSONArray(input);
    //println(array.length() + array.toString());
    for (int i = 0; i < array.length() ; i++)
    {
      Vec3D v = decodeVec3D(array.getString(i));
      if (v != null)
      {
        //println(v.toString());
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
