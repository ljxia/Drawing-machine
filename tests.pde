Path testCurve = null;

void test()
{
  noStroke();
  fill(255,0,0);
  ellipse(100,100,60,60);
  beginShape();
  vertex(200,200);
  vertex(300,400);
  vertex(250, 600);
  endShape(CLOSE);
}

void testLine()
{
  for (int i = 0; i < 8 ; i++)
  {
    canvas.changeSize(random(2,8));
    //canvas.rectangle(new Vec3D(random(0, width - 200), random(0, height - 200), 0), random(50,200), random(50,200));
    noStroke();
    fill(255, 0 , 0);
    ellipse(50 + i * 50, 100,3,3);
    ellipse(50 + i * 50, 100 + (8 - i) * 50,3,3);    
    canvas.line(new Vec3D( 50 + i * 50, 100, 0), new Vec3D( 50 + i * 50, 100 + (8 - i) * 50, 0));
  }
  
  for (int i = 0; i < 8 ; i++)
  {
    canvas.changeSize(random(2,4));
    noStroke();
    fill(255, 0 , 0);
    ellipse(550, 50 + i * 50,3,3);
    ellipse(550 + (8 - i) * 50, 50 + i * 50,3,3);
    
    canvas.line(new Vec3D(550, 50 + i * 50, 0), new Vec3D(550 + (8 - i) * 50, 50 + i * 50, 0));
  }
}

void testShape()
{
  for (int i = 0; i < 7 ; i++)
  {
    canvas.changeSize(random(2,4));
    stroke(255,0,0);
    noFill();
    rect(50 + i * 200, 100,150,170);
    canvas.rectangle(new Vec3D( 50 + i * 200, 100, 0), 150,170);
    
    stroke(255,0,0);
    noFill();
    ellipse(125 + i * 200, 400,150,150);
    canvas.circle(new Vec3D(125 + i * 200, 400, 0), 75);
  }
  
  for (int i = 0; i < 7 ; i++)
  {
    
  }
}

void testCurve()
{
  Path p = new Path();
 
  fill(255, 0 , 0);
  ellipse(850, 50, 3,3);
  p.addPoint(850, 50);
  
  ellipse(920, 120, 3,3);
  p.addPoint(920, 120);
  
  ellipse(1000, 260, 3,3);
  p.addPoint(1000, 260);
  
  ellipse(1100, 320, 3,3);
  p.addPoint(1100, 320);
  
  ellipse(1200, 325, 3,3);
  p.addPoint(1200, 325);
  
  ellipse(1300, 260, 3,3);
  p.addPoint(1300, 260);
  
  ellipse(1400, 220, 3,3);
  p.addPoint(1400, 220);
  
  ellipse(1350, 210, 3,3);
  p.addPoint(1350, 210);
  
  canvas.curve(p);
}

void testCurve2()
{
  if (testCurve == null || recreateCurve)
  {
    testCurve = new Path();

    fill(255, 0 , 0);

    float left = width * 0.1;
    float top = height * 0.5;

    for (int i = 0; i < 10 ; i++)
    {

      ellipse(left, top, 3,3);
      testCurve.addPoint(left, top);

      left += random(50,150);
      top += random(-150,150);

      left = constrain(left, 0, width);
      top = constrain(top,0,height);

    }
    
    recreateCurve = false;
  }
  
  canvas.changeColor(random(0,200));
  canvas.curve(testCurve);
}

void testCircles()
{
  int number_of_circle = 500;//int(random(10,40));
  
  for (int i = 0; i < number_of_circle ; i++)
  {
    float x = random(width);
    float y = random(height);
    float r = random(10,250);
    canvas.changeSize(random(1,map(r,10,250,7,20)));
    canvas.changeColor(random(30,255));
    //stroke(120);
    //noFill();
    //ellipse(x, y, r * 2, r * 2);
    canvas.circle(new Vec3D(x, y, 0), r);
    debug("circles left: " + (number_of_circle - i - 1));
  }
  
}

void testHttpRequest()
{
  HttpRequest req = new HttpRequest();
  //String u = "http://itp.nyu.edu/~lx243/sensornet/index.php/api/stats/0013A200403D8A20";
  String u = "http://localhost/~liangjie/impersonal/index.php/learn/interpolation";
  
  
  try
  {
    Hashtable params = new Hashtable();
    params.put("apple",URLEncoder.encode("pie","UTF-8"));
    params.put("test",URLEncoder.encode("bingo","UTF-8"));
    params.put("mod",URLEncoder.encode("flash","UTF-8"));
    debug("request sent");
    debug("------------");
  
    debug(req.send(u,"POST",params,null));
    debug("----------------");
    debug("request finished");
    debug("----------------");
  }
  catch (Exception e)
  {
    debug("request failed");
    debug("--------------");
  }
}

void testJson()
{
  Vec3D v = decodeVec3D("{x:" + random(1000) + ", y:" + random(1000) + ",z:" + random(1000) + "}");
  debug(v.toString());
  debug(v.x + ", " + v.y + ", " + v.z);
}

