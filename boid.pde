// Seek_Arrive
// Daniel Shiffman <http://www.shiffman.net>

// The "Boid" class

// Created 2 May 2005

class Boid {

  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  
  float travelLength = 0;
  
  int pathProgress = 0;

  Boid(PVector l, float ms, float mf) {
    acc = new PVector(0,0);
    vel = new PVector(0,0);
    loc = l.get();
    r = 3.0;
    maxspeed = ms;
    maxforce = mf;
  }

  void run() {
    update();
    //borders();
    //render();
  }

  // Method to update location
  void update() {
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(maxspeed);

    loc.add(vel);
    
    travelLength += vel.mag();
    // Reset accelertion to 0 each cycle
    acc.mult(0);
  }

  // This function implements Craig Reynolds' path following algorithm
  // http://www.red3d.com/cwr/steer/PathFollow.html
  boolean follow(Path p, boolean close) {

    // Predict location 25 (arbitrary choice) frames ahead
    PVector predict = vel.get();
    predict.normalize();
    predict.mult(5);
    PVector predictLoc = PVector.add(loc, predict);

    // Draw the predicted location
    if (debug) {
      fill(0);
      stroke(0,0,255);
      line(loc.x,loc.y,predictLoc.x, predictLoc.y);
      //ellipse(predictLoc.x, predictLoc.y,4,4);
    }

    // Now we must find the normal to the path from the predicted location
    // We look at the normal for each line segment and pick out the closest one
    PVector target = null;
    PVector dir = null;
    float record = 1000000;  // Start with a very high record distance that can easily be beaten

    boolean isTail = false;
    PVector segment = null;
    // Loop through all points of the path
    for (int i = pathProgress; i < p.points.size()-1 && i < (pathProgress + 2); i++) {

      // Look at a line segment
      PVector a = (PVector) p.points.get(i);
      PVector b = (PVector) p.points.get(i+1);
      
      // the length of current segment we're following, if too short the max force should be decreased
      float segmentLength = PVector.dist(a, b);
      
      
     if (segmentLength < 80 && segmentLength > 0)
      {
        this.maxforce = map(segmentLength,0,80, 0.6 * FORCE_CURVE, FORCE_CURVE);
        this.maxspeed = map(segmentLength,0,80, 0.7 * SPEED_CURVE, SPEED_CURVE);
      }
      else
      {
        this.maxforce = FORCE_CURVE;
        this.maxspeed = SPEED_CURVE;
      }

      // Get the normal point to that line
      PVector normal = getNormalPoint(predictLoc,a,b);

      // Check if normal is on line segment
      float da = PVector.dist(normal,a);
      float db = PVector.dist(normal,b);
      PVector line = PVector.sub(b,a);
      // If it's not within the line segment, consider the normal to just be the end of the line segment (point b)
      if (da + db > line.mag()+1) {
        normal = b.get();
      }

      // How far away are we from the path?
      float d = PVector.dist(predictLoc,normal);
      // Did we beat the record and find the closest line segment?
      if (d < record/* && abs(PVector.angleBetween(line, this.vel)) < PI*/) {
        record = d;
        pathProgress = i;
        println("segment " + pathProgress);
        if (i == p.points.size() - 2)
        {
          isTail = true;
        }
        else
        {
          isTail = false;
        }
        //println("check tail!");
        // If so the target we want to steer towards is the normal
        target = normal;
        segment = line;
        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        dir = line;
        dir.normalize();
        // This is an oversimplification
        // Should be based on distance to path & velocity
        dir.mult(d * 2.5);
      }
    }

    // Draw the debugging stuff
    if (debug && target != null) {
      // Draw normal location
      noFill();
      stroke(255,0,0);
      line(predictLoc.x,predictLoc.y,target.x,target.y);
      stroke(0);
      // Draw actual target (red if steering towards it)
      //line(predictLoc.x,predictLoc.y,target.x,target.y);
      if (record > p.radius) fill(255,0,0);
      noStroke();
      //ellipse(target.x+dir.x, target.y+dir.y, 8, 8);
    }

    // Only if the distance is greater than the path's radius do we bother to steer
    if (record > p.radius && target != null) {
      target.add(dir);
      if (isTail)
      {
        //println("is tail!");
        return true;
/*        if (close)
        {
          //arrive(p.tail());
          return true;
        }
        else
        {
          if (arrive(p.tail(), 0.15))
          {
            this.vel.mult(0);
            return true;
          }
          else if (PVector.dist(this.loc, p.tail()) < 5)
          {
            return true;
          }          
          else
          {
            this.vel.mult(0.9);
          }
        }*/
      }
      else
      {
        seek(target);	
      }
      		
    }
    return false;
  }


  // A function to get the normal point from a point (p) to a line segment (a-b)
  // This function could be optimized to make fewer new Vector objects
  PVector getNormalPoint(PVector p, PVector a, PVector b) {
    // Vector from a to p
    PVector ap = PVector.sub(p,a);
    // Vector from a to b
    PVector ab = PVector.sub(b,a);
    ab.normalize(); // Normalize the line
    // Project vector "diff" onto line by using the dot product
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a,ab);
    return normalPoint;
  }

  void seek(PVector target) {
    acc.add(steer(target,false));
  }

  boolean arrive(PVector target, float threshold)
  {
    PVector steer = steer(target,true);
    acc.add(steer);

    if (steer.mag() < threshold && vel.mag() < 1)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
  boolean arrive(PVector target) {
    return arrive(target,0.0003);
  }

  // A method that calculates a steering vector towards a target
  // Takes a second argument, if true, it slows down as it approaches the target
  PVector steer(PVector target, boolean slowdown) {
    PVector steer;  // The steering vector
    PVector desired = PVector.sub(target,loc);  // A vector pointing from the location to the target
    float d = desired.mag(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) {
      // Normalize desired
      desired.normalize();

      float theta = noise(frameCount) * 2 * PI;
      float scal = 0.03;
      desired.add(new PVector(scal * cos(theta), scal * sin(theta)));
      //desired.normalize();

      // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if ((slowdown) && (d < 50.0f)) desired.mult(maxspeed*(d/1000.0f)); // This damping is somewhat arbitrary
      else desired.mult(maxspeed);
      // Steering = Desired minus Velocity
      steer = PVector.sub(desired,vel);
      steer.limit(maxforce);  // Limit to maximum steering force
      } else {
        steer = new PVector(0,0);
      }
      return steer;
    }

    void render() {
      // Draw a triangle rotated in the direction of velocity
      float theta = vel.heading2D() + radians(90);
      fill(175);
      stroke(0);
      pushMatrix();
      translate(loc.x,loc.y);
      rotate(theta);
      beginShape(TRIANGLES);
      vertex(0, -r*2);
      vertex(-r, r*2);
      vertex(r, r*2);
      endShape();
      popMatrix();
    }

    // Wraparound
    void borders() {
      if (loc.x < -r) loc.x = width+r;
      if (loc.y < -r) loc.y = height+r;
      if (loc.x > width+r) loc.x = -r;
      if (loc.y > height+r) loc.y = -r;
    }

  }