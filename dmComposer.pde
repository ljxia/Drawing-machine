class dmComposer extends dmAbstractComposer
{
  MovieMaker recorder;
  String videoFilename;
  
  dmComposer(PApplet applet, dmCanvas canvas)
  {
    super(applet, canvas);
    recorder = new MovieMaker(applet, 640, floor(canvas.height * 640.0 / canvas.width) , newVideoFilename(), 30, MovieMaker.ANIMATION, MovieMaker.BEST);
  }
  
  private String newVideoFilename()
  {
    this.videoFilename = "videos/drawing" + millis() + ".mov";
    return this.videoFilename;
  }
  
  protected boolean update()
  {
    if (!isPaused() && frameCount % 10 == 0)
    {
      this.context.canvas.pushBuffer();
      PImage img = createImage(640, floor(context.canvas.height * 640.0 / context.canvas.width), ARGB);
      img.copy(this.context.canvas.buffer,
                        0,
                        0,
                        this.context.canvas.buffer.width, 
                        this.context.canvas.buffer.height,
                        0,
                        0,
                        img.width, 
                        img.height);
      img.loadPixels();
      recorder.addFrame(img.pixels, 640, floor(context.canvas.height * 640.0 / context.canvas.width));
    }
    
    return super.update();
  }
  
  protected void save()
  {
    recorder.finish();
    super.save();
    //sendMail(savePath(this.videoFilename));
    recorder = new MovieMaker(applet, 640, floor(canvas.height * 640.0 / canvas.width) , newVideoFilename(), 30, MovieMaker.ANIMATION, MovieMaker.BEST);
  }
  
  protected void finish()
  {
    recorder.dispose();
  }
}