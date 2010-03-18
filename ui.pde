import controlP5.*;

ControlP5 controlP5;
ControlWindow controlWindow;

void setupControls()
{
  controlP5 = new ControlP5(this);
  controlP5.setAutoInitialization(true);
  
  controlP5.setAutoDraw(true);
  
  controlWindow = controlP5.addControlWindow("controlP5window",100,100,250,500);
  controlWindow.setBackground(color(100));
  controlWindow.setUpdateMode(ControlWindow.NORMAL);
  controlWindow.hideCoordinates();
  
  controlP5.addSlider("CTL_BRUSH_SIZE",   1,  50, CTL_BRUSH_SIZE,   20, 20, 100,  10).setWindow(controlWindow);
  controlP5.addSlider("CTL_BRUSH_SHADE",  0,  255,CTL_BRUSH_SHADE,  20, 40, 100,  10).setWindow(controlWindow);
  
  controlP5.addToggle("CTL_DEBUG_MODE",       CTL_DEBUG_MODE,  20,   60, 10, 10).setWindow(controlWindow);
  controlP5.addToggle("CTL_CLEAR_BACKGROUND", CTL_CLEAR_BACKGROUND,  100,  60, 10, 10).setWindow(controlWindow);
}

void updateControls()
{
  controlP5.controller("CTL_BRUSH_SIZE").setValue(CTL_BRUSH_SIZE);
  controlP5.controller("CTL_BRUSH_SHADE").setValue(CTL_BRUSH_SHADE);
  
  ((Toggle)controlP5.controller("CTL_DEBUG_MODE")).setState(CTL_DEBUG_MODE);
  ((Toggle)controlP5.controller("CTL_CLEAR_BACKGROUND")).setState(CTL_CLEAR_BACKGROUND);
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
    if (CTL_BRUSH_SIZE < 15)
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