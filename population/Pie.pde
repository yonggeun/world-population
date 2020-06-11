class Pie {
  String iso;
  // for rendering 
  float x;
  float tx;
  float y;
  float ty;

  float r;
  float tr;
  float v; // speed 

  color c;
  float a;
  float ta;

  color lineColor;
  //
  float ta2x;  // target anchor X coord
  float ta2y;  // target anchor Y coord
  float a2x;   // anchor X coord
  float a2y;  // anchor Y coord
  boolean visible;
  //
  float value;
  int rank;
  Paper paper;

  Pie (Paper PAPER, String Name, color Color) {
    paper = PAPER;
    iso = trim(Name);

    v = 0.1;

    x = 0;
    y = 0;
    r = 0;
    tx = 0;
    ty = 0;
    tr = 0;
    c = Color;
    a = 0;
    ta = alpha (c);

    ta2x = 0;
    ta2y = 0;

    a2x = 0;
    a2y = 0;
    visible = false;
  }

  void config (float X, float Y, float R, boolean Visibility) {

    y = Y;
    tx = X;  
    ty = Y;
    tr = R;

    visible = Visibility;

    if (visible) {
      ta = alpha(c);

      RPoint cent = new RPoint (0, 0);
      RShape shape = paper.map.children[0];

      for (int i = 0; i < paper.map.countChildren(); i++) {
        if (paper.map.children[i].name.equals(iso)) {
          cent = paper.map.children[i].getCentroid ();
          shape = paper.map.children[i];
        }
      }
      // cuttingline is a vertical extend from the xcoord of the centroid of the given territory shape. 
      RShape cuttingLine = RG.getLine(cent.x, cent.y, cent.x, cent.y + 100);
      RG.shape(cuttingLine); // thus just calculate but no draw() method to be called. 
      RPoint[] ps = shape.getIntersections(cuttingLine);

      // curve end point linked to the territory on the map
      ta2x = ps[0].x;
      ta2y = ps[0].y;
    } else {
      ta = 0;

      ta2x = X;
      ta2y = Y;
    }
  }

  void update () {
    x = x + (tx - x) * v;
    y = y + (ty - y) * v;
    r = r + (tr - r) * v;
    a = a + (ta - a) * v;
    a2x = a2x + (ta2x - a2x) * v*4;
    a2y = a2y + (ta2y - a2y) * v*4;
  }

  void display () {  
    noStroke ();
    fill (red(c), green(c), blue(c), a);
    ellipseMode(CORNER);
    ellipse (x - r, y, r*2, -r*2);
    
    // Draw BEzier Curve 

    if (visible) {
      //RPoint cent = new RPoint (0, 0);
      RShape _shape = paper.map.children[0];

      for (int i = 0; i < paper.map.countChildren(); i++) {
        if (paper.map.children[i].name.equals(iso)) {
          //cent = map.children[i].getCentroid ();
          _shape = paper.map.children[i];
        }
      }
      
      // line color with other try-outs. 
      // lineColor = color (255, 255, map (rank, 0, paper.oven.plates, 0, 255), map (rank, 0, paper.paper.oven.plates, 128, 64));
      // lineColor = color (255, 255, map (rank, 0, paper.oven.plates, 192, 255), map (rank, 0, paper.oven.plates, 90, 60));
      lineColor = color (red(theme.c_pieCurve), 
        green(theme.c_pieCurve), 
        map (rank, 0, paper.oven.plates, blue (theme.c_pieCurve) * 0.75, blue (theme.c_pieCurve)), 
        map (rank, 0, paper.oven.plates, alpha (theme.c_pieCurve), alpha (theme.c_pieCurve) * 0.6)
        );
        
      // Draw the territory 
      noStroke();
      //fill(map (rank, 0, paper.oven.plates, s.vgrid * 0.05, s.vgrid * 0.025));
      fill (lineColor);
      strokeWeight(map (rank, 0, paper.oven.plates, s.vgrid * 0.05, s.vgrid * 0.025));
      noFill();

      // Draw bezier
      stroke(lineColor);
      strokeWeight (map (rank, 0, paper.oven.plates, 1, 0.5));
      noFill();

      // curve point from the pie
      float a1x = x;
      float a1y = y - (2 * r) - s.vgrid / 4.5;

      //float maxD = paper.oven.getRadius (paper.oven.thisYear.getRow(0).getFloat("value")) / oven.pieScale;
      float maxD = s.vgrid / 2.5;
      float maxX = paper.oven.mold.getRow(paper.oven.plates-1).getFloat("cx");
      float A = map (abs(a2x), 0, maxX, s.vgrid * 0.3, s.vgrid * 1.0);

      bezier(a1x, a1y, 
        a1x, y - maxD * 1.5 - A, 
        a2x, A + s.vgrid / 2, 
        a2x, a2y);
    }
  }
  void renderLabels () {
    if (visible) {
      // rank
      s.write (x, y - (2 * r) - 2, CENTER, BOTTOM, str(paper.oven.thisYear.findRowIndex(iso, "iso")+1), 
        theme.RS, theme.fontSize.get("pieRank"), theme.fontSize.get("pieRank"), lineColor); // or theme.c_pieRank

      // population
      textFont(theme.RS);
      float _textSize = 1;
      textSize (_textSize);
      String str = nfc(floor(
        (paper.oven.thisYear.findRow (iso, "iso").getFloat("value") + 
        paper.oven.mold.findRow (iso, "iso").getFloat("velocity") * progress) / paper.renderScale
        ));

      float _w = textWidth(str);
      while (_w < r * 1.25) {
        _textSize += 0.1;
        textSize(_textSize);
        _w = textWidth(str);
      }
      if (theme.style.equals("night")) {
        s.write (x, y - r * 1.3, CENTER, CENTER, str, theme.RS, _textSize, _textSize / 2, theme.c_pieLabel);
      } else { // day theme
        s.write (x, y - r * 1.3, CENTER, CENTER, str, theme.RS, _textSize, _textSize / 2, theme.c_pieLabelPop);
      }

      // "million"
      textFont(theme.RS_T);
      float _textSize2 = 1;
      textSize (_textSize2);
      String str2 = "million";
      float _w2 = textWidth(str2);
      while ( _w2 < _w) {
        _textSize2 += 0.1;
        textSize(_textSize2);
        _w2 = textWidth(str2);
      }
      if (theme.style.equals("night")) {
        s.write (x, y - r*0.9, CENTER, TOP, str2, theme.RS_T, _textSize2, _textSize2 / 2, theme.c_pieLabel);
      } else {
        s.write (x, y - r*0.9, CENTER, TOP, str2, theme.RS_T, _textSize2, _textSize2 / 2, theme.c_pieLabelPop);
      }

      // Country name
      //String str3 = join(split(oven.thisYear.findRow (iso, "iso").getString("name"), " "), "\n");
      String str3 = s.getDoublelineString(oven.thisYear.findRow (iso, "iso").getString("name"));

      s.write (x, 
        y + s.vgrid / 20 + ((oven.mold.findRowIndex (iso, "iso") % 2 * theme.fontSize.get("pieISO"))) * 3.0, 
        CENTER, TOP, str3, theme.RS, theme.fontSize.get("pieISO"), theme.fontSize.get("pieISO")*1.2, theme.c_pieLabel);
    }
  }
  void setRank (int R) {
    rank = R;
  }
  void setX (float posX) {
    tx = posX;
  }
}
