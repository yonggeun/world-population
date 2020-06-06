class Scroll {
  float x;
  float y;
  float w;
  float h;
  float yoff;
  float tyoff;
  float vdistance;
  float velocity;

  float r;
  float g;
  float b;

  float[] alpha;

  int annumBeginsIn;
  int annumEndsIn;
  int annumNow;
  int annumNext;

  int[] annums;

  Table data;

  String textNow;
  String textNext;

  boolean onChange;

  Scroll (float X, float Y, float W, float H) {
    x = X;
    y = Y;
    w = W;
    h = H;
    vdistance = h * 0.25;
    yoff = 0.0;
    tyoff = 0.0;
    onChange = false;
    velocity = 0.2;
  }
  void setColor (color C) {
    r = red (C);
    g = green (C);
    b = blue (C);
  }
  void setAnnumRange(int in, int out) {
    annumBeginsIn = in;
    annumEndsIn   = out;
  }
  void loadData (String url) {
    Table _t;
    Table R;
    _t = loadTable (url, "header");
    R = new Table();

    // copy the columns
    for (int i = 0; i < _t.getColumnCount(); i++) {
      R.addColumn(_t.getColumnTitle(i).substring(2), int(_t.getColumnTitle(i).substring(0, 1)));
    }

    // copy the rows;
    for (TableRow _r : _t.rows()) {
      int year = 0;
      String text = ""; 
      //println("R.findRow(_r.getInt (0) : ", R.findRow(str(_r.getInt (0)), 0));
      if (R.findRow(str(_r.getInt (0)), 0) == null) {
        for (TableRow __r : _t.findRows(str(_r.getInt(0)), 0)) {
          year = __r.getInt(0);
          text += __r.getString(1) + " ";
        }
        //if (text.charAt(0) == '\"' && text.charAt(text.length()-1) == '\"') {
        String _text = trim(text);
        String text2 = _text;
        //println (_text.charAt(_text.length()-1));
        if (_text.charAt(0) == '\"' && _text.charAt(_text.length()-1) == '\"') {
          //if (_text.charAt(0) == '\"') {

          //println (text);
          text2 = text.substring (1, text.length()-2);
        }
        TableRow _newRow = R.addRow(); 
        _newRow.setInt  (0, year); 
        _newRow.setString  (1, "In " + year + ", " + trim(text2));
      }
    }
    R.sort(0);
    //println ("check the table");
    //R.print();
    data = R;
    alpha = new float[data.getRowCount()];
  }

  void update (int Annum) {
    //get current annum
    for (int i = 0; i < data.getRowCount(); i++ ) {
      if (data.getRow(i).getInt ("year") == Annum) {
        annumNow = data.getRow(i).getInt ("year");
      } else if (data.getRow(i).getInt ("year") < Annum) {
        annumNow = data.getRow(i).getInt ("year");
      }
    }

    if (data.findRowIndex(str(annumNow), "year") == data.getRowCount()-1) {
      annumNext = annumNow;
    } else {
      annumNext = data.getRow(data.findRowIndex (str(annumNow), "year") + 1).getInt ("year");
    }

    if (annumNow == Annum) {
      onChange = true;
    } else {
      onChange = false;
    }

    int _currentIndex = data.findRowIndex(str(annumNow), "year");
    tyoff = _currentIndex * vdistance;
  }

  void display () {
    int _currentIndex = data.findRowIndex(str(annumNow), "year");
    yoff = yoff + (tyoff - yoff) * velocity;

    // move the scroll to the location
    for (int h = 0; h < data.getRowCount(); h++) {
      // println(h);
      if (h == _currentIndex) {
        if (alpha[h] < 256) {
          alpha[h] = alpha[h] + (255 - alpha[h]) * velocity;
        }
      } else {
        if (alpha[h] > -1) {
          alpha[h] = alpha[h] + ( -alpha[h]) * velocity;
        }
      }
    }
    pushMatrix();
    translate (x, y);
    pushMatrix ();
    // scroll the texts.
    translate (0, -yoff);
    for (int i = 0; i < data.getRowCount(); i++) {
      fill(r, g, b, alpha[i]);
      textAlign (LEFT, TOP);
      textSize (theme.fontSize.get("timeline"));
      text(data.getString (i, "text"), 0, (vdistance * i), w, h);
    }
    popMatrix ();
    popMatrix();
  }
}
