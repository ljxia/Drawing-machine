class dmEvaluation
{
  public Hashtable rules;
  public Hashtable weights;
  
  dmEvaluation()
  {
    rules = new Hashtable();
    weights = new Hashtable();
  }
  
  void addRule(String name, dmAbstractEvaluationRule rule, float weight)
  {
    this.rules.put(name, rule);
    this.weights.put(name, weight);
  }
  
  float evaluate(dmDrawingContext context)
  {
    float result = 0;
    for (Enumeration e = this.rules.keys() ; e.hasMoreElements() ;) 
    {
        Object ruleName = e.nextElement();
        dmAbstractEvaluationRule rule = (dmAbstractEvaluationRule)this.rules.get(ruleName);
        
        float weight = 1;
        if (this.weights.containsKey(ruleName))
        {
          weight = float(this.weights.get(ruleName).toString());
        }
        
        result += weight * rule.evaluate(context);
    }
    return result;
  }
}