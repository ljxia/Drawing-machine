/* helpers */

String uploadFile(String url, String fileName)
{
  HttpClient httpclient = new DefaultHttpClient();
  HttpPost httppost = new HttpPost(url);
  FileBody filebody = new FileBody(new File(fileName));
  MultipartEntity reqEntity = new MultipartEntity();
  
  debug("ready to send file");
  
  try
  {
    debug("add file part: " + fileName);
    //reqEntity.addPart("id", new StringBody(id));
    reqEntity.addPart("userfile", filebody);
    
    httppost.setEntity(reqEntity);

    HttpResponse response = httpclient.execute(httppost);
    HttpEntity resEntity = response.getEntity();

    info("----------------------------------------");
    info(response.getStatusLine().toString());
    if (resEntity != null) 
    {
        info("Response content length: " + resEntity.getContentLength());
        BufferedReader reader = new BufferedReader(new InputStreamReader(resEntity.getContent()));

        try 
        {
          String result = reader.readLine();
          debug(result);
          return result;
        } 
        catch (IOException ex) 
        {
            throw ex;
        } 
        catch (RuntimeException ex) 
        {
            throw ex;
        } 
        finally 
        {
            reader.close();
        }
    }
    if (resEntity != null) {
        resEntity.consumeContent();
    }    
  }
  catch(Exception ex){}
  
  return "error";
}

String getNewVideoFilename()
{
  String videoFilename = "videos/drawing" + millis() + ".mov";
  return videoFilename;
}

String findExtension(String filename)
{
  int pos = -1;
  while (filename.indexOf(".", pos + 1) > pos)
  {
    pos = filename.indexOf(".", pos + 1);
  }
  
  if (pos > 0)
  {
    return filename.substring(pos);
  }
  else
  {
    return ".png";
  }
}

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

float [][] getPixelDistribution(dmCanvas canvas, int grain)
{
  float [][]distribution = new float[grain][grain];
  for (int i = 0; i < grain ; i++)
  {
    for (int j = 0; j < grain ; j++)
    {
      distribution[i][j] = 0f;
    }
  }
  
  PImage img = createImage(canvas.width, canvas.height, ARGB);
  
  canvas.saveImage(img);
                    
  img.loadPixels();                  
                    
  for (int i = 0; i < img.width ; i++)
  {
    for (int j = 0; j < img.height ; j++)
    {
      TColor c = TColor.newARGB(img.pixels[getPixelPosition(i,j,img.width,img.height)]);
      
      distribution[int(float(i * grain) / img.width)][int(float(j * grain) / img.height)] += (1 - c.brightness());
    }
  }
  
  return distribution;
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