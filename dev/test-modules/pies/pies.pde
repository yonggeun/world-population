int num = 15;
float[] r = new float[num];
float[] d = new float[num];
float[] xray = new float[num];

float dTally = 0.0;
float ypos = 287;
float X = 0.0;
float Y = 0.0;

PVector et;

void setup () {
  size(1280, 720);
  //
  for (int i = 0; i < num; i++) {
    r[i] = random(0.5, 111/2);
  }
  //
  for (int j = 0; j < r.length-1; j++) {
    float r1 = r[j];
    float r2 = r[j+1];

    float _d = sqrt(pow(r1 + r2, 2) - pow(r2-r1, 2));
    d[j] = _d;
  }
  //
  for (int k = 0; k < num; k++) {
    float _x = 0;
    for (int l = 0; l < k; l++) {
      //ellipse (x-r[k], 0, r[k]*2, -r[k]*2);
      _x += d[l];
    }
    xray[k] = _x;
  }


  // 
  //for (int m = 0; m < num; m++) {
  //  dTally += d[m];
  //}
  //dTally += r[0];
  //dTally += r[r.length-1];
  dTally = xray[xray.length-1]  - xray[0]; 
  println("total size : ", dTally);

  et = new PVector ();
  int etn = round (random (0, r.length-1));
  float x = 0;
  for (int l = 0; l < etn; l++) {
    x += d[l];
  }
  et = new PVector (x, - r[etn]*2);
  println(et);


  // set coord
  X = (width - dTally) / 2;
  //X = 0;
  Y = height - 60;
  println ("dtally ", dTally);
}
void draw () {
  background (0);
  //translate(width/2, height/2);

  for (int k = 0; k < num; k++) {
    float x = 0;
    for (int l = 0; l < k; l++) {
      x += d[l];
    }
    //println("k ", k, ", r ", r[k], ", x ", x);
    //ellipseMode (CORNER);
    noStroke();
    //stroke(255);
    //strokeWeight(3);
    fill(51);
    pushMatrix();
    translate(X, Y);
    ellipseMode(CORNER);  // Set ellipseMode is CORNER
    //ellipse (x-r[k], 0, r[k]*2, -r[k]*2);

    ellipse (xray[k]-r[k], 0, r[k]*2, -r[k]*2);


    ellipse (et.x, et.y, 5, 5);

    fill(255);
    popMatrix();

    //
  }
  //line (0, ypos, width, ypos);

  //
  stroke(51);
  strokeWeight(2);
  noFill();
  float a1x = et.x + X;
  float a1y = et.y + Y - 20;
  float a2x = mouseX;
  float a2y = mouseY;
  //float dx = abs (a1x - a2x); 
  float dy = abs (a1y - a2y); 
  bezier(a1x, a1y, a1x, a1y - dy*0.3, a2x, a2y + dy*0.7, a2x, a2y);

  fill(255);
  textSize(20);
  String t = mouseX + " / " + mouseY + " / " + dTally;
  //translate(-width/2, -height/2);
  text(t, mouseX, mouseY);
}
