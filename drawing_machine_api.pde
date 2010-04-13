import hypermedia.video.*;

import processing.opengl.*;

import toxi.color.*;
import toxi.color.theory.*;
import toxi.geom.*;
import toxi.geom.util.*;
import toxi.physics.*;
import toxi.physics.constraints.*;

dmComposer impersonal;
dmBrush brush;
dmCanvas canvas;

dmLineTraining trainLine;
dmPatternTraining trainPattern;
dmStructureTraining trainStructure;

VerletPhysics world;
PFont font;

/*temp*/

boolean recreateCurve = false;

void setup() 
{
  /*  sketch */
  
  size(screen.width - 250,screen.height - 60);
  //size(1024,768);  
  //size(1440, 900);

  frameRate(60);  
  background(255);
  smooth();

  /*  log */
  
  initLog();

  info("init world:" + width + ", " + height);
  
  /* controls */
  setupControls();
  
  /* initialize */
  
  hint( ENABLE_OPENGL_4X_SMOOTH );
  font = loadFont("04b-03-8.vlw");
  textFont(font);
  world = new VerletPhysics(new Vec3D(0,0,0),25,10,0.1);
  
  brush = new dmBrush(new Vec3D(width/2, height/2, 0), world, CTL_BRUSH_SIZE);  
  brush.setGray(CTL_BRUSH_SHADE);
  brush.setAlpha(0.95);

  //CTL_BRUSH_SIZE = 5;

  canvas = new dmCanvas(width, height - 80);
  canvas.setBrush(brush);
  canvas.changeSize(5);
  
  impersonal = new dmComposer(canvas);
  
  trainLine = new dmLineTraining(canvas);
  trainPattern = new dmPatternTraining(canvas);
  trainStructure = new dmStructureTraining(canvas);
}

void update()
{
    updateControls();

  /*  physics */
    world.update();

  /*  training */
    trainLine.update();
    trainPattern.update();

  /* apply setting */  
    if (!CTL_PLAYBACK)
    {
      brush.setGray(CTL_BRUSH_SHADE); 
      brush.setSize(CTL_BRUSH_SIZE);
    }
       
}

void draw() 
{
  update();
  
  if (CTL_CLEAR_BACKGROUND)
  {
    canvas.clear();
  }
  
  //brush.draw(); 

  impersonal.draw();
  
  if (CTL_SHOW_TOOL) drawTools();
  
  impersonal.drawGauge(width - 200, height - 80 + 1);
  
  if (trainLine.active){trainLine.display();}
  if (trainPattern.active){trainPattern.display();}
  if (trainStructure.active){trainStructure.display();}
}

void stop()
{
  destroyLog();
}




