class Dot {
  float x;
  float y;

  float r1, g1, b1, a1;
  float r2, g2, b2, a2;
  float r3, g3, b3, a3;
  float r4, g4, b4, a4;
  // diameter for ellipse 1
  float d;
  // diameter for ellipse 2
  float d2;
  float aMin;
  float dotSizeEnd;
  float amt;
  
  Dot (float X, float Y, 
    float DotSizeBegin, float DotSizeEnd) {
    x = X;
    y = Y;
    amt = 0.0;

    r1 = red(theme.c_dotBegin);
    g1 = green(theme.c_dotBegin);
    b1 = blue(theme.c_dotBegin);
    a1 = alpha(theme.c_dotBegin);

    r2 = red(theme.c_dotEnd);
    g2 = green(theme.c_dotEnd);
    b2 = blue(theme.c_dotEnd);
    a2 = alpha(theme.c_dotEnd);

    r3 = red(theme.c_dotLine);
    g3 = green(theme.c_dotLine);
    b3 = blue(theme.c_dotLine);
    a3 = alpha(theme.c_dotLine);

    r4 = red(theme.c_dotLineEnd);
    g4 = green(theme.c_dotLineEnd);
    b4 = blue(theme.c_dotLineEnd);
    a4 = alpha(theme.c_dotLineEnd);

    d = DotSizeBegin;
    d2 = d * 1.5;
    aMin = a2;
    dotSizeEnd = DotSizeEnd;
  }
  void update () {
    // size
    if (d > dotSizeEnd ) { // 3
      d-= 0.02; // 0.75
      d2 = d*1.5;
    }

    if (amt < 1) {
      amt += map(255.0 / duration, 0.0, 255.0, 0.0, 1.0);
    }
  }
  void display () {
    // float _blue = map (a1, 255, aMin, 0, 255);
    color _c_begin2end = color (lerp (r1, r2, amt), lerp(g1, g2, amt), lerp(b1, b2, amt), lerp(a1, a2, amt));
    //color _c_d2        = color (lerp (r3, r4, amt), lerp(g3, g4, amt), lerp(b3, b4, amt), lerp(a3, a4, amt));

    noStroke();
    if (theme.style.equals("day")) {
      fill(lerpColor (theme.c_dotLine, theme.c_dotLineEnd, amt));
      ellipse  (x, y, d * 1.5, d * 1.5);
    }
    ellipseMode(CENTER);
    fill (_c_begin2end);
    ellipse (x, y, d, d);
  }
}
