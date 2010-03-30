import controlP5.*;

ControlP5 controlP5;
ControlWindow controlWindow;

/*control params*/

public float CTL_BRUSH_SIZE = 1;
public float CTL_BRUSH_SHADE = 0;
public boolean CTL_DEBUG_MODE = false;
public boolean CTL_CLEAR_BACKGROUND = false;
public boolean CTL_SHOW_TOOL = false;
public boolean CTL_SHOW_BRUSH = false;

public float CTL_USE_TRAINED_INTERPOLATION = 0.0;


public float FORCE_STRAIGHT = 1.7;
public float SPEED_STRAIGHT = 13;

public float FORCE_CURVE = 25;
public float SPEED_CURVE = 17;

void setupControls()
{
  controlP5 = new ControlP5(this);
  controlP5.setAutoInitialization(true);
  
  controlP5.setAutoDraw(true);
  
  controlWindow = controlP5.addControlWindow("controlP5window",screen.width - 250,0,250,height);
  controlWindow.setBackground(color(100));
  controlWindow.setUpdateMode(ControlWindow.NORMAL);
  controlWindow.hideCoordinates();
  
  controlP5.addSlider("CTL_BRUSH_SIZE",   1,  40, CTL_BRUSH_SIZE,   20, 20, 100,  10).setWindow(controlWindow);
  controlP5.addSlider("CTL_BRUSH_SHADE",  0,  255,CTL_BRUSH_SHADE,  20, 40, 100,  10).setWindow(controlWindow);
  controlP5.addSlider("CTL_USE_TRAINED_INTERPOLATION",  0,  1,CTL_USE_TRAINED_INTERPOLATION,  20, 60, 100,  10).setWindow(controlWindow);
  
  controlP5.addToggle("CTL_DEBUG_MODE",       CTL_DEBUG_MODE,  20,   80, 10, 10).setWindow(controlWindow);
  controlP5.addToggle("CTL_CLEAR_BACKGROUND", CTL_CLEAR_BACKGROUND,  100,  80, 10, 10).setWindow(controlWindow);
  
  controlP5.addToggle("CTL_SHOW_BRUSH",       CTL_SHOW_BRUSH,  20,   110, 10, 10).setWindow(controlWindow);
  
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
  }
  catch(java.lang.NullPointerException e){}
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
    saveFrame("images/sketch-#####.png");
  }
  
  if (key == 't')
  {
    //CTL_SHOW_TOOL = !CTL_SHOW_TOOL;
    if (!trainLine.active)
    {
      trainLine.activate();
    }
    else
    {
      trainLine.active = false;
      fill(255);
      rect(-1, -1 ,width + 1,height + 1);
    }
    
  }
  
  if (key == 'd')
  {
    CTL_DEBUG_MODE = !CTL_DEBUG_MODE;
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
  
  if (key == 'b')
  {
    CTL_CLEAR_BACKGROUND = !CTL_CLEAR_BACKGROUND;
  }
  
  if (key == '1')
  {
    testHttpRequest();
  }
  
  if (key == '2')
  {
    testJson();
  }
  
  if (key == '3')
  {
    testLoadInterpolation();
  }
}

void mouseReleased()
{
  //test();
  //brush.setSize(random(3,1));
  
  //brush.shuffleColor();
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
  fill(CTL_BRUSH_SHADE);
  ellipseMode(CENTER);
  ellipse(90, 18, CTL_BRUSH_SIZE, CTL_BRUSH_SIZE);
}