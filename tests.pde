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
    canvas.moveTo(new Vec3D( 50 + i * 50, 100, 0));      
    canvas.lineTo(new Vec3D( 50 + i * 50, 100 + (8 - i) * 50, 0));
  }
  
  for (int i = 0; i < 8 ; i++)
  {
    canvas.changeSize(random(2,4));
    noStroke();
    fill(255, 0 , 0);
    ellipse(550, 50 + i * 50,3,3);
    ellipse(550 + (8 - i) * 50, 50 + i * 50,3,3);
    
    canvas.moveTo(new Vec3D(550, 50 + i * 50, 0));
    
    canvas.lineTo(new Vec3D(550 + (8 - i) * 50, 50 + i * 50, 0));
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
  Vec3D v = JsonUtil.decodeVec3D("{x:" + random(1000) + ", y:" + random(1000) + ",z:" + random(1000) + "}");
  debug(v.toString());
  debug(v.x + ", " + v.y + ", " + v.z);
}

void testLoadInterpolation()
{
  for (int count = 0; count < 30 ; count++)
  {
    Vec3D startPoint = new Vec3D(random(width), random(height), 0);

    dmLineMemory memory = new dmLineMemory();

    Vec3D vec = new Vec3D(random(-400,400),random(-400,400),0);
    float orientation = vec.angleBetween(new Vec3D(1,0,0), true) * 180 / PI;  
    if (vec.y > 0) orientation = 360 - orientation;


    stroke(0,255,255);
    noFill();
    line(startPoint.x, startPoint.y, startPoint.x + vec.x, startPoint.y + vec.y);

    PointList pl = memory.recall(vec);
    if (pl != null)
    {
      //debug(pl.toString());
      float factor = vec.magnitude() / float(memory.getData("length").toString());
      float angle = float(memory.getData("orientation").toString()) - orientation;
      pl = pl.scaleSelf(factor);
      for (int i = 0; i < pl.size() ; i++)
      {
        Vec3D pnt = pl.get(i);
        pnt = pnt.rotateZ(radians(angle));
      }
      canvas.trace(pl, startPoint);
    }
  }
  
}