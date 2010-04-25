class dmImageTraining extends dmAbstractTraining
{
  public int timeout = 60000;
  int blobIndex = 0;
  int currentThreshold = 0;
  
  dmContours contours;
  dmInspiration inspiration;
  
  dmImageTraining(dmCanvas c)
  {
    super(c);
  }
  
  dmContours findContour(PImage srcImg, int contourThreshold)
  {
    OpenCV vision = new OpenCV();
    vision.allocate(srcImg.width,srcImg.height); 
    vision.copy(srcImg);
    //vision.blur(OpenCV.BLUR, 5);

    vision.threshold(contourThreshold,0,OpenCV.THRESH_TOZERO); 

    Blob[] blobs = vision.blobs( 50, srcImg.width * srcImg.height / 4, 100, true, OpenCV.MAX_VERTICES * 100 );

    info("find blobs: " + blobs.length + " w/ threshold " + contourThreshold);

    return new dmContours(srcImg.width, srcImg.height , contourThreshold, blobs);
  }
  
  void initInspiration()
  {
    this.inspiration = new dmInspiration("4510439797_52462f4238_b.jpeg");
    this.inspiration.memorize();
    
    this.currentThreshold = 240;
    //this.contours = findContour(this.inspiration.image, floor(random(225)));
  }
  
  void activate()
  {
    this.initInspiration();
    super.activate();
  }

  void reset()
  {
    super.reset();
    
    this.blobIndex = 0;
    
    this.canvas.clearCommands();
    
    this.canvas.changeColor(new TColor(TColor.BLACK));
    this.canvas.changeSize(2);
  }
    
  void log(float x, float y, boolean newPattern, boolean newStroke)
  {
    //structure.log(x, y, newPattern, newStroke, this.canvas.getBrush());
  }
  
  void update()
  {
    if (this.active)
    {
      if ((this.lastLog > 0 && millis() - this.lastLog > this.timeout) || currentThreshold <= 0)
      {
        this.feedback();
      }
      else //accept logging
      { 
        if ((this.contours == null || blobIndex == this.contours.blobs.length) && this.canvas.commands.size() == 0)
        {
          this.contours = findContour(this.inspiration.image, currentThreshold);//floor(random(225))
          this.blobIndex = 0;
          this.currentThreshold -= 10;
        }
        if ( this.canvas.commands.size() == 0 && this.contours != null && this.contours.blobs != null && this.contours.blobs.length > 0)
        {
          if (blobIndex < this.contours.blobs.length)
          {
            Blob blob = this.contours.blobs[blobIndex];
            
            blobIndex++;

            dmPattern pattern = new dmPattern();

            // trace an arbitary part of the blob

            int randomStart = -1;
            int randomEnd = -1;

            randomStart = 0;
            randomEnd = blob.points.length;

            /*          
            int retry = 0;
            while ((randomEnd <= randomStart + 10 || randomEnd > randomStart + 100) && retry < 30)
            {
              randomStart = int(random(blob.points.length));
              randomEnd = int(random(randomStart, blob.points.length));
              retry ++;
            }*/

            //TODO more rules to select segment based on total length and trend
            if (randomEnd >= randomStart)
            {
              for (int i = randomStart; i < randomEnd ; i++)
              {
                float ratio = this.canvas.height / float(this.inspiration.getHeight());
                pattern.log(blob.points[i].x * ratio, blob.points[i].y * ratio, (i == randomStart), this.canvas.getBrush());
              }

              if (pattern.strokeCount() > 0)
              {
                pattern.inspiration_id = this.inspiration.id;
                pattern.memorize();
                this.contours.memorize(this.inspiration.id, pattern, blob);
              }

              //noFill();
              //stroke(255,0,0);
              //rect(pattern.topLeft.x, pattern.topLeft.y, pattern.bottomRight.x - pattern.topLeft.x, pattern.bottomRight.y - pattern.topLeft.y);
              this.canvas.changeSize(random(1,3)); 
              this.canvas.changeColor(this.currentThreshold);
              pattern.display(this.canvas, new Vec3D(), false); // pattern.topLeft.copy().scale(-1)
            }
          }
        }      
        
        if (this.isLogging)
        {          
          //this.log(mouseX, mouseY, colorChanged, strokePaused);
          this.lastLog = millis();
        }
      }
    }
  }
  
  void feedback()
  {
    if (this.canvas != null)
    {
      this.save();
      this.stop();
      this.reset();
    }
  }
  
  boolean save()
  {
    //return this.structure.memorize().equals("ok");
    return false;
  }
  
  void display()
  {
  }
  
}
