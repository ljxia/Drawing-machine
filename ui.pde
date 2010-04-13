import controlP5.*;

ControlP5 controlP5;
ControlWindow controlWindow;
Radio CTL_STATE;
Radio CTL_FUNCTION_TEST;
Radio CTL_DRAWING_TEST;

/*control params*/

public float CTL_BRUSH_SIZE = 1;
public float CTL_BRUSH_SHADE = 0;
public boolean CTL_DEBUG_MODE = false;
public boolean CTL_CLEAR_BACKGROUND = false;
public boolean CTL_SHOW_TOOL = true;
public boolean CTL_SHOW_BRUSH = false;
public boolean CTL_AUTORUN = true;
public boolean CTL_USE_MOUSE = false;

public boolean CTL_PLAYBACK = false;

public float CTL_USE_TRAINED_INTERPOLATION = 0.95;


public float FORCE_STRAIGHT = 1.7;
public float SPEED_STRAIGHT = 13;

public float FORCE_CURVE = 25;
public float SPEED_CURVE = 17;

void setupControls()
{
  controlP5 = new ControlP5(this);
  controlP5.setAutoInitialization(true);
  
  controlP5.setAutoDraw(true);
  controlP5.setColorActive(color(255,50,50));
  controlP5.setColorBackground(color(200));
  controlP5.setColorForeground(color(255,180,180));
  controlP5.setColorLabel(color(30));
  
  controlWindow = controlP5.addControlWindow("controlP5window",screen.width - 250,0,250,height);
  controlWindow.setBackground(color(255));
  controlWindow.setUpdateMode(ControlWindow.NORMAL);
  controlWindow.hideCoordinates();
  
  controlP5.addSlider("CTL_BRUSH_SIZE",   1,  40, CTL_BRUSH_SIZE,   20, 120, 100,  10).setWindow(controlWindow);
  controlP5.addSlider("CTL_BRUSH_SHADE",  0,  255,CTL_BRUSH_SHADE,  20, 140, 100,  10).setWindow(controlWindow);
  controlP5.addSlider("CTL_USE_TRAINED_INTERPOLATION",  0,  1,CTL_USE_TRAINED_INTERPOLATION,  20, 160, 100,  10).setWindow(controlWindow);
  
  controlP5.addToggle("CTL_DEBUG_MODE",       CTL_DEBUG_MODE,         20,   180, 10, 10).setWindow(controlWindow);
  controlP5.addToggle("CTL_CLEAR_BACKGROUND", CTL_CLEAR_BACKGROUND,  100,  180, 10, 10).setWindow(controlWindow);
  
  controlP5.addToggle("CTL_SHOW_BRUSH",       CTL_SHOW_BRUSH,  20,   210, 10, 10).setWindow(controlWindow);
  controlP5.addToggle("CTL_AUTORUN",          CTL_AUTORUN,    100,   210, 10, 10).setWindow(controlWindow);
  
  controlP5.addToggle("CTL_USE_MOUSE",       CTL_USE_MOUSE,  20,   240, 10, 10).setWindow(controlWindow);
  controlP5.addToggle("CTL_PLAYBACK",       CTL_PLAYBACK,  100,   240, 10, 10).setWindow(controlWindow);
  
  CTL_STATE = controlP5.addRadio("stateChange",20,20);
  
  //r.deactivateAll(); // use deactiveAll to not make the first radio button active.
  CTL_STATE.add("COMPOSE",101);
  CTL_STATE.add("INTERPOLATION TRAINING",102);
  CTL_STATE.add("PATTERN TRAINING",103);
  CTL_STATE.add("STRUCTURE TRAINING",104);
  CTL_STATE.add("EXTERNAL MEMORY TRAINING",105);
  CTL_STATE.add("DO NOTHING", 100);
  CTL_STATE.setWindow(controlWindow);
  
  CTL_FUNCTION_TEST = controlP5.addRadio("functionTest",20,290);
  
  CTL_FUNCTION_TEST.add("TEST NOTHING",200);
  CTL_FUNCTION_TEST.add("Test Http Request",201);
  CTL_FUNCTION_TEST.add("Test Json",202);
  CTL_FUNCTION_TEST.add("Test PGraphics", 203);
  CTL_FUNCTION_TEST.add("Test Load Interpolation",204);
  CTL_FUNCTION_TEST.add("Test Line Interpolation",205);
  CTL_FUNCTION_TEST.add("Test Load Pattern",206);
  CTL_FUNCTION_TEST.setWindow(controlWindow);
  
  
  CTL_DRAWING_TEST = controlP5.addRadio("drawingTest",20,400);
  CTL_DRAWING_TEST.add("TEST NOTHING",300);
  CTL_DRAWING_TEST.add("Test Line",301);
  CTL_DRAWING_TEST.add("Test Shape",302);
  CTL_DRAWING_TEST.add("Test Curve",303);
  CTL_DRAWING_TEST.add("Test Circle",304);
  CTL_DRAWING_TEST.setWindow(controlWindow);
  
}

