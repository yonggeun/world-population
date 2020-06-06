class Graph {
  Table table;
  Data data;

  float x;
  float y;
  float w;
  float h;
  float yMin;
  float yMax;
  float gap;
  int annum;
  int annumTotal;
  PShape graph;
  PShape refLine;
  //
  Theme theme;

  Graph  (Data DATA, float posX, float posY, float Width, float Height) {
    data = DATA;
    x = posX;
    y = posY;
    w = Width;
    h = Height;
    annumTotal = DATA.annumEndsIn - data.annumBeginsIn + 1;
    gap = w / annumTotal;
  }  

  void applyTheme(Theme THEME) {
    theme = THEME;
  }

  void parseData (HashMap<String, Table> Annals) {
    // prepare table
    table = new Table ();
    table.addColumn("year", Table.INT);
    table.addColumn("value", Table.FLOAT);

    for (int i = 0; i < Annals.size(); i++) {
      // println(i);
      float _valueSum;
      _valueSum = 0.0;
      for (TableRow _tr : Annals.get(str(data.annumBeginsIn + i)).rows()) {
        _valueSum += _tr.getFloat ("value");
      }

      // new row
      TableRow _nr = table.addRow();
      _nr.setInt("year", data.annumBeginsIn + i);
      _nr.setFloat ("value", _valueSum);
      table.addRow(_nr);
    }
    //table.print();
    println(
      "max - ", table.getFloatList("value").max(), 
      "min - ", table.getFloatList("value").min()
      );

    yMin = table.getFloatList("value").min();
    yMax = table.getFloatList("value").max();
  }
  void update (int Annum) {
    // get Year 
    annum = Annum;
    // get new y pos for flatline
    // get new population size for the given year.
  }

  void render () {
    // draw the curves. 
    pushMatrix();
    translate(x, y);
    RShape shapeHead = new RShape();
    RShape shapeTail = new RShape();

    float px = 0.0;
    float py = 0.0;
    float refx = 0.0;
    float refy = 0.0;
    // head
    for (int i = data.annumBeginsIn; i <= annum; i++) {
      px = map (i, data.annumBeginsIn, data.annumEndsIn, 0, w);
      py = map (table.findRow(str(i), "year").getFloat("value"), 
        yMin, yMax, 
        h, 0);
      shapeHead.addLineTo(px, py);
      //
      if (i == annum) {
        refx = px;
        refy = py;
      }
    }
    shapeHead.addLineTo (px, h);
    shapeHead.addLineTo (0, h);
    shapeHead.addClose();
    noStroke();
    fill (theme.c_graphFillHigh);
    shapeHead.draw();
    // draw head BG
    fill (theme.c_graphFillBG);
    rect(0, 0, refx, h);
    
    // tail
    for (int i = annum; i <= data.annumEndsIn; i++) {
      px = map (i, data.annumBeginsIn, data.annumEndsIn, 0, w);
      py = map (table.findRow(str(i), "year").getFloat("value"), 
        yMin, yMax, 
        h, 0);
      shapeTail.addLineTo(px, py);
      //
    }
    shapeTail.addLineTo (w, h);
    shapeTail.addLineTo (refx, h);
    shapeTail.addLineTo (refx, refy);
    shapeTail.addClose();
    noStroke();
    fill (theme.c_graphFill);
    shapeTail.draw();

    // draw the the ref line and the current population
    String annualPop = nfc(data.getAnnualPopulation (annum) / 1000, 1) + " Billion";
    //void write (float posX, float posY, int alignX, int alignY, String msg, PFont font, float size, float Leading, color clr) {
    s.write (s.vgrid * 0.025, 0, LEFT, TOP, annualPop, 
      theme.R_M, theme.fontSize.get("annualPop"), theme.fontSize.get("annualPop"), theme.c_graphPop);

    if (refx < w / 2) {
    } else {
    }
    popMatrix();
  }
}
