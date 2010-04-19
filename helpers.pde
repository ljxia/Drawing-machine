/* helpers */

float getOrientation(Vec3D vector)
{
  float orientation = vector.angleBetween(new Vec3D(1,0,0), true) * 180 / PI;
  
  if (vector.y > 0) orientation = 360 - orientation;
  
  return orientation;
}

int getPixelPosition(int x, int y, int w, int h)
{
  if (x >= w || y >= h)
  {
    return 0;
  }
  return y * w + x;
}

PointList rotatePointList(PointList pl, Vec3D origin, Vec3D target)
{
  float factor = target.magnitude() / origin.magnitude();
  float angle = getOrientation(origin) - getOrientation(target);
  pl = pl.scaleSelf(factor);
  for (int i = 0; i < pl.size() ; i++)
  {
    Vec3D pnt = pl.get(i);
    pnt = pnt.rotateZ(radians(angle));
  }
  
  return pl;
}