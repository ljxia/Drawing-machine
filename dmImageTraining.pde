class dmImageTraining extends dmAbstractTraining
{
  public int timeout = 60000;
  PImage img;
  dmContours contours;
  
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

    PGraphics pg = createGraphics(srcImg.width, srcImg.height, JAVA2D);

    vision.threshold(contourThreshold,0,OpenCV.THRESH_TOZERO); 

    Blob[] blobs = vision.blobs( 100, srcImg.width * srcImg.height / 4, 100, true, OpenCV.MAX_VERTICES * 100 );

    println("find blobs: " + blobs.length + " w/ threshold " + contourThreshold);

    pg.beginDraw();
    pg.smooth();
    //pg.background(0,125,255);
    pg.noStroke();

    float area = 0;

    for( int i=0; i<blobs.length; i++ ) 
    {
      if (blobs[i].isHole)
      {
        pg.fill(0);

        area += blobs[i].area;
      }
      else
      {
        pg.fill(255);

        area -= blobs[i].area;
      }

      pg.beginShape();
      for( int j=0; j<blobs[i].points.length; j++ ) 
      {
        pg.vertex( blobs[i].points[j].x, blobs[i].points[j].y );
      }
      pg.endShape(CLOSE);
    } 
    pg.endDraw();


    return new dmContours(blobs, pg, area);
  }
  

  void reset()
  {
    super.reset();
    
    this.canvas.clearCommands();
    
    this.canvas.changeColor(new TColor(TColor.BLACK));
    this.canvas.changeSize(2);
    
    
    //img = loadImage("theinstamatic.jpeg");
    //img = loadImage("chiaki.jpeg");
    img = loadImage("tumblr_l19qr0A4R11qa57amo1_500.jpeg");
    //img = loadImage("tumblr_l00kikGLDS1qaorky.jpeg");
    
    for (int i = 0; i < img.width; i++) {
      img.pixels[i] = color(255,255,255); 
      img.pixels[img.width + i] = color(255,255,255); 
      img.pixels[(img.height - 2) * img.width + i] = color(255,255,255); 
      img.pixels[(img.height - 1) * img.width + i] = color(255,255,255); 
    }

    for (int i = 0; i < img.height; i++) {
      img.pixels[i * img.width] = color(255,255,255); 
      img.pixels[i * img.width + 1] = color(255,255,255); 
      img.pixels[i * img.width + img.width - 2] = color(255,255,255); 
      img.pixels[i * img.width + img.width - 1] = color(255,255,255); 
    }

    img.updatePixels();
    
  }
    
  void log(float x, float y, boolean newPattern, boolean newStroke)
  {
    //structure.log(x, y, newPattern, newStroke, this.canvas.getBrush());
  }
  
  void update()
  {
    if (this.active)
    {
      if (this.lastLog > 0 && millis() - this.lastLog > this.timeout)
      {
        this.feedback();
      }
      else //accept logging
      {
        this.contours = findContour(img, floor(random(225)));
        
        if (this.canvas.commands.size() == 0 && this.contours.blobs.length > 0)
        {
          Blob blob = this.contours.blobs[int(random(this.contours.blobs.length))];
          
          if (!blob.isHole)
          {
            return;
          }
          dmPattern pattern = new dmPattern();
          
          // trace an arbitary part of the blob
          
          int randomStart = -1;
          int randomEnd = -1;
          
          randomStart = 0;
          randomEnd = blob.points.length;
          
/*          while (randomEnd <= randomStart + 10 || randomEnd > randomStart + 100)
          {
            randomStart = int(random(blob.points.length));
            randomEnd = int(random(randomStart, blob.points.length));
          }*/
          
          this.canvas.changeSize(random(1,3)); 
          this.canvas.changeColor(random(0, 200));
          
          //TODO more rules to select segment based on total length and trend
          if (randomEnd >= randomStart)
          {
            for (int i = randomStart; i < randomEnd ; i++)
            {
              float ratio = this.canvas.height / float(img.height);
              pattern.log(blob.points[i].x * ratio, blob.points[i].y * ratio, (i == randomStart), this.canvas.getBrush());
            }
            //noFill();
            //stroke(255,0,0);
            //rect(pattern.topLeft.x, pattern.topLeft.y, pattern.bottomRight.x - pattern.topLeft.x, pattern.bottomRight.y - pattern.topLeft.y);
            pattern.display(this.canvas, pattern.topLeft.copy().scale(-1), false);
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
/*    float newHeight = this.canvas.height * 0.9;
    float newWidth = contours.snapshot.width * newHeight / contours.snapshot.height;
    
    imageMode(CENTER);
    image(contours.snapshot,this.canvas.width / 2, this.canvas.height / 2, newWidth, newHeight);
    imageMode(CORNER);*/
  }
  
}
