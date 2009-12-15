import processing.opengl.*;

import toxi.color.*;
import toxi.color.theory.*;
import toxi.geom.*;
import toxi.geom.util.*;
import toxi.physics.*;
import toxi.physics.constraints.*;

dmBrush brush;
dmCanvas canvas;

VerletPhysics world;

int brush_size = 3;
float brush_shade = 0;

PFont font;


boolean SHOW_TOOL = false;

boolean debug = false;

Path testCurve = null;
boolean recreateCurve = false;


float FORCE_STRAIGHT = 1.7;
float SPEED_STRAIGHT = 13;

float FORCE_CURVE = 25;
float SPEED_CURVE = 17;

void setup() 
{
  size(screen.width,screen.height);
  
  //size(1280, 720);
  
  frameRate(60);
  //size(1024,768,JAVA2D);
  background(255);
  smooth();
  
  //hint( ENABLE_OPENGL_4X_SMOOTH );
  font = loadFont("04b-03-8.vlw");
  textFont(font);
  world = new VerletPhysics(new Vec3D(0,0,0),25,10,0.1);
  brush = new dmBrush(new Vec3D(width/2, height/2, 0), world, brush_size);
  
  brush.setGray(brush_shade);
  brush.setAlpha(0.85);
  
  canvas = new dmCanvas(width, height);
  canvas.setBrush(brush);
  
  
  
}

void draw() 
{
  fill(255);
  //rect(-1, -1 ,width + 1,height + 1);
  world.update();
  brush.setPos(mouseX, mouseY);
  //brush.draw(); 


  for (int i = 0; i < 1 ; i++)
  {
    canvas.update();
    canvas.draw(0,0);
/*    try
    {
      wait(100);
    }
    catch(Exception e)
    {}*/
    
  }
  
  
  //test();
  
  
  if (SHOW_TOOL) drawTools();
}

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

void drawTools()
{
  
/*  fill(255,10);
  rect(0,0,width,40);*/
  
  stroke(200);
  fill(255);
  rect(-1,-1,120,40);
  noStroke();
  fill(0);
  
  textSize(8);
  text("brush size", 20, 22);
  fill(brush_shade);
  ellipseMode(CENTER);
  ellipse(90, 18, brush_size, brush_size);
}

void keyPressed()
{
  if (key == 'c' || key == ' ')
  {
    fill(255);
    rect(-1, -1 ,width + 1,height + 1);
    canvas.clear();
  }
  
  
  if (key == '+' || key == '=')
  {
    if (brush_size < 13)
    {
      brush_size++;
      brush.setSize(brush_size);
    }
  }
  
  if (key == '-')
  {
    if (brush_size > 2)
    {
      brush_size--;
      brush.setSize(brush_size);
    }
  }
  
  if (key == '[')
  {
    if (brush_shade > 0)
    {
      brush_shade -= 5;
      brush.setGray(brush_shade);
    }
  }
  
  if (key == ']')
  {
    if (brush_shade < 255)
    {
      brush_shade += 5;
      brush.setGray(brush_shade);
    }
  }
  
  if (key == 's')
  {
    saveFrame("images/sketch-#####.png");
  }
  
  if (key == 't')
  {
    SHOW_TOOL = !SHOW_TOOL;
  }
  
  if (key == 'a')
  {
    brush.automate(!brush.automated); 
  }
  
  if (key == 'd')
  {
    float distance = random(50,350);
    float theta = random(0,1) * 2 * PI;
    brush.lineTo(new Vec3D( constrain(brush.anchor.x + distance * cos(theta), 0, width), constrain(brush.anchor.y + distance * sin(theta), 0 ,height), 0));
  }
  
  if (key == 'r')
  {
    canvas.clearCommands();
    recreateCurve = true;
  }
  
  if (key == 'n')
  {
    testLine();
  }
  
  if (key == 'm')
  {
    testShape();    
    //testLine();
  }
  
  if (key == 'l')
  {
    testCurve2();
  }
  
  if (key == 'q')
  {
    testCircles();
  }
}

void mouseReleased()
{
  //test();
  //brush.setSize(random(3,1));
  
  //brush.shuffleColor();
}

void testLine()
{
  for (int i = 0; i < 8 ; i++)
  {
    canvas.changeSize(random(2,5));
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
    canvas.changeSize(random(2,5));
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
    canvas.changeSize(random(2,5));
    stroke(255,0,0);
    noFill();
    rect(50 + i * 200, 400,150,170);
    canvas.rectangle(new Vec3D( 50 + i * 200, 400, 0), 150,170);
    
    stroke(255,0,0);
    noFill();
    ellipse(125 + i * 200, 700,150,150);
    canvas.circle(new Vec3D(125 + i * 200, 700, 0), 75);
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
    println("circles left: " + (number_of_circle - i - 1));
  }
  
}
