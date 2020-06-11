class Data {
  float annum;
  int   annumBeginsIn;
  int   annumEndsIn;

  // data structure
  Table table;
  HashMap<String, Table> annals;  
  HashMap<String, Table> localAnnals;

  // check loaded
  boolean rawTableLoaded = false;
  boolean annalsLoaded = false;
  boolean localAnnalsLoaded = false;

  // Rendering
  Paper paper;

  Data (float RenderScale) {
    renderScale = RenderScale;
    // dotSize = 2, 
    rawTableLoaded = false;
    annalsLoaded = false;
    localAnnalsLoaded = false;

    annumBeginsIn = year();
    annumEndsIn = 0;
  }

  void attachPaper (Paper PAPER) {
    paper = PAPER;
  }

  void init (Table T) {
    // parse data
    table       = getRawTable     (T);
    annals      = getAnnals       (table);
    localAnnals = getLocalAnnals  (table);
    println ("data loaded");
  }

  Table getRawTable (Table T) {
    Table _t = new Table ();

    // copy the columns
    for (int i = 0; i < T.getColumnCount(); i++) {
      _t.addColumn(T.getColumnTitle(i).substring(2), int(T.getColumnTitle(i).substring(0, 1)));
    }
    _t.addColumn ("cx", Table.FLOAT);
    _t.addColumn ("cy", Table.FLOAT);

    // copy the rows
    for (TableRow _r : T.rows()) {
      TableRow _newRow = _t.addRow(); 

      _newRow.setString  (0, _r.getString(0)); 
      _newRow.setString  (1, _r.getString(1)); 
      _newRow.setInt     (2, _r.getInt(2)); 
      _newRow.setFloat   (3, _r.getFloat(3) * renderScale);
      //
      _newRow.setFloat (4, paper.getCentroidFromISO(_r.getString(0)).x);
      _newRow.setFloat (5, paper.getCentroidFromISO(_r.getString(0)).y);
    }

    println("parse done with ", _t.getRowCount(), " rows");
    rawTableLoaded = true;

    return _t;
  }

  HashMap<String, Table> getAnnals (Table T) {
    HashMap<String, Table> _annals; 
    _annals = new HashMap<String, Table>();

    // interate the rows in the table
    for (int i = 0; i < T.getRowCount(); i++) {
      TableRow _r1 = T.getRow(i);
      // get maximum
      if (annumEndsIn < _r1.getInt("year")) {
        annumEndsIn = _r1.getInt("year");
      }
      // get minimum
      if (annumBeginsIn > _r1.getInt("year")) {
        annumBeginsIn = _r1.getInt("year");
      }
      String _year = str(_r1.getInt("year"));

      // if the year appears first time
      if (_annals.containsKey(_year) != true) {
        // get a fresh table
        Table _annal = new Table ();
        _annal = T.copy();
        _annal.clearRows();

        for (TableRow _r2 : T.findRows(_year, "year") ) {        
          _annal.addRow(_r2);
        }

        _annals.put(_year, _annal);
      } else { // in case of isolated row
      }
    }
    annalsLoaded = true;
    print ("annumBeginsIn : ", annumBeginsIn, " / ");
    println ("annumEndsIn   : ", annumEndsIn);
    return _annals;
  }

  HashMap<String, Table> getLocalAnnals (Table T) {
    HashMap<String, Table> _annals; 
    _annals = new HashMap<String, Table>();

    // interate the rows in the table
    for (int i = 0; i < T.getRowCount(); i ++) {
      TableRow row = T.getRow(i);
      String iso = row.getString("iso");

      // if the year appears first time
      if (_annals.containsKey(iso) != true) {
        // get a fresh table
        Table _annal = new Table ();
        _annal = T.copy();
        _annal.clearRows();

        for (TableRow _r : T.findRows(iso, "iso") ) {        
          _annal.addRow(_r);
        }
        _annal.sort("year");

        _annals.put(iso, _annal);
      } else {
        //println("isolated row occured!");
      }
    }
    localAnnalsLoaded = true;
    return _annals;
  }

  Table getTableByAnnum (int Annum) {
    return annals.get(str(Annum));
  }

  float getAnnualPopulation (int Annum) {
    float pop = 0.0;
    for (TableRow r : getTableByAnnum (Annum).rows()) {
      // println(i);
      pop += r.getFloat(3);
    }
    return pop / renderScale;
  }

  float getLocalMaxPopulation (String ISO) {
    float _r = 0;
    String _iso;
    _iso = ISO.toUpperCase();

    Table _t;
    _t = localAnnals.get(_iso);

    if (_t != null) {
      _t.sort("value");
      _r = _t.getRow(_t.getRowCount()-1).getFloat ("value");
    } else {
      _r = 0;
    }
    return _r;
  }
}