void testLoadInterpolation()
{
  for (int count = 0; count < 5 ; count++)
  {
    Vec3D startPoint = new Vec3D(random(width), random(height), 0);

    dmLine memory = new dmLine();

    Vec3D vec = new Vec3D(random(-400,400),random(-400,400),0);

    stroke(0,255,255);
    noFill();
    line(startPoint.x, startPoint.y, startPoint.x + vec.x, startPoint.y + vec.y);

    PointList pl = memory.recall(vec);
    if (pl != null)
    {
      //debug(pl.toString());
      
      Vec3D refVec = decodeVec3D(memory.getData("vector").toString());
      pl = rotatePointList(pl, refVec, vec);
      
      canvas.trace(pl, startPoint);
    }
  }
}

void testLineWithInterpolation()
{
  for (int count = 0; count < 5 ; count++)
  {
    Vec3D startPoint = new Vec3D(random(width), random(height), 0);

    dmLine memory = new dmLine();

    Vec3D vec = new Vec3D(random(-400,400),random(-400,400),0);

    stroke(0,100,0);
    noFill();
    line(startPoint.x, startPoint.y, startPoint.x + vec.x, startPoint.y + vec.y);

    canvas.line(startPoint, startPoint.add(vec));
  }
}

void testLoadPattern()
{
    dmPattern memory = new dmPattern();
    memory.recall();
    
    Vec3D startPoint = new Vec3D(0,0,0);
    
    impersonal.canvas.clear();
    
    stroke(255,0,0);
    noFill();
    rect(memory.topLeft.x, memory.topLeft.y, memory.getWidth(), memory.getHeight());
    
    memory.display(impersonal.canvas, startPoint);
}

void testLoadStructure()
{
    Vec3D startPoint = new Vec3D(0,0,0);

    dmStructure memory = new dmStructure();
    memory.recall();
    
    impersonal.canvas.clear();
    
    memory.display(impersonal.canvas, startPoint);
}


void testPushBuffer()
{
  canvas.pushBuffer();
}

void testPopBuffer()
{
  canvas.popBuffer();
}

void testPGraphics()
{
  PGraphics buffer = createGraphics(400, 300, P2D);
  buffer.beginDraw();
  buffer.noStroke();
  buffer.rectMode(CENTER);
  for (int i = 0; i < 1000 ; i++)
  {
     buffer.fill(random(255),random(255),random(255),random(250));
     buffer.rect(random(400), random(300), random(10,100), random(10, 100));
  }
  buffer.endDraw();
  image(buffer,0,0);
  buffer.save("buffer.png");
}

void testEmail()
{
  sendMail(savePath("drawings/20100419-180508.png"), "Dimension: ???? x ???? \n Steps Used: 19");
  //sendMail(savePath("buffer.png"));
  //sendMail(savePath("drawing1858.mov"));
}

void testSymmetry()
{
  dmSymmetryRule rule = new dmSymmetryRule();
  rule.evaluate(impersonal.context);
}

void testEvaluation()
{
  debug("-------- EVAL ---------");
  impersonal.canvas.pushBuffer();
  
  PImage img = impersonal.canvas.buffer;
  
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
  
  PImage buffer = createImage(img.width, img.height,ARGB);
  OpenCV opencv = new OpenCV(this);
  opencv.allocate(impersonal.canvas.width,impersonal.canvas.height); 
  
  
  //for (int threshold = 250; threshold > 0; threshold -= 50)
  
  int threshold = 240;
  {
    buffer.copy(img,0,0,img.width,img.height,0,0,img.width,img.height);

    opencv.copy(buffer);

    opencv.blur(OpenCV.BLUR, 7);

    opencv.threshold(threshold,0,OpenCV.THRESH_TOZERO); 
    Blob[] blobs = opencv.blobs( 10, impersonal.canvas.width * impersonal.canvas.height / 2, 100, true, OpenCV.MAX_VERTICES * 100 );

    debug("find blobs: " + blobs.length + " w/ threshold " + threshold);

    // draw blob results
    for( int i=0; i<blobs.length; i++ ) 
    {
      debug("blob #" + i + ": " + blobs[i].points.length + " vertices, is " + (blobs[i].isHole ? "not " : "") + "hole, " + "length: " + blobs[i].length  + " area: " + blobs[i].area );

      if (blobs[i].isHole)
      {
        fill(255,0,0);    
      }
      else
      {
        fill(0,0,255);
      }
      
      beginShape();
      for( int j=0; j<blobs[i].points.length; j++ ) {
        vertex( blobs[i].points[j].x, blobs[i].points[j].y );
      }
      endShape(CLOSE);
      
      //fill(255,255,0);
      //ellipse(blobs[i].centroid.x,blobs[i].centroid.y,7,7);
      
      stroke(0,70,0);
      noFill();
      rect(blobs[i].rectangle.x,  blobs[i].rectangle.y,blobs[i].rectangle.width,blobs[i].rectangle.height);
      
      noStroke();
      fill(0,70,0);
      float radius = sqrt(blobs[i].area);
      rect(blobs[i].rectangle.x + blobs[i].rectangle.width / 2 - radius / 2,  blobs[i].rectangle.y + blobs[i].rectangle.height / 2 - radius / 2,radius,radius);
      
      
    }

    //image(opencv.image(), 0, 0);    
  }
  
  

  
}