class Pie {
  Table table;
  // iso, name, year, value, xpos
  int totalNum;
  int displayNum;
  float x;
  float y;
  float w;
  
  Pie (float X, float Y, Table T, int dn){
    totalNum = T.getRowCount();
    x = X;
    y = Y;
    displayNum = dn;
  }
  void update () {
  }
  void display () {
    // move
    translate(x, y);
    // styles
    stroke (51);
    strokeWeight(2);
    noFill();
  }
}
