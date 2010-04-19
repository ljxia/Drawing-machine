class dmAbstractEvaluationRule //chaos rule
{
  dmAbstractEvaluationRule()
  {
  }
  
  void reset()
  {
    
  }
  
  float evaluate(dmContext context)
  {
    return floor(random(0, 11));
  }
}