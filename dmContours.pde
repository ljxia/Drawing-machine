class dmContours
{
  public Blob []blobs;
  public PImage snapshot;
  public float area;
  
  dmContours(Blob[] blbs, PImage img, float a)
  {
    this.blobs = blbs;
    this.snapshot = img;
    this.area = a;
  }
}