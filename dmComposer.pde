class dmComposer extends dmAbstractComposer
{
  MovieMaker recorder;
  String videoFilename;
  
  dmComposer(PApplet applet, dmCanvas canvas)
  {
    super(applet, canvas);
    recorder = new MovieMaker(applet, int(CTL_VIDEO_WIDTH), floor(canvas.height * CTL_VIDEO_WIDTH / canvas.width) , newVideoFilename(), 30, MovieMaker.ANIMATION, MovieMaker.BEST);
  }
  
  private String newVideoFilename()
  {
    this.videoFilename = getNewVideoFilename();
    return this.videoFilename;
  }
  
  protected boolean update()
  {
    if ((!isPaused() || CTL_RECORD) && frameCount % 10 == 0)
    {
      PImage bufferImage = createImage(this.context.canvas.width, this.context.canvas.height, ARGB);
      this.context.canvas.saveImage(bufferImage);
      PImage img = createImage(int(CTL_VIDEO_WIDTH), floor(context.canvas.height * CTL_VIDEO_WIDTH / context.canvas.width), ARGB);
      img.copy(bufferImage,
                        0,
                        0,
                        bufferImage.width, 
                        bufferImage.height,
                        0,
                        0,
                        img.width, 
                        img.height);
      img.loadPixels();
      recorder.addFrame(img.pixels, int(CTL_VIDEO_WIDTH), floor(context.canvas.height * CTL_VIDEO_WIDTH / context.canvas.width));
    }
    
    return super.update();
  }
  
  protected void save()
  {
    recorder.finish();
    super.save();
    //sendMail(savePath(this.videoFilename));
    recorder = new MovieMaker(applet, int(CTL_VIDEO_WIDTH), floor(canvas.height * CTL_VIDEO_WIDTH / canvas.width) , newVideoFilename(), 30, MovieMaker.ANIMATION, MovieMaker.BEST);
  }
  
  protected void finish()
  {
    recorder.dispose();
  }
}