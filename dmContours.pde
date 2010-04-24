class dmContours extends dmAbstractMemory
{
  public Blob []blobs;
  public PGraphics snapshot;
  public float area;
  public float threshold;
  
  dmContours(int w, int h, float threshold, Blob[] blbs)
  {
    this.blobs = blbs;
    this.snapshot = createGraphics(w, h, JAVA2D);;
    this.threshold = threshold;
    
    this.snapshot.beginDraw();
    this.snapshot.smooth();
    //pg.background(0,125,255);
    this.snapshot.noStroke();

    this.area = 0;

    for( int i=0; i<blobs.length; i++ ) 
    {
      if (blobs[i].isHole)
      {
        this.snapshot.fill(0);

        this.area += blobs[i].area;
      }
      else
      {
        this.snapshot.fill(255);

        this.area -= blobs[i].area;
      }

      this.snapshot.beginShape();
      for( int j=0; j<blobs[i].points.length; j++ ) 
      {
        this.snapshot.vertex( blobs[i].points[j].x, blobs[i].points[j].y );
      }
      this.snapshot.endShape(CLOSE);
    } 
    this.snapshot.endDraw();
  }
  
  String memorize(int inspirationId, dmPattern pattern, Blob blob)
  {
/*    if (true)
    {
      return "";
    }*/
    
    
    //generate snapshot for contour pattern
    
    int margin = 20;
    
    int canvasWidth = int(pattern.getWidth()) + margin * 2;
    int canvasHeight = int(pattern.getHeight()) + margin * 2;
    
    
    dmBrush contourBrush = new dmBrush(new Vec3D(canvasWidth/2, canvasHeight/2, 0), world, 1);  
    contourBrush.setGray(0);
    contourBrush.setAlpha(0.95);
    
    dmCanvasMemory contourCanvas = new dmCanvasMemory(canvasWidth, canvasHeight);
    contourCanvas.setBrush(contourBrush);
    contourCanvas.changeSize(1.5);

    pattern.display(contourCanvas, pattern.topLeft.copy().scale(-1).addSelf(margin, margin, 0), false);

    parallelCanvases.add(contourCanvas);
    
    return "";
    
    //pattern.display();
  
    
    
    
/*    HttpRequest req = new HttpRequest();
    String url = serverUrlBase + "learn/" + serverMethod;
    debug("-----------------");
    debug("ping url: " + url);
    debug("POST param:" + this.getData().toString());
    try
    {
      String res = req.send(url,"POST",this.getData(),null);
      debug(res);
      return res;
    }
    catch (Exception e){return "error: " + e.getMessage();}*/
  }
}