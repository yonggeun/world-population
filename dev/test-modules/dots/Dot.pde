class Dot {
  float x;
  float y;
  float a;
  float d;
  float a
  // constructor
  Dot (float X, float Y, float D, float A) {
    x = X;
    y = Y;
    a = A;
    d = D;
  }
  void update () {
    //x --;
    //y--;
    if (a > 96) {
      a-= 2;
    }
    if (d > 3) {
      d-= 0.2;
    }
  }
  void display () {
    noStroke();
    fill(255, a);
    rectMode(CENTER);
    rect (x, y, d, d);
  }
}
