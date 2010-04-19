class dmAsymmetryRule extends dmAbstractEvaluationRule
{
  dmAsymmetryRule()
  {

  }

  float evaluate(dmContext context)
  {
    PImage img = null;
    img.copy(context.snapshot,
                      0,
                      0,
                      context.snapshot.width, 
                      context.snapshot.height,
                      0,
                      0,
                      context.snapshot.width, 
                      context.snapshot.height);
                      
                      
    
                      
                      
    
    return 0;
  }
}