class dmContours extends dmAbstractMemory
{
  public Blob []blobs;
  public PGraphics snapshot;
  public float area;
  public float threshold;
  
  dmContours(int w, int h, float threshold, Blob[] blbs)
  {
    this.serverMethod = "contour";
    
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
    if (false)
    {
      return "";
    }
    
    this.setData("inspiration_id",inspirationId);
    this.setData("pattern_id",pattern.id);
    this.setData("threshold",this.threshold);
    this.setData("area",blob.area);
    this.setData("isHole", blob.isHole ? "0" : "1");
    
    int newId = -1;    
    String result = super.memorize().trim();
    newId = int(result);
    
    if (newId > 0)
    {
      //generate snapshot for contour pattern

      int margin = 20;

      int canvasWidth = int(pattern.getWidth()) + margin * 2;
      int canvasHeight = int(pattern.getHeight()) + margin * 2;
      
      // set up off-screen canvas

      dmBrush contourBrush = new dmBrush(new Vec3D(canvasWidth/2, canvasHeight/2, 0), world, 1);  
      contourBrush.setGray(0);
      contourBrush.setAlpha(0.95);

      dmCanvasMemory contourCanvas = new dmCanvasMemory(canvasWidth, canvasHeight);
      contourCanvas.setBrush(contourBrush);
      
      String serverUrl = serverUrlBase + "upload/" + serverMethod + "/" + newId;
      contourCanvas.setRemoteUrl(serverUrl);

      // setup drawing commands 
      pattern.display(contourCanvas, pattern.topLeft.copy().scale(-1).addSelf(margin, margin, 0), false);
      
      
      // send off-screen canvas to global drawing queue
      parallelCanvases.add(contourCanvas);
    }
    
    return "";
  }
}