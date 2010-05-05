import hypermedia.video.*;
import processing.video.*;
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


ArrayList trainings;

dmLineTraining trainLine;
dmPatternTraining trainPattern;
dmStructureTraining trainStructure;
dmImageTraining trainImage;
dmPatternAnalysisTraining trainPatternAnalysis;

ArrayList parallelCanvases;

VerletPhysics world;
PFont font;

/*temp*/

boolean recreateCurve = false;

float lastBrushSize = 0;
int lastBrushShade = 0;

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
  
  impersonal = new dmComposer(this, canvas);
  
  trainings = new ArrayList();
  
  trainLine = new dmLineTraining(canvas);
  trainings.add(trainLine);
  
  trainPattern = new dmPatternTraining(canvas);
  trainings.add(trainPattern);
  
  trainStructure = new dmStructureTraining(canvas);
  trainings.add(trainStructure);
  
  trainImage = new dmImageTraining(canvas);
  trainings.add(trainImage);
  
  trainPatternAnalysis = new dmPatternAnalysisTraining(canvas);
  trainings.add(trainPatternAnalysis);
  
  parallelCanvases = new ArrayList();
}

void update()
{
    updateControls();

    /*  physics */
    world.update();
    
    /* composer */
    impersonal.update();

    /*  training */
    for (int i = 0; i < trainings.size() ; i++)
    {
      ((dmAbstractTraining)trainings.get(i)).update();
    }
    
    /*
    trainLine.update();
    trainPattern.update();
    trainStructure.update();
    trainImage.update();
    trainPatternAnalysis.update();
    */

    /* apply setting */  
    if (!CTL_PLAYBACK)
    {
      if (CTL_BRUSH_SHADE != lastBrushSize)
      {
        brush.setGray(CTL_BRUSH_SHADE); 
      }
      
      if (CTL_BRUSH_SIZE != lastBrushSize)
      {
        brush.setSize(CTL_BRUSH_SIZE);
      }
    }
    
    lastBrushSize = CTL_BRUSH_SIZE;
    lastBrushShade = CTL_BRUSH_SHADE;
}

void draw() 
{
  update();
  
  if (CTL_CLEAR_BACKGROUND)
  {
    canvas.clear();
  }

  impersonal.draw();
  
  for (int i = 0; i < trainings.size() ; i++)
  {
    dmAbstractTraining t = (dmAbstractTraining)trainings.get(i);
    if (t.active){t.display();}
  }
  
  /*
  if (trainLine.active){trainLine.display();}
  if (trainPattern.active){trainPattern.display();}
  if (trainStructure.active){trainStructure.display();}
  if (trainImage.active){trainImage.display();}
  if (trainPatternAnalysis.active){trainPatternAnalysis.display();}
  */
  
  
  if (CTL_SHOW_TOOL) {drawTools();}
  
  impersonal.context.display(width - 200, height - 80 + 1);

  // render offscreen canvas
  for (int i = parallelCanvases.size() - 1; i >= 0  ; i--)
  {
    if (parallelCanvases.get(i) != null)
    {
      dmCanvasMemory c = (dmCanvasMemory)parallelCanvases.get(i);
      if (c.update())
      {
        parallelCanvases.set(i, null);
      }
    }
    else
    {
      parallelCanvases.remove(i);
    }
  }
  
}

void stop()
{
  destroyLog();
  impersonal.finish();
}




