import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 
import toxi.color.*; 
import toxi.color.theory.*; 
import toxi.geom.*; 
import toxi.geom.util.*; 
import toxi.physics.*; 
import toxi.physics.constraints.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class drawing_machine_api extends PApplet {










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


float FORCE_STRAIGHT = 1.7f;
float SPEED_STRAIGHT = 13;

float FORCE_CURVE = 25;
float SPEED_CURVE = 17;

public void setup() 
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
  world = new VerletPhysics(new Vec3D(0,0,0),25,10,0.1f);
  brush = new dmBrush(new Vec3D(width/2, height/2, 0), world, brush_size);
  
  brush.setGray(brush_shade);
  brush.setAlpha(0.85f);
  
  canvas = new dmCanvas(width, height);
  canvas.setBrush(brush);
  
  
  
}

public void draw() 
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

public void test()
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

public void drawTools()
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

public void keyPressed()
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

public void mouseReleased()
{
  //test();
  //brush.setSize(random(3,1));
  
  //brush.shuffleColor();
}

public void testLine()
{
  for (int i = 0; i < 8 ; i++)
  {
    canvas.changeSize(random(2,4));
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
public void testShape()
{
  for (int i = 0; i < 7 ; i++)
  {
    canvas.changeSize(random(2,4));
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
public void testCurve()
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

public void testCurve2()
{
  if (testCurve == null || recreateCurve)
  {
    testCurve = new Path();

    fill(255, 0 , 0);

    float left = width * 0.1f;
    float top = height * 0.5f;

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

public void testCircles()
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
public class AbstractBrush
{
  public VerletParticle anchor;
  public VerletParticle target;
  public VerletPhysics world;
  
  public Boid motion;
  public boolean automated = false;
  public boolean motionCompleted = true;
  
  public ArrayList tips;
  public ArrayList springs;
  
  private float _size = 10;
  public TColor _color;
  
  
  
  AbstractBrush(VerletPhysics physics)
  {
    this.world = physics;
    this.anchor = new VerletParticle(0,0,0);
    this.world.addParticle(this.anchor);
    this.target = new VerletParticle(0,0,0);
    this.world.addParticle(this.target);
    
    this.world.addSpring(new VerletConstrainedSpring(this.anchor, this.target, 0, 0.5f));
    
    this.tips = new ArrayList();
     this.springs = new ArrayList();
    this._color = TColor.newRandom();
    this.reset();
  }
  
  AbstractBrush(Vec3D center, VerletPhysics physics, float _size)
  {
    this.world = physics;
    this.anchor = new VerletParticle(center);
    this.world.addParticle(this.anchor);
    this.target = new VerletParticle(center);
    this.world.addParticle(this.target);
    
    this.world.addSpring(new VerletConstrainedSpring(this.anchor, this.target, 0, 0.5f));
    
    this._size = _size;
    
    this.tips = new ArrayList(); 
    this.springs = new ArrayList(); 
    this._color = TColor.BLACK.copy();
    
    this.reset();
  }
  
  public void setSize(float new_size)
  {
    
    for (int i = 0; i < this.springs.size() ; i++)
    {
      VerletSpring sp = ((VerletSpring)this.springs.get(i));
      sp.restLength = sp.restLength * new_size / this._size;
      this.springs.set(i, sp);
    }
    
    this._size = new_size;
  }
  
  public float getSize()
  {
    return this._size;
  }
  
  public void reset()
  {
    for (int i = 0; i < this.tips.size() ; i++)
    {
      this.world.removeParticle((VerletParticle)this.tips.get(i));
    }
    for (int i = 0; i < this.springs.size() ; i++)
    {
      this.world.removeSpring((VerletSpring)this.springs.get(i));
    }
    // to be implemented
  }
  
  public void moveTo(PVector target)
  {
    moveTo(target.x, target.y);
  }
  
  public void moveTo(Vec3D target)
  {
    moveTo(target.x, target.y);
  }
  
  public void moveTo(float x, float y)
  {
    this.target.x = x;
    this.target.y = y;
    
    if (this.anchor.distanceTo(this.target) > 2)
    {
      this.target.lock();
    }
    else
    {
      this.target.unlock();
    }
  }
  
  public void draw()
  {
    println("abstract draw");
  }
  
  public void draw(PGraphics canvas)
  {
    println("abstract draw on canvas");
  }
  
  public void setGray(float shade)
  {
    this._color = TColor.newRGBA(shade / 255, shade / 255,shade / 255,1);
  }
  
  public void setColor(TColor c)
  {
    this._color = c;
  }
  
  public void setColor(float r, float g, float b, float a)
  {
    this._color = TColor.newRGBA(r,g,b,a);
  }
  
  public void setAlpha(float alfa)
  {
    this._color.setAlpha(alfa);
  }
  
  public void shuffleColor()
  {
    this._color = TColor.newRandom();
    this._color.setBrightness(100);
  }
  
  public void automate(boolean _auto)
  {
    this.automated = _auto;
  }
  
}
// Seek_Arrive
// Daniel Shiffman <http://www.shiffman.net>

// The "Boid" class

// Created 2 May 2005

class Boid {

  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  
  float travelLength = 0;
  
  int pathProgress = 0;

  Boid(PVector l, float ms, float mf) {
    acc = new PVector(0,0);
    vel = new PVector(0,0);
    loc = l.get();
    r = 3.0f;
    maxspeed = ms;
    maxforce = mf;
  }

  public void run() {
    update();
    //borders();
    //render();
  }

  // Method to update location
  public void update() {
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(maxspeed);

    loc.add(vel);
    
    travelLength += vel.mag();
    // Reset accelertion to 0 each cycle
    acc.mult(0);
  }

  // This function implements Craig Reynolds' path following algorithm
  // http://www.red3d.com/cwr/steer/PathFollow.html
  public boolean follow(Path p, boolean close) {

    // Predict location 25 (arbitrary choice) frames ahead
    PVector predict = vel.get();
    predict.normalize();
    predict.mult(5);
    PVector predictLoc = PVector.add(loc, predict);

    // Draw the predicted location
    if (debug) {
      fill(0);
      stroke(0,0,255);
      line(loc.x,loc.y,predictLoc.x, predictLoc.y);
      //ellipse(predictLoc.x, predictLoc.y,4,4);
    }

    // Now we must find the normal to the path from the predicted location
    // We look at the normal for each line segment and pick out the closest one
    PVector target = null;
    PVector dir = null;
    float record = 1000000;  // Start with a very high record distance that can easily be beaten

    boolean isTail = false;
    PVector segment = null;
    // Loop through all points of the path
    for (int i = pathProgress; i < p.points.size()-1 && i < (pathProgress + 2); i++) {

      // Look at a line segment
      PVector a = (PVector) p.points.get(i);
      PVector b = (PVector) p.points.get(i+1);
      
      // the length of current segment we're following, if too short the max force should be decreased
      float segmentLength = PVector.dist(a, b);
      
      
     if (segmentLength < 80 && segmentLength > 0)
      {
        this.maxforce = map(segmentLength,0,80, 0.6f * FORCE_CURVE, FORCE_CURVE);
        this.maxspeed = map(segmentLength,0,80, 0.7f * SPEED_CURVE, SPEED_CURVE);
      }
      else
      {
        this.maxforce = FORCE_CURVE;
        this.maxspeed = SPEED_CURVE;
      }

      // Get the normal point to that line
      PVector normal = getNormalPoint(predictLoc,a,b);

      // Check if normal is on line segment
      float da = PVector.dist(normal,a);
      float db = PVector.dist(normal,b);
      PVector line = PVector.sub(b,a);
      // If it's not within the line segment, consider the normal to just be the end of the line segment (point b)
      if (da + db > line.mag()+1) {
        normal = b.get();
      }

      // How far away are we from the path?
      float d = PVector.dist(predictLoc,normal);
      // Did we beat the record and find the closest line segment?
      if (d < record/* && abs(PVector.angleBetween(line, this.vel)) < PI*/) {
        record = d;
        pathProgress = i;
        println("segment " + pathProgress);
        if (i == p.points.size() - 2)
        {
          isTail = true;
        }
        else
        {
          isTail = false;
        }
        //println("check tail!");
        // If so the target we want to steer towards is the normal
        target = normal;
        segment = line;
        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        dir = line;
        dir.normalize();
        // This is an oversimplification
        // Should be based on distance to path & velocity
        dir.mult(d * 2.5f);
      }
    }

    // Draw the debugging stuff
    if (debug && target != null) {
      // Draw normal location
      noFill();
      stroke(255,0,0);
      line(predictLoc.x,predictLoc.y,target.x,target.y);
      stroke(0);
      // Draw actual target (red if steering towards it)
      //line(predictLoc.x,predictLoc.y,target.x,target.y);
      if (record > p.radius) fill(255,0,0);
      noStroke();
      //ellipse(target.x+dir.x, target.y+dir.y, 8, 8);
    }

    // Only if the distance is greater than the path's radius do we bother to steer
    if (record > p.radius && target != null) {
      target.add(dir);
      if (isTail)
      {
        //println("is tail!");
        return true;
/*        if (close)
        {
          //arrive(p.tail());
          return true;
        }
        else
        {
          if (arrive(p.tail(), 0.15))
          {
            this.vel.mult(0);
            return true;
          }
          else if (PVector.dist(this.loc, p.tail()) < 5)
          {
            return true;
          }          
          else
          {
            this.vel.mult(0.9);
          }
        }*/
      }
      else
      {
        seek(target);	
      }
      		
    }
    return false;
  }


  // A function to get the normal point from a point (p) to a line segment (a-b)
  // This function could be optimized to make fewer new Vector objects
  public PVector getNormalPoint(PVector p, PVector a, PVector b) {
    // Vector from a to p
    PVector ap = PVector.sub(p,a);
    // Vector from a to b
    PVector ab = PVector.sub(b,a);
    ab.normalize(); // Normalize the line
    // Project vector "diff" onto line by using the dot product
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a,ab);
    return normalPoint;
  }

  public void seek(PVector target) {
    acc.add(steer(target,false));
  }

  public boolean arrive(PVector target, float threshold)
  {
    PVector steer = steer(target,true);
    acc.add(steer);

    if (steer.mag() < threshold && vel.mag() < 1)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
  public boolean arrive(PVector target) {
    return arrive(target,0.0010f);
  }

  // A method that calculates a steering vector towards a target
  // Takes a second argument, if true, it slows down as it approaches the target
  public PVector steer(PVector target, boolean slowdown) {
    PVector steer;  // The steering vector
    PVector desired = PVector.sub(target,loc);  // A vector pointing from the location to the target
    float d = desired.mag(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) {
      // Normalize desired
      desired.normalize();

      float theta = noise(frameCount) * 2 * PI;
      float scal = 0.03f;
      desired.add(new PVector(scal * cos(theta), scal * sin(theta)));
      //desired.normalize();

      // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if ((slowdown) && (d < 50.0f)) desired.mult(maxspeed*(d/1000.0f)); // This damping is somewhat arbitrary
      else desired.mult(maxspeed);
      // Steering = Desired minus Velocity
      steer = PVector.sub(desired,vel);
      steer.limit(maxforce);  // Limit to maximum steering force
      } else {
        steer = new PVector(0,0);
      }
      return steer;
    }

    public void render() {
      // Draw a triangle rotated in the direction of velocity
      float theta = vel.heading2D() + radians(90);
      fill(175);
      stroke(0);
      pushMatrix();
      translate(loc.x,loc.y);
      rotate(theta);
      beginShape(TRIANGLES);
      vertex(0, -r*2);
      vertex(-r, r*2);
      vertex(r, r*2);
      endShape();
      popMatrix();
    }

    // Wraparound
    public void borders() {
      if (loc.x < -r) loc.x = width+r;
      if (loc.y < -r) loc.y = height+r;
      if (loc.x > width+r) loc.x = -r;
      if (loc.y > height+r) loc.y = -r;
    }

  }
public class dmBrush extends AbstractBrush
{ 
  
  public VerletParticle tail;
  public VerletParticle left;
  public VerletParticle right;

  public Vec3D last_tail;
  public Vec3D last_left;
  public Vec3D last_right;


  public Vec3D motionStart;
  public Vec3D motionEnd = null;
  public Path motionCurve = null;
  
  public float localSpeedVar = 1.0f;
  
  boolean closeShape = false;
  
  
  

  dmBrush(Vec3D center, VerletPhysics physics, float _size)
  {
    super(center,physics,_size);
  }
  
  public void setPos(int x, int y)
  {
    setPos(new PVector(x,y));
  }
  
  public void setPos(Vec3D _target)
  {
    setPos(new PVector(_target.x, _target.y, _target.z));
  }
  
  public void setPos(PVector _target)
  {
    super.moveTo(_target);
  }
  
  public void moveTo(Vec3D _target)
  {
   this.motionEnd = new Vec3D(_target);
    
    this.motionCompleted = false;
    
    this.motion.vel.mult(0);
    
    this.motion.maxforce = FORCE_STRAIGHT;
    this.motion.maxspeed = SPEED_STRAIGHT * localSpeedVar;
    println("motion moveTo started");
  }
  
  public void lineTo(Vec3D _target)
  {
    this.automated = true;
    this.motionEnd = new Vec3D(_target);
    
    this.motion.vel.mult(0);
    this.motionCompleted = false;
    
    this.motion.maxforce = FORCE_STRAIGHT;
    this.motion.maxspeed = SPEED_STRAIGHT * localSpeedVar;
    
    println("motion lineTo started");
  }
  
  public void drawAlong(Path path)
  {
    this.automated = true;
    this.motionCurve = path;
    
    //this.motion.vel.mult(0);
    this.motionCompleted = false;
    this.motion.pathProgress = 0;
    this.motion.maxforce = FORCE_CURVE;
    this.motion.maxspeed = SPEED_CURVE;
    
    if (path.points.size() > 1)
    {
      PVector a = (PVector) path.points.get(0);
      PVector b = (PVector) path.points.get(1);
      
      PVector aug = PVector.sub(b,a);
      aug.normalize();
      this.motion.vel.add(aug);
      this.motion.vel.x = this.motion.vel.x * (1 + random(-0.4f, 0.4f));
      this.motion.vel.y = this.motion.vel.y * (1 + random(-0.4f, 0.4f));
    }
    
    println("motion drawAlong started");
  }

  public void reset()
  {
    super.reset();

/*    this.automated = true;*/

    this.motion = new Boid(new PVector(this.anchor.x, this.anchor.y), SPEED_STRAIGHT,FORCE_STRAIGHT);

    this.tail = new VerletParticle(this.anchor);
    this.tail.y += this.getSize() * 3;
    this.world.addParticle(this.tail);

    this.left = new VerletParticle(this.anchor);
    this.left.x -= this.getSize() * 0.8f;
    this.left.y -= this.getSize() * 0.5f;
    this.world.addParticle(this.left);

    this.right = new VerletParticle(this.anchor);
    this.right.x += this.getSize() * 0.8f;
    this.right.y -= this.getSize() * 0.5f;
    this.world.addParticle(this.right);


    this.tips.add(this.tail);
    this.tips.add(this.left);
    this.tips.add(this.right);


    VerletSpring tailSpring = new VerletConstrainedSpring(this.anchor, this.tail, this.anchor.distanceTo(this.tail),1.4f);
    VerletSpring leftSpring = new VerletConstrainedSpring(this.anchor, this.left, this.anchor.distanceTo(this.left), 1);
    VerletSpring rightSpring = new VerletConstrainedSpring(this.anchor, this.right, this.anchor.distanceTo(this.right), 1);

    VerletSpring headpring = new VerletSpring(this.left, this.right, this.left.distanceTo(this.right), 0.5f);
    VerletSpring leftSideSpring = new VerletSpring(this.tail, this.left, this.tail.distanceTo(this.left), 0.5f);
    VerletSpring rightSideSpring = new VerletSpring(this.tail, this.right, this.tail.distanceTo(this.right), 0.5f);

    this.world.addSpring(tailSpring);
    this.world.addSpring(leftSpring);
    this.world.addSpring(rightSpring);
    this.world.addSpring(headpring);
    this.world.addSpring(leftSideSpring);
    this.world.addSpring(rightSideSpring);


    this.springs.add(tailSpring);     
    this.springs.add(leftSpring);     
    this.springs.add(rightSpring);    
    this.springs.add(headpring);      
    this.springs.add(leftSideSpring); 
    this.springs.add(rightSideSpring);

    this.update();
  }

  public void update()
  {
    this.motion.run();
    
    this.last_tail = new Vec3D(this.tail);
    this.last_left = new Vec3D(this.left);
    this.last_right = new Vec3D(this.right);
    
    if (this.motion != null && this.motionEnd != null && !motionCompleted) // line to and move to
    {
      if (this.motion.arrive(new PVector(motionEnd.x, motionEnd.y)))
      {
        motionCompleted = true;
        this.motionEnd = null;
        this.automated = false;
        println("motion completed");
      }      
      this.setPos(this.motion.loc);
    }
    else if (this.motion != null && this.motionCurve != null && !motionCompleted) // curve following
    {
      if (this.motion.follow(motionCurve, closeShape) || this.motion.travelLength > (1.3f * this.motionCurve.length()))
      {
        
        if (this.motion.travelLength > (0.5f * this.motionCurve.length()))
        {
          motionCompleted = true;

          this.automated = false;
          println("motion completed");

          if (this.motion.travelLength < (1.2f * this.motionCurve.length()) && random(0,1) < 0.6f)
          {
            //complete the stroke
            /*PVector p = (PVector)this.motionCurve.points.get(0);
                        this.lineTo(new Vec3D(p.x, p.y, 0));*/
          }

          this.motionCurve = null;
        }
        
      }
      this.setPos(this.motion.loc);
    }
    
    
      
  }
  
  public float getTravelLength()
  {
    return this.motion.travelLength;
  }
  
  public void resetTravelLength()
  {
    this.motion.travelLength = 0;
  }

  public void draw()
  {
    if (this.automated || mousePressed)
    {
      noStroke();
      //fill(0,10);
      //stroke(this._color.toARGB());
      fill(this._color.toARGB());
      
      //rect(width - 40, 40,20,20);
      
      beginShape();
      vertex(tail.x, tail.y);
      vertex(left.x, left.y);
      vertex(right.x, right.y);
      endShape(CLOSE);

      beginShape();
      vertex(tail.x, tail.y);
      vertex(last_tail.x, last_tail.y);
      vertex(last_right.x, last_right.y);
      vertex(right.x, right.y);
      endShape(CLOSE);

      beginShape();
      vertex(tail.x, tail.y);
      vertex(last_tail.x, last_tail.y);
      vertex(last_left.x, last_left.y);
      vertex(left.x, left.y);
      endShape(CLOSE);
    }
    
     //noStroke();
     //fill(255,0,0);
    
    //ellipse(this.anchor.x, this.anchor.y, 2,2);

    //stroke(0,0,255);
    //noFill();
    //ellipse(this.motion.loc.x, this.motion.loc.y, 5,5);

    
  }


}
class dmCanvas
{
  dmBrush _brush;
  ArrayList commands;

  dmCanvas(int w, int h)
  {
    this.commands = new ArrayList();
  }

  public dmBrush getBrush()
  {
    return this._brush;
  }

  public void setBrush(dmBrush b)
  {
    this._brush = b;
  }
  
  
  public void changeColor(float _gray)
  {
    dmCommand cmd = new dmCommand("color");
    TColor _color = TColor.newRGBA(_gray / 255, _gray / 255,_gray / 255,1);
    cmd.params.put("color", _color);
    this.commands.add(cmd);
    println("command in queue:" + this.commands.size());
  }
  
  public void changeColor(TColor _color)
  {
    dmCommand cmd = new dmCommand("color");
    cmd.params.put("color", _color);
    this.commands.add(cmd);
    println("command in queue:" + this.commands.size());
  }
  
  public void changeSize(float _size)
  {
    dmCommand cmd = new dmCommand("size");
    cmd.params.put("size", _size);
    this.commands.add(cmd);
    println("command in queue:" + this.commands.size());
  }
  
  public void moveTo(Vec3D pos)
  {
    dmCommand cmd = new dmCommand("move");
    cmd.params.put("target", pos);
    this.commands.add(cmd);
    println("command in queue:" + this.commands.size());
  }

  public void lineTo(Vec3D pos)
  {
    dmCommand cmd = new dmCommand("line");
    cmd.params.put("target", pos);
    this.commands.add(cmd);
    println("command in queue:" + this.commands.size());
  }
  
  public void rectangle(Vec3D corner, float _width, float _height)
  {
    moveTo(corner);
    moveTo(corner);
    lineTo(corner.add(0, (_height), 0));
    moveTo(corner);
    lineTo(corner.add((_width), 0, 0));
    lineTo(corner.add((_width), (_height), 0));
    moveTo(corner.add(0, (_height), 0));
    lineTo(corner.add((_width), (_height), 0));
  }
  
  public void follow(Path path, boolean closeShape)
  {
    dmCommand cmd = new dmCommand("follow");
    cmd.params.put("path", path);
    cmd.params.put("close", closeShape);
    this.commands.add(cmd);
    println("command in queue:" + this.commands.size());
  }
  
  public void circle(Vec3D center, float _radius)
  {
    float steps = constrain (map(_radius,30,1000, 24,120), 24, 120);
    
    float theta = random(0, 2 * PI);
    
    float overlap = 0;
    moveTo(center.add(_radius * cos(theta), _radius * sin(theta),0));
    
    
    Path path = new Path();
    
    for (float i = 0; i <= steps + overlap; i += random(0,1))
    {
      path.addPoint(center.x + _radius * cos(theta + 2 * PI * i/ steps),  center.y + _radius * sin(theta + 2 * PI * i/ steps));
    }
    
    path.addPoint(center.x + _radius * cos(theta + 1/ steps) + random(0.5f, 1),  center.y + _radius * sin(theta + 1/ steps) + random(0.5f, 1));
    
    this.follow(path, true);
  }
  
  public void curve(Path path)
  {
    if (path.points != null && path.points.size() > 1)
    {
      PVector p = (PVector)path.points.get(0);
      //path.points.remove(0);
      this.moveTo(new Vec3D(p.x, p.y, 0));
      
      p = path.tail();
      
      path.addPoint(p.x + random(1,2),p.y + random(1,2));
      this.follow(path, false);
    }
    
  }
  
  public void clearCommands()
  {
    this.commands.clear();
  }

  public void update()
  {
    //
    if (this._brush.motionCompleted && !this.commands.isEmpty())
    {
      dmCommand cmd = (dmCommand)this.commands.remove(0);
      
      
      println("----");
      print(millis() + ": ");
      if (cmd.name.equals("move"))
      {
          Vec3D target = (Vec3D)cmd.params.get("target");
          this._brush.resetTravelLength();
          this._brush.moveTo(target);
          println("move to " + target.x + ", " + target.y);
      }
      else if (cmd.name.equals("line"))
      {
          Vec3D target = (Vec3D)cmd.params.get("target");
          this._brush.resetTravelLength();
          this._brush.lineTo(target);
          println("line to " + target.x + ", " + target.y);
      }
      else if (cmd.name.equals("follow"))
      {
          Path path = (Path)cmd.params.get("path");
          Boolean closeShape = (Boolean)cmd.params.get("close");
          this._brush.resetTravelLength();
          this._brush.closeShape = closeShape;
          //path.display();
          this._brush.drawAlong(path);
          println("draw along path - node count " + path.points.size());
      }
      else if (cmd.name.equals("color"))
      {
          TColor c = (TColor)cmd.params.get("color");
          this._brush.setColor(c);
      }
      else if (cmd.name.equals("size"))
      {
          float s = PApplet.parseFloat(cmd.params.get("size").toString());
          this._brush.setSize(s);
      }
    }
    
    
    
  }

  public void draw(int x, int y)
  {
    this._brush.draw();
    this._brush.update();
  }

  public void clear()
  {
    noStroke();
    fill(255);
    rect(0,0,width, height);
  }
}
class dmCommand
{
  public String name;
  public Hashtable params;
  
  dmCommand(String _name)
  {
    name = _name;
    params = new Hashtable();
  }
  
}
class dmEvaluation
{
  public ArrayList rules;
  
  dmEvaluation()
  {
    rules = new ArrayList();
  }
  
  public void addRule(dmEvaluationRule rule)
  {
    this.rules.add(rule);
  }
}

class dmEvaluationRule
{
  public int evaluate(PApplet pa)
  {
    return 0;
  }
  
  public dmCommand suggest()
  {
    return null;
  }
}
// Path Following
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code, Spring 2009

class Path {

  // A Path is an arraylist of points (PVector objects)
  ArrayList points;
  // A path has a radius, i.e how far is it ok for the boid to wander off
  float radius;
  float _length = -1;

  Path() {
    // Arbitrary radius of 20
    radius = 2;
    points = new ArrayList();
  }

  // Add a point to the path
  public void addPoint(float x, float y) {
    PVector point = new PVector(x,y);
    points.add(point);
    _length = calculateLength();
  }
  
  public float calculateLength()
  {
    float l = 0;
    for (int i = 0; i < points.size()-1; i++) {
      PVector start = (PVector) points.get(i);
      PVector end = (PVector) points.get(i+1);
      l += PVector.dist(start, end);
    }
    return l;
  }
  
  public float length()
  {
    if (_length < 0)
    {
      _length = calculateLength();
    }
    return _length;
  }
  
  public PVector tail()
  {
    return (PVector) this.points.get(this.points.size() - 1);
  }

  // Draw the path
  public void display() {

    // Draw the radius as thick lines and circles
    if (debug) {
      // Draw end points
      for (int i = 0; i < points.size(); i++) {
        PVector point = (PVector) points.get(i);
        fill(175);
        noStroke();
        ellipse(point.x,point.y,radius*2,radius*2);
      }

      // Draw Polygon around path
      for (int i = 0; i < points.size()-1; i++) {
        PVector start = (PVector) points.get(i);
        PVector end = (PVector) points.get(i+1);
        PVector line = PVector.sub(end,start);
        PVector normal = new PVector(line.y,-line.x);
        normal.normalize();
        normal.mult(radius);

        // Polygon has four vertices
        PVector a = PVector.add(start, normal);
        PVector b = PVector.add(end, normal);
        PVector c = PVector.sub(end, normal);
        PVector d = PVector.sub(start, normal);

        fill(175);
        noStroke();
        beginShape();
        vertex(a.x,a.y);
        vertex(b.x,b.y);
        vertex(c.x,c.y);
        vertex(d.x,d.y);
        endShape();
      }
    }

    // Draw Regular Line
    stroke(0);
    noFill();
    beginShape();
    for (int i = 0; i < points.size(); i++) {
      PVector loc = (PVector) points.get(i);
      vertex(loc.x,loc.y);
    }
    endShape();

  }

}




  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#c0c0c0", "drawing_machine_api" });
  }
}
