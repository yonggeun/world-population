class Oven { //<>// //<>//
  // DATA
  int annum;
  HashMap<String, Table> annals;
  Table mold;
  Table thisYear;
  Table nextYear;

  // RENDERING
  int plates;
  float[] distances;
  float W;
  float X;
  float Y;

  float TX;
  float TY;
  float TW;
  int maxRowCount;
  HashMap<String, Pie> pies;
  float pieScale;
  //
  Paper paper;
  Theme theme;

  Oven (int Plates, float posY) {

    plates = Plates;
    distances = new float[plates-1];
    pies = new HashMap<String, Pie>();
    Y = posY;
    TY = Y;
    pieScale = float(s.width) / 700;
  }

  void applyTheme (Theme T) {
    theme = T;
  }

  void init (Paper PAPER, Data DATA) {
    paper = PAPER;
    annals = DATA.annals;
    maxRowCount = annals.get(str(DATA.annumEndsIn)).getRowCount();
    for (int k = 0; k < maxRowCount; k ++) {
      pies.put(
        annals.get(str(DATA.annumEndsIn)).getRow(k).getString("iso"), 
        new Pie (
        paper, 
        annals.get(str(DATA.annumEndsIn)).getRow(k).getString("iso"), 
        theme.c_pie)
        );

      pies.get(
        annals.get(str(DATA.annumEndsIn)).getRow(k).getString("iso")
        ).config(0, Y, 0, false);
    }
  }

  void parseYear (int Annum) {
    // PREPARE THE TABLE TO REFER BY ANNUM, YEAR.
    annum = Annum;
    // ordered by rank
    thisYear = annals.get (str(annum    )).copy();
    // ordered by rank    
    if (annum < paper.data.annumEndsIn) {
      nextYear = annals.get (str(annum + 1)).copy();
    } else {
      nextYear = annals.get (str(annum)).copy();
    }
    mold = thisYear.copy();
    // ordered by 
    // 0 ~ 9     -> x coord of centroid
    // 10 ~ end  -> value (population)
    mold.clearRows();

    // get top 10; from 0 to 9
    thisYear.sortReverse("value");  // <-------------------------  ------------------------- 

    for (int i = 0; i < plates; i++) {
      mold.addRow(thisYear.getRow(i));
    }
    mold.sort("cx");

    // get the rest; from 10 to the end
    for (int j = plates; j < thisYear.getRowCount(); j++) {
      mold.addRow(thisYear.getRow(j));
    }
    mold.addColumn ("velocity", Table.FLOAT);
    for (TableRow mr : mold.rows()) {

      TableRow sameRowInNextYear = nextYear.findRow(mr.getString("iso"), "iso");

      if (sameRowInNextYear != null) {
        mr.setFloat (
          "velocity", 
          (nextYear.findRow(mr.getString("iso"), "iso").getFloat("value") - mr.getFloat("value")) / framerate
          );
      } else {
        mr.setFloat (
          "velocity", 
          1);
      }
    }

    //  -------------------------  end of making mold  -------------------------  
    // SORT TABLE ROWS BY VALUE (POPULATION) IN DECENDING ORDER
    thisYear.sortReverse("value"); 
    nextYear.sortReverse("value");
  }

  void update () { // REFRESH THE VARIABLES IN PIES BASED ON THE TABLE VALUES. 
  
    // GET THE TARGET DISTANCES 
    for (int l = 0; l < plates-1; l++) {
      TableRow tr0 = mold.getRow (l);
      float   _value0      = tr0.getFloat ("value");

      TableRow tr1 = mold.getRow (l + 1);
      float   _value1      = tr1.getFloat ("value");

      float _r0 = getRadius (_value0); 
      float _r1 = getRadius (_value1); 
      //float _gap = 1;

      distances[l] = sqrt(pow (_r0 + _r1, 2) - pow (_r1 - _r0, 2));
    }

    float _gap = (width - getWidth()) / plates / 1.5;

    for (int u = 0; u < distances.length; u++) {
      distances[u] += _gap;
    }
    // 
    TX = getWidth() / 2;

    for (int m = 0; m < plates; m++) {
      TableRow tr = mold.getRow (m);
      Pie _p = pies.get(tr.getString ("iso"));
      // x pos for each pie.
      float _x = 0;
      for (int n = 0; n < m; n++) {
        _x += distances[n];
      }
      //_x += TX;
      _p.config (_x - TX, Y, getRadius (tr.getFloat("value")), true); //  -------------------------  ☄ -------------------------
    }

    // hide the pies out of the plates
    for (int n = plates; n < mold.getRowCount(); n++) {
      TableRow tr = mold.getRow (n);
      Pie _p = pies.get(tr.getString ("iso"));

      _p.config (0, Y, 1, false); //  -------------------------   -------------------------
    }
    
    // push the current rank to each pie.
    for (int q = 0; q < thisYear.getRowCount(); q++) {
      TableRow tr = thisYear.getRow (q);
      Pie _p = pies.get(tr.getString ("iso"));
      _p.setRank(q); //  -------------------------   -------------------------
    }
  }

  void display() {
    X = X + (TX - X) * 0.7;
    Y = Y + (TY - Y) * 0.7; 

    for (int  i = 0; i < mold.getRowCount(); i++) {
      pies.get(
        mold.getRow(i).getString("iso")
        ).update ();

      pies.get(
        mold.getRow(i).getString("iso")
        ).display ();
    }

    for (int  j = 0; j < mold.getRowCount(); j++) {
      pies.get(
        mold.getRow(j).getString("iso")
        ).renderLabels ();
    }
  }

  float getRadius (float V) {
    float _dotArea = pow (paper.dotSizeEnd / 2, 2) * PI; // compute a circle
    float _totalArea = _dotArea * V / paper.renderScale;
    return sqrt(_totalArea / 3.0) * pieScale;
  }

  float getWidth () {
    float _w = 0.0;
    for (int i = 0; i < distances.length; i++) {
      _w += abs(distances[i]);
    }
    W = _w;
    return W;
  }

  Pie getPieFromRank (int Rank) {
    Pie _p = pies.get(thisYear.getRow(Rank).getString("iso"));
    return _p;
  }

  int getRankFromPie (Pie p) {
    int _r;
    _r = thisYear.findRowIndex (p.iso, "iso");
    return _r;
  }
}
