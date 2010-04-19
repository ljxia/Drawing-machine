class dmSymmetryRule extends dmAbstractEvaluationRule
{
  int GRID_SIZE = 9;
  float [][]impression;
  
  dmSymmetryRule()
  {
    if (GRID_SIZE % 2 == 0)
    {
      GRID_SIZE++;
    }
    
    impression = new float[GRID_SIZE][GRID_SIZE];
    for (int i = 0; i < GRID_SIZE ; i++)
    {
      for (int j = 0; j < GRID_SIZE ; j++)
      {
        impression[i][j] = 0f;
      }
    }
  }

  float evaluate(dmDrawingContext context)
  { 
    PImage img = createImage(context.canvas.width, context.canvas.height, ARGB);
    
    context.canvas.saveImage(img);
                      
    img.loadPixels();                  
                      
    for (int i = 0; i < img.width ; i++)
    {
      for (int j = 0; j < img.height ; j++)
      {
        TColor c = TColor.newARGB(img.pixels[getPixelPosition(i,j,img.width,img.height)]);
        
        impression[int(float(i * GRID_SIZE) / img.width)][int(float(j * GRID_SIZE) / img.height)] += (1 - c.brightness());
      }
    }
    
    PVector shift = new PVector(0,0);
    
    //clean up
    
    println("------------");
    for (int j = 0; j < GRID_SIZE ; j++)
    {
      for (int i = 0; i < GRID_SIZE ; i++)
      {
        print(impression[i][j] + "\t");
        shift.add(impression[i][j] * (i - (GRID_SIZE - 1) / 2), impression[i][j] * (j - (GRID_SIZE - 1) / 2), 0);
      }
      println();
    } 
    println("------------");
    
    //normalize
    
    shift.x = shift.x / img.width;
    shift.y = shift.y / img.height;
    
    println(shift.x + ", " + shift.y + " mag: " + shift.mag());
    
    float score = constrain(map(shift.mag(),0,100, 0,10),0,10);
    println("score " + score);
    return 10 - score;
  }
}