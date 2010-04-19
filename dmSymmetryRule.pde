class dmSymmetryRule extends dmAbstractEvaluationRule
{
  int GRID_SIZE = 9;
  int DEFAULT_MAX_SHIFT = 100;
  float [][]impression;
  float maxShift = DEFAULT_MAX_SHIFT;
  
  dmSymmetryRule()
  {
    if (GRID_SIZE % 2 == 0)
    {
      GRID_SIZE++;
    }
  }
  
  void reset()
  {
    this.maxShift = DEFAULT_MAX_SHIFT;
  }

  float evaluate(dmContext context)
  { 
    impression = getPixelDistribution(context.canvas, GRID_SIZE);
    
    PVector shift = new PVector(0,0);
    
    //clean up
    
    info("------------");
    for (int j = 0; j < GRID_SIZE ; j++)
    {
      String row = "";
      for (int i = 0; i < GRID_SIZE ; i++)
      {
        row = row + impression[i][j] + "\t";
        shift.add(impression[i][j] * (i - (GRID_SIZE - 1) / 2), impression[i][j] * (j - (GRID_SIZE - 1) / 2), 0);
      }
      info(row);
    } 
    info("------------");
    
    //normalize
    
    shift.x = shift.x / context.canvas.width;
    shift.y = shift.y / context.canvas.height;
    
    this.maxShift = max(DEFAULT_MAX_SHIFT, shift.mag());
    
    float score = constrain(map(shift.mag(),0,this.maxShift, 0,10),0,10);
    
    
    info(shift.x + ", " + shift.y + " mag: " + shift.mag());
    info("score " + score);

    return 10 - score;
  }
}