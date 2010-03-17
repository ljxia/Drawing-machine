class dmCanvas
{
  dmBrush _brush;
  ArrayList commands;

  dmCanvas(int w, int h)
  {
    this.commands = new ArrayList();
  }

  dmBrush getBrush()
  {
    return this._brush;
  }

  void setBrush(dmBrush b)
  {
    this._brush = b;
  }
  
  
  void changeColor(float _gray)
  {
    //global
    CTL_BRUSH_SHADE = _gray;
    
    dmCommand cmd = new dmCommand("color");
    TColor _color = TColor.newRGBA(_gray / 255, _gray / 255,_gray / 255,1);
    cmd.params.put("color", _color);
    this.commands.add(cmd);
    println("command in queue:" + this.commands.size());
  }
  
  void changeColor(TColor _color)
  {
    dmCommand cmd = new dmCommand("color");
    cmd.params.put("color", _color);
    this.commands.add(cmd);
    println("command in queue:" + this.commands.size());
  }
  
  void changeSize(float _size)
  {
    //global
    CTL_BRUSH_SIZE = _size;
    
    dmCommand cmd = new dmCommand("size");
    cmd.params.put("size", _size);
    this.commands.add(cmd);
    println("command in queue:" + this.commands.size());
  }
  
  void moveTo(Vec3D pos)
  {
    dmCommand cmd = new dmCommand("move");
    cmd.params.put("target", pos);
    this.commands.add(cmd);
    println("command in queue:" + this.commands.size());
  }

  void lineTo(Vec3D pos)
  {
    dmCommand cmd = new dmCommand("line");
    cmd.params.put("target", pos);
    this.commands.add(cmd);
    println("command in queue:" + this.commands.size());
  }
  
  void rectangle(Vec3D corner, float _width, float _height)
  {
    moveTo(corner);
    moveTo(corner);
    lineTo(corner.add(0, (_height), 0));
    moveTo(corner);
    lineTo(corner.add((_width), 0, 0));
    lineTo(corner.add((_width), (_height), 0));
    moveTo(corner.add(0, (_height), 0));
    lineTo(corner.add((_width), (_height), 0));
  }
  
  
  void trace(PointList pl)
  {
    int from = 0;
    int to = 1;
    dmCommand cmd;
    PointList segment;
    
    for (; to < pl.size(); to ++)
    {
      if (pl.get(to).z > 0) //found a pause
      {
        this.moveTo(pl.get(from));
        
        cmd = new dmCommand("trace");
        segment = new PointList();
        for (int i = from; i < to; i++)
        {
          segment.add(pl.get(i));
        }
        cmd.params.put("trace", segment);
        this.commands.add(cmd);
        println("command in queue:" + this.commands.size());
        
        from = to;
      }
    }
    
    if (from < to)
    {
      this.moveTo(pl.get(from));
      
      cmd = new dmCommand("trace");
      segment = new PointList();
      for (int i = from; i < to; i++)
      {
        segment.add(pl.get(i));
      }
      cmd.params.put("trace", segment);
      this.commands.add(cmd);
      println("command in queue:" + this.commands.size());
    }
    
    
  }
  
  void follow(Path path, boolean closeShape)
  {
    dmCommand cmd = new dmCommand("follow");
    cmd.params.put("path", path);
    cmd.params.put("close", closeShape);
    this.commands.add(cmd);
    println("command in queue:" + this.commands.size());
  }
  
  void circle(Vec3D center, float _radius)
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
  
  void curve(Path path)
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
  
  void clearCommands()
  {
    this.commands.clear();
  }

  void update()
  {
    //
    if (this._brush.motionCompleted && !this.commands.isEmpty())
    {
      dmCommand cmd = (dmCommand)this.commands.remove(0);
      
      
      println("----");
      print(millis() + ": ");
      if (cmd.name.equals("move"))
      {
          Vec3D target = (Vec3D)cmd.params.get("target");
          this._brush.resetTravelLength();
          this._brush.moveTo(target);
          println("move to " + target.x + ", " + target.y);
      }
      else if (cmd.name.equals("line"))
      {
          Vec3D target = (Vec3D)cmd.params.get("target");
          this._brush.resetTravelLength();
          this._brush.lineTo(target);
          println("line to " + target.x + ", " + target.y);
      }
      else if (cmd.name.equals("follow"))
      {
          Path path = (Path)cmd.params.get("path");
          Boolean closeShape = (Boolean)cmd.params.get("close");
          this._brush.resetTravelLength();
          this._brush.closeShape = closeShape;
          //path.display();
          this._brush.drawAlong(path);
          println("draw along path - node count " + path.points.size());
      }
      else if (cmd.name.equals("color"))
      {
          TColor c = (TColor)cmd.params.get("color");
          this._brush.setColor(c);
          println("change color " + c.red() + "," + c.green() + "," + c.blue());
      }
      else if (cmd.name.equals("size"))
      {
          float s = float(cmd.params.get("size").toString());
          this._brush.setSize(s, true);
          println("change size " + s);
      }
      else if (cmd.name.equals("trace"))
      {
        PointList trace = (PointList)cmd.params.get("trace");
        this._brush.trace(trace);
      }
    }
    
    
    
  }

  void draw(int x, int y)
  {
    this._brush.draw();
    this._brush.update();
  }

  void clear()
  {
    noStroke();
    fill(255);
    rect(-1,-1,width + 1, height + 1);
  }
}
