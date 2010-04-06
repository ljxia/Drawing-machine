class dmCanvas
{
  dmBrush _brush;
  ArrayList commands;
  int width = 0;
  int height = 0;
  Vec3D corner = new Vec3D();
  PImage buffer = null;

  dmCanvas(int w, int h)
  {
    this.commands = new ArrayList();
    this.width = w;
    this.height = h;
    
    this.buffer = createImage(this.width, this.height, ARGB);
    
    info("init canvas:" + this.width + ", " + this.height);
    this.corner.set(0,0,0);
  }

  public void pushBuffer()
  {
    loadPixels();
    //this.buffer.loadPixels();
    for (int i = 0; i < this.buffer.pixels.length; i++) {
      this.buffer.pixels[i] = pixels[i]; 
    }
    
    this.buffer.updatePixels();
  }
  
  public void popBuffer()
  {
    if (this.buffer != null)
    {
      image(buffer, this.corner.x, this.corner.y);
    }
  }
  
  public void dumpBuffer()
  {
    if (this.buffer != null)
    {
      this.buffer.save("buffer.png");
    }
  }

  dmBrush getBrush()
  {
    return this._brush;
  }

  public void setBrush(dmBrush b)
  {
    this._brush = b;
    this._brush.parentCanvas = this;
  }
  
  
  public void changeColor(float _gray)
  {
    //global
    CTL_BRUSH_SHADE = _gray;
    
    dmCommand cmd = new dmCommand("color");
    TColor _color = TColor.newRGBA(_gray / 255, _gray / 255,_gray / 255,1);
    cmd.params.put("color", _color);
    this.commands.add(cmd);
    debug("command in queue:" + this.commands.size());
  }
  
  public void changeColor(TColor _color)
  {
    dmCommand cmd = new dmCommand("color");
    cmd.params.put("color", _color);
    this.commands.add(cmd);
    debug("command in queue:" + this.commands.size());
  }
  
  public void changeSize(float _size)
  {
    //global
    CTL_BRUSH_SIZE = _size;
    
    dmCommand cmd = new dmCommand("size");
    cmd.params.put("size", _size);
    this.commands.add(cmd);
    debug("command in queue:" + this.commands.size());
  }
  
  public void line(Vec3D from, Vec3D to)
  {
    if (CTL_USE_TRAINED_INTERPOLATION >= random(1))
    {
      this.interpolate(from, to);
    }
    else
    {
      this.moveTo(from);
      this.moveTo(from);
      this.lineTo(to);
    }
  }
  
  private void moveTo(Vec3D pos)
  {
    this.moveTo(pos, new Vec3D(0,0,0));
  }
  
  private void moveTo(Vec3D pos, Vec3D offset)
  {
    dmCommand cmd = new dmCommand("move");
    cmd.params.put("target", pos);
    cmd.params.put("offset", offset);

    this.commands.add(cmd);
    debug("command in queue:" + this.commands.size());
  }

  private void lineTo(Vec3D pos)
  {
    //this._brush.clearInterpolation();
    dmCommand cmd = new dmCommand("line");
    cmd.params.put("target", pos);
    this.commands.add(cmd);
    debug("command in queue:" + this.commands.size());
  }
  
  public void rectangle(Vec3D corner, float _width, float _height)
  {
/*    moveTo(corner);
    moveTo(corner);
    lineTo(corner.add(0, (_height), 0));
    
    moveTo(corner);
    lineTo(corner.add((_width), 0, 0));
    
    lineTo(corner.add((_width), (_height), 0));
    
    moveTo(corner.add(0, (_height), 0));
    lineTo(corner.add((_width), (_height), 0));*/
    
    this.line(corner, corner.add(0, (_height), 0));
    this.line(corner, corner.add((_width), 0, 0));
    this.line(corner.add((_width), 0, 0), corner.add((_width), (_height), 0));
    this.line(corner.add(0, (_height), 0), corner.add((_width), (_height), 0));
  }

  public void interpolate(Vec3D from, Vec3D to)
  {
    dmCommand cmd = new dmCommand("interpolate");
    cmd.params.put("from", from);
    cmd.params.put("to", to);

    this.commands.add(cmd);
    debug("command in queue:" + this.commands.size());
  }
  
  public void trace(PointList pl)
  {
    this.trace(pl, new Vec3D(0,0,0));
  }
  
  public void trace(PointList pl, Vec3D offset)
  {
    int from = 0;
    int to = 1;
    dmCommand cmd;
    PointList segment;
    
    for (; to < pl.size(); to ++)
    {
      if (pl.get(to).z > 0) //found a pause
      {
        //this.moveTo(pl.get(from).add(offset));
        this.moveTo(pl.get(from), offset);
        
        cmd = new dmCommand("trace");
        segment = new PointList();
        for (int i = from; i < to; i++)
        {
          //segment.add(pl.get(i).add(offset));
          segment.add(pl.get(i));
        }
        cmd.params.put("trace", segment);
        cmd.params.put("offset", offset.copy());
        //cmd.params.put("delayOffset", delayOffset);
        this.commands.add(cmd);
        debug("command in queue:" + this.commands.size());
        
        from = to;
      }
    }
    
    if (from < to)
    {
      this.moveTo(pl.get(from), offset);
      
      cmd = new dmCommand("trace");
      segment = new PointList();
      for (int i = from; i < to; i++)
      {
        segment.add(pl.get(i));
      }
      cmd.params.put("trace", segment);
      cmd.params.put("offset", offset.copy());
      //cmd.params.put("delayOffset", delayOffset);
      this.commands.add(cmd);
      debug("command in queue:" + this.commands.size());
    }
    
    
  }
  
  public void follow(Path path, boolean closeShape)
  {
    dmCommand cmd = new dmCommand("follow");
    cmd.params.put("path", path);
    cmd.params.put("close", closeShape);
    this.commands.add(cmd);
    debug("command in queue:" + this.commands.size());
  }
  
  public void circle(Vec3D center, float _radius)
  {
    float steps = constrain (map(_radius,30,1000, 24,120), 24, 120);
    
    float theta = random(0, 2 * PI);
    
    float overlap = 0;
    moveTo(center.add(_radius * cos(theta), _radius * sin(theta),0));
    
    
    Path path = new Path();
    
    for (float i = 0; i <= steps + overlap; i += random(0,1))
    {
      path.addPoint(center.x + _radius * cos(theta + 2 * PI * i/ steps),  center.y + _radius * sin(theta + 2 * PI * i/ steps));
    }
    
    path.addPoint(center.x + _radius * cos(theta + 1/ steps) + random(0.5, 1),  center.y + _radius * sin(theta + 1/ steps) + random(0.5, 1));
    
    this.follow(path, true);
  }
  
  public void curve(Path path)
  {
    if (path.points != null && path.points.size() > 1)
    {
      PVector p = (PVector)path.points.get(0);
      //path.points.remove(0);
      this.moveTo(new Vec3D(p.x, p.y, 0));
      
      p = path.tail();
      
      path.addPoint(p.x + random(1,2),p.y + random(1,2));
      this.follow(path, false);
    }
    
  }
  
  public void clearCommands()
  {
    this.commands.clear();
  }


  public boolean popCommand()
  {
    if (this._brush.motionCompleted && !this.commands.isEmpty())
    {
      this.pushBuffer();
      
      dmCommand cmd = (dmCommand)this.commands.remove(0);
    
      debug("----");
    
      if (cmd.name.equals("move"))
      {
          Vec3D target = (Vec3D)cmd.params.get("target");
          Vec3D offset = (Vec3D)cmd.params.get("offset");
          //Boolean delayOffset = (Boolean)cmd.params.get("delayOffset");
        
          this._brush.resetTravelLength();
          this._brush.moveTo(target, offset);
          debug("move to " + (target.x + offset.x) + ", " + (target.y + offset.y));
      }
      else if (cmd.name.equals("line"))
      {
          Vec3D target = (Vec3D)cmd.params.get("target");
        
          this._brush.resetTravelLength();
          this._brush.lineTo(target);
          debug("line to " + target.x + ", " + target.y);
      }
      else if (cmd.name.equals("follow"))
      {
          Path path = (Path)cmd.params.get("path");
          Boolean closeShape = (Boolean)cmd.params.get("close");
          this._brush.resetTravelLength();
          this._brush.closeShape = closeShape;
          //path.display();
          this._brush.drawAlong(path);
          debug("draw along path - node count " + path.points.size());
      }
      else if (cmd.name.equals("color"))
      {
          TColor c = (TColor)cmd.params.get("color");
          this._brush.setColor(c);
          debug("change color " + c.red() + "," + c.green() + "," + c.blue());
      }
      else if (cmd.name.equals("size"))
      {
          float s = float(cmd.params.get("size").toString());
          this._brush.setSize(s, true);
          debug("change size " + s);
      }
      else if (cmd.name.equals("trace"))
      {
        PointList trace = (PointList)cmd.params.get("trace");
        Vec3D offset = (Vec3D)cmd.params.get("offset");
        this._brush.trace(trace, offset);
      }
      else if (cmd.name.equals("interpolate"))
      {
        Vec3D fromPos = (Vec3D)cmd.params.get("from");
        Vec3D toPos = (Vec3D)cmd.params.get("to");
        
        PointList pl = loadLineInterpolation(toPos.sub(fromPos));
        
        if (pl != null)
        {
          int from = 0;
          int to = 1;
          dmCommand newCmd;
          PointList segment;
          ArrayList newCommands = new ArrayList();

          // go through the point list to find segments
          for (; to < pl.size(); to ++)
          {
            if (pl.get(to).z > 0) //found a pause
            {
              // move to first point
              newCmd = new dmCommand("move");
              newCmd.params.put("target", pl.get(from));
              newCmd.params.put("offset", fromPos);
              newCommands.add(newCmd);

              // trace the segment
              newCmd = new dmCommand("trace");
              segment = new PointList();
              for (int i = from; i < to; i++)
              {
                segment.add(pl.get(i));
              }
              newCmd.params.put("trace", segment);
              newCmd.params.put("offset", fromPos.copy());
              newCommands.add(newCmd);

              from = to;
            }
          }

          // last segment
          if (from < to)
          {
            // move to first point
            newCmd = new dmCommand("move");
            newCmd.params.put("target", pl.get(from));
            newCmd.params.put("offset", fromPos);
            newCommands.add(newCmd);

            // trace the segment
            newCmd = new dmCommand("trace");
            segment = new PointList();
            for (int i = from; i < to; i++)
            {
              segment.add(pl.get(i));
            }
            newCmd.params.put("trace", segment);
            newCmd.params.put("offset", fromPos.copy());
            newCommands.add(newCmd);
          }

          //extract current commands to several trace commands
          this.commands.addAll(0, newCommands);  
        }
        
      }
      
      return true;
    }
    return false;
  }

  public void update()
  {
    //
      if (CTL_AUTORUN)
      {
        if (popCommand())
        {
          CTL_USE_MOUSE = false;
        }
      }
      
      if (CTL_USE_MOUSE)
      {
        this._brush.setPos(mouseX - int(this.corner.x), mouseY - int(this.corner.y));
      }
  }

  public void draw(int x, int y)
  {
    this.corner.set(x,y,0);
    
    this._brush.draw();
    this._brush.update();
    
    stroke(210);
    noFill();
    rect(0, 0, this.width, this.height);
  }

  public void clear()
  {
    noStroke();
    fill(255);
    rect(-1,-1,width + 1, height + 1);
  }


  private PointList loadLineInterpolation(Vec3D vector)
  {
    dmLineMemory memory = new dmLineMemory();
    PointList pl = memory.recall(vector);

    if (pl != null)
    {
      // origin vector data is dumped the memory, 
      // so that the canvas knows how to rotate the interpolation for current vector
      
      Vec3D refVec = JsonUtil.decodeVec3D(memory.getData("vector").toString());
      pl = rotatePointList(pl, refVec, vector);

      return pl;
    }
    
    return null;
  }

}
