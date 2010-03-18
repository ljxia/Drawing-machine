import processing.opengl.*;

import toxi.color.*;
import toxi.color.theory.*;
import toxi.geom.*;
import toxi.geom.util.*;
import toxi.physics.*;
import toxi.physics.constraints.*;

dmBrush brush;
dmCanvas canvas;
dmLineTraining trainLine;

VerletPhysics world;
PFont font;

/*control params*/

public float CTL_BRUSH_SIZE = 1;
public float CTL_BRUSH_SHADE = 0;
public boolean CTL_DEBUG_MODE = false;
public boolean CTL_CLEAR_BACKGROUND = false;
public boolean CTL_SHOW_TOOL = false;

public float FORCE_STRAIGHT = 1.7;
public float SPEED_STRAIGHT = 13;

public float FORCE_CURVE = 25;
public float SPEED_CURVE = 17;

/*temp*/

boolean recreateCurve = false;

void setup() 
{
  //size(screen.width,screen.height);
  //size(1024,768);  
  size(1440, 900);
  
  frameRate(60);  
  background(255);
  smooth();
  
  /* controls */
  setupControls();
  
  /* initialize */
  
  //hint( ENABLE_OPENGL_4X_SMOOTH );
  font = loadFont("04b-03-8.vlw");
  textFont(font);
  world = new VerletPhysics(new Vec3D(0,0,0),25,10,0.1);
  brush = new dmBrush(new Vec3D(width/2, height/2, 0), world, CTL_BRUSH_SIZE);
  
  brush.setGray(CTL_BRUSH_SHADE);
  brush.setAlpha(0.95);
  brush.setSize(5);
  canvas = new dmCanvas(width, height);
  canvas.setBrush(brush);
  
  trainLine = new dmLineTraining();
}



void draw() 
{
  updateControls();
  
  if (CTL_CLEAR_BACKGROUND)
  {
    canvas.clear();
  }
  
  world.update();
  trainLine.update();
  
  brush.setSize(CTL_BRUSH_SIZE);
  brush.setGray(CTL_BRUSH_SHADE);
  brush.setPos(mouseX, mouseY);
  //brush.draw(); 


  for (int i = 0; i < 1 ; i++)
  {
    canvas.update();
    canvas.draw(0,0);

    /*  
    try {wait(100);}
    catch(Exception e){}
    */
    
  }
  
  if (CTL_SHOW_TOOL) drawTools();
  if (trainLine.active){trainLine.display();}
  
}




