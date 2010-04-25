class Field
{
  public Rect coverage;
  public float gridSize;
  public Vec3D [][]vectors;

  public int column;
  public int row;

  Field(Rect coverage, float gridSize)
  {
    this.coverage = coverage;
    this.gridSize = gridSize;

    debug("field region " + this.coverage.width + " x " + this.coverage.height);

    this.column = int(this.coverage.width / this.gridSize);
    this.row = int(this.coverage.height / this.gridSize);

    vectors = new Vec3D[column][row];

    debug("init vector field: " + column + " x " + row);

    for (int i = 0; i < this.column ; i++)
    {
      for (int j = 0; j < this.row ; j++)
      {
        vectors[i][j] = new Vec3D();
      }
    }
  }

  Vec3D getSum()
  {
    Vec3D sumVec = new Vec3D();
    for (int i = 0; i < this.column ; i++)
    {
      for (int j = 0; j < this.row ; j++)
      {
        sumVec.addSelf(vectors[i][j]);
      }
    }

    sumVec.scaleSelf( (this.coverage.width + this.coverage.height) / (4 * this.row * this.column));

    return sumVec;
  }

  public void draw()
  {
    pushMatrix();
    translate(this.coverage.x, this.coverage.y);

    //stroke(255,0,0);
    noStroke();
    fill(255);
    rect(0,0, this.coverage.width - 1, this.coverage.height - 1);


    for (int i = 0; i < this.column ; i++)
    {
      for (int j = 0; j < this.row ; j++)
      {
        Vec3D vec = vectors[i][j];

        float x = (i + 0.5) * gridSize;
        float y = (j + 0.5) * gridSize;

        noStroke();
        fill(255,0,0);

        float dotSize = constrain(map(vec.magnitude(), 0, 10, 2, 8), 2, 8);
        ellipse(x, y, dotSize,dotSize);

        stroke(255,0,0);
        line(x, y,x + vec.x,y + vec.y);
      }
    }


    Vec3D sum = getSum();

    noStroke();
    fill(0,30,200);
    ellipse(this.coverage.width / 2, this.coverage.height / 2, 10 , 10);

    noFill();
    stroke(0,30,200);
    line(this.coverage.width / 2, this.coverage.height / 2,this.coverage.width / 2 + sum.x, this.coverage.height / 2 + sum.y);


    popMatrix();
  }

  public void log(int x, int y, int px, int py, boolean newStroke, float impactRadius)
  {
    x = int(constrain(x, 0, this.coverage.width - 1));
    y = int(constrain(y, 0, this.coverage.height - 1));
    px = int(constrain(px, 0, this.coverage.width - 1));
    py = int(constrain(py, 0, this.coverage.height - 1));

    Vec3D currentStroke = new Vec3D(x - px, y-py, 0);    
    Vec3D impact = new Vec3D(x,y,0);//.scaleSelf(1.0 / this.gridSize);
    
    impactRadius = min(impactRadius, gridSize);
    
    Rect impactRegion = new Rect(impact.x - impactRadius, impact.y - impactRadius, impactRadius * 2, impactRadius * 2);

    for (float i = floor(impactRegion.x); i < ceil(impactRegion.x + impactRegion.width) ; i++)
    {
      for (float j = floor(impactRegion.y); j < ceil(impactRegion.y + impactRegion.height) ; j++)
      {
        int colNum = floor( i / this.gridSize );
        int rowNum = floor( j / this.gridSize );

        if (colNum >= 0 && colNum < this.column && rowNum >= 0 && rowNum < this.row)
        {
          Vec3D affectedVector = vectors[colNum][rowNum];
          Vec3D affectedPosition = new Vec3D(colNum, rowNum, 0);
          affectedVector.addSelf(currentStroke.scale(100 * (this.column + this.row) / max(sq(3 * affectedPosition.distanceTo(impact)), 0.1)));
        }
      }      
    }    
  }

}