void updateControls()
{
  try
  {
    controlP5.controller("CTL_BRUSH_SIZE").setValue(CTL_BRUSH_SIZE);
    controlP5.controller("CTL_BRUSH_SHADE").setValue(CTL_BRUSH_SHADE);
    controlP5.controller("CTL_USE_TRAINED_INTERPOLATION").setValue(CTL_USE_TRAINED_INTERPOLATION);

    ((Toggle)controlP5.controller("CTL_DEBUG_MODE")).setState(CTL_DEBUG_MODE);
    ((Toggle)controlP5.controller("CTL_CLEAR_BACKGROUND")).setState(CTL_CLEAR_BACKGROUND);   
    ((Toggle)controlP5.controller("CTL_SHOW_BRUSH")).setState(CTL_SHOW_BRUSH); 
    ((Toggle)controlP5.controller("CTL_AUTORUN")).setState(CTL_AUTORUN);
    ((Toggle)controlP5.controller("CTL_USE_MOUSE")).setState(CTL_USE_MOUSE);    
    ((Toggle)controlP5.controller("CTL_PLAYBACK")).setState(CTL_PLAYBACK);    
  }
  catch(java.lang.NullPointerException e){}
}

void startComposing()
{
  setIdle();
  info("Switch to Composing");
  impersonal.play();
  impersonal.canvas.clear();
}

void startLineTraining()
{
  setIdle();
  info("Switch to Line Training");
  trainLine.activate();    
}

void startPatternTraining()
{
  setIdle();
  info("Switch to Pattern Training");
  trainPattern.activate(); 
}

void startStructureTraining()
{
  setIdle();
  info("Switch to Structure Training");
  trainStructure.activate();
}

void setIdle()
{
  trainLine.deactivate();
  trainPattern.deactivate();
  trainStructure.deactivate();
  
  impersonal.canvas.clearCommands();
  impersonal.pause();
  
  info("Switch to Idle");
}

public void stateChange(int theID) 
{
  switch(theID) 
  {
    case(101):
      startComposing();  
      break;  
    case(102):
      startLineTraining();
      break;
    case(103):
      startPatternTraining();
      break;
    case(104):
      startStructureTraining();
      break;
    default:
      setIdle();
      break;
  }

}

public void functionTest(int theID) 
{
  setIdle();
  
  switch(theID) 
  {
    case(201):
      testHttpRequest();
    break;  
    case(202):
      testJson();
    break;
    case(203):
      testPGraphics();
    break;
    case(204):
      testLoadInterpolation();
    break;
    case(205):
      testLineWithInterpolation();
    break;
    case(206):
      testLoadPattern();
    break;
    default:
      //setIdle();
    break;
  }
}

public void drawingTest(int theID) 
{
  setIdle();
  
  switch(theID) 
  {
    case(301):
      testLine();
    break;  
    case(302):
      testShape();
    break;
    case(303):
      testCurve2();
    break;
    case(304):
      testCircles();
    break;
    default:
      //setIdle();
    break;
  }
}

void keyPressed()
{
  if (key == 'c')
  {
    fill(255);
    rect(-1, -1 ,width + 1,height + 1);
    canvas.clear();
  }
  
  if (key == ' ')
  {
    if (impersonal.paused)
    {
      impersonal.play();
    }
    else
    {
      impersonal.canvas.clear();
      impersonal.canvas.clearCommands();
      impersonal.pause();
    }
  }
  
  if (key == '+' || key == '=')
  {
    if (CTL_BRUSH_SIZE < 40)
    {
      CTL_BRUSH_SIZE++;
      //brush.setSize(CTL_BRUSH_SIZE);
    }
  }
  
  if (key == '-')
  {
    if (CTL_BRUSH_SIZE > 2)
    {
      CTL_BRUSH_SIZE--;
      //brush.setSize(CTL_BRUSH_SIZE);
    }
  }
  
  if (key == '[')
  {
    if (CTL_BRUSH_SHADE > 0)
    {
      CTL_BRUSH_SHADE -= 5;
      //brush.setGray(CTL_BRUSH_SHADE);
    }
  }
  
  if (key == ']')
  {
    if (CTL_BRUSH_SHADE < 255)
    {
      CTL_BRUSH_SHADE += 5;
      //brush.setGray(CTL_BRUSH_SHADE);
    }
  }
  
  if (key == 's')
  {
    //saveFrame("images/sketch-#####.png");
    impersonal.canvas.pushBuffer();
    impersonal.canvas.dumpBuffer();
  }
  
  if (key == 't')
  {
    if (!trainLine.active)
    {
      startLineTraining();
    }
    else
    {
      startComposing();
    }
    
  }
  
  if (key == 'd')
  {
    CTL_DEBUG_MODE = !CTL_DEBUG_MODE;
  }
  
  if (key == 'r')
  {
    impersonal.canvas.clearCommands();
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
  
  if (key == 'b')
  {
    CTL_CLEAR_BACKGROUND = !CTL_CLEAR_BACKGROUND;
  }
  
  if (key == '0')
  {
    if (!CTL_AUTORUN)
    {
      impersonal.canvas.popCommand();
    }
    
  }
  

  
  if (key == ',')
  {
    testPushBuffer();
  }
  
  if (key == '.')
  {
    testPopBuffer();
  }
  
  if (key == 'z')
  {
    canvas.popBuffer();
  }
  
  if (key == 'e')
  {
    testEmail();
  }
}

void mousePressed()
{
  canvas.pushBuffer();
}

void mouseMoved()
{
  CTL_USE_MOUSE = true;
}

void mouseReleased()
{
}

void drawTools()
{
  pushMatrix();
  translate(0,height - 80 + 1);
  
  noStroke();
  fill(220);
  rect(0,0,width,80);
  
  noStroke();
  fill(0);
  
  textSize(8);
  text("brush size", 20, 40);
  
  fill(CTL_BRUSH_SHADE);
  ellipseMode(CENTER);
  ellipse(90, 40, CTL_BRUSH_SIZE, CTL_BRUSH_SIZE);
  
  popMatrix();
}