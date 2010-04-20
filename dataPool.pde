class DataPool
{
  private float []data;
  private int index;
  private int count;
  
  DataPool(int capacity)
  {
    this.data = new float[capacity];
    this.index = 0;
    this.count = 0;
  }
  
  void log(float d)
  {
    this.data[index] = d;
    
    this.index = (this.index + 1) % this.data.length;
    
    if (this.count < this.data.length)
    {
      this.count ++;
    }
  }
  
  float average()
  {
    float ret = 0;
    for (int i = 0; i < this.count ; i++)
    {
      ret += data[i];
    }
    
    return ret / this.count;
  }
  
  boolean full()
  {
    return this.count == this.data.length;
  }
}