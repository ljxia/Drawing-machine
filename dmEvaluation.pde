class dmEvaluation
{
  public ArrayList rules;
  
  dmEvaluation()
  {
    rules = new ArrayList();
  }
  
  void addRule(dmEvaluationRule rule)
  {
    this.rules.add(rule);
  }
}

class dmEvaluationRule
{
  int evaluate(PApplet pa)
  {
    return 0;
  }
}