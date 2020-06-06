/* //<>//
public static final int  CATEGORY  5
 public static final int  DOUBLE  4
 public static final int  FLOAT  3
 public static final int  INT  1
 public static final int  LONG  2
 public static final int  STRING  0
 */
import java.util.Map;

Table table;
boolean tableLoaded = false;

HashMap<String, Table> annals;  // HashMap object
HashMap<String, Table> localAnnals;  // HashMap object

boolean annalsLoaded = false;
boolean localAnnalsLoaded = false;

boolean ready = false;

void setup() {
  // 0@iso  0@name  1@year  3@value

  table = getParsed(loadTable("population.csv", "header"));

  //table.print();
  annals = getAnnals(table);
  localAnnals = getLocalAnnals(table);

  //for (int j = 1800; j < 2020; j++) {
  // println(j, "\t", annals.get(str(j)).getRowCount());
  //}
  if (annalsLoaded && tableLoaded && localAnnalsLoaded) {
    ready = true;
    println("all is ready");
    
    localAnnals.get("US").print();
    
    println(getLocalMaxPopulation ("ru"));
  }
}

void draw () {
  //if (table.getRowCount() > 1 && annals.size() > 1) {
  //  println("all is ready");
  //}
}

Table getParsed (Table T) {
  Table t = new Table (); 
  // copy the columns
  for (int i = 0; i < T.getColumnCount(); i++) {
    t.addColumn(T.getColumnTitle(i).substring(2), int(T.getColumnTitle(i).substring(0, 1))); 
    //println("int(T.getColumnTitle(i).charAt(0)) : ",int(T.getColumnTitle(i).substring(0,1)));
  }

  // copy the rows
  for (TableRow r : T.rows()) {
    //println(row.getString(0) + " (" + row.getInt(2) + ") \t\t\t" + str(row.getFloat(3)));
    TableRow newRow = t.addRow(); 
    newRow.setString  (0, r.getString(0)); 
    newRow.setString  (1, r.getString(1)); 
    newRow.setInt     (2, r.getInt(2)); 
    newRow.setFloat   (3, r.getFloat(3));
  }

  //t.print();
  println("parse done with ", t.getRowCount(), " rows");
  tableLoaded = true;
  return t;
}

HashMap<String, Table> getAnnals (Table T) {
  HashMap<String, Table> _annals; 
  _annals = new HashMap<String, Table>();

  // interate the rows in the table
  for (int i = 0; i < T.getRowCount(); i ++) {
    TableRow row = T.getRow(i);
    String year = str(row.getInt("year"));

    // if the year appears first time
    if (_annals.containsKey(year) != true) {
      // get a fresh table
      Table _annal = new Table ();
      _annal = T.copy();
      _annal.clearRows();

      for (TableRow _r : T.findRows(year, "year") ) {        
        _annal.addRow(_r);
      }
      _annals.put(year, _annal);
    } else {
      //println("isolated row occured!");
    }
  }
  annalsLoaded = true;
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

float getLocalMaxPopulation (String ISO) {
  float _r = 0;
  String _iso;
  _iso = ISO.toUpperCase();
  Table _t;
  _t = localAnnals.get(_iso);
  
  _t.sort("value");
  _r = _t.getRow(_t.getRowCount()-1).getFloat ("value");
  
  return _r;
}
