class Paper {
  //
  Theme theme;
  Oven oven;
  Data data;
  // processing
  boolean dotMapLoaded = false;
  // Create a array to store the randomized location of the dots for each territory
  HashMap<String, ArrayList<Dot>> dotMap = new HashMap<String, ArrayList<Dot>>();
  // Rendering
  RShape map;
  //
  float dotSizeBegin;
  float dotSizeEnd;
  float dotArea;
  float dotPopSize;
  float renderScale;
  // settings
  boolean ignoreStyles = true;

  Paper (float RenderScale, float DotSizeBegin, float DotSizeEnd) {
    renderScale = RenderScale;
    dotSizeBegin = DotSizeBegin;
    dotSizeEnd = DotSizeEnd; // 3 is default
    dotArea = PI * pow(dotSizeEnd/2, 2);
  }

  void attachOven (Oven OVEN) {
    oven = OVEN;
  }
  void applyTheme (Theme T) {
    theme = T;
  }

  RShape loadMap (String url, float Margin, float X, float Y) {
    map = RG.loadShape(url);
    map.centerIn (g, Margin, 1, 1);
    map.translate (X, Y);
    return map;
  }

  void getDotMapFromData (Data DATA) {
    data = DATA;
    for (int i = 0; i < map.countChildren(); i++) {
      // Perlin noise settings
      float _xoff = 0.0;
      float _yoff = 1000;

      String _iso = map.children[i].name.toUpperCase();
      float _x = map.children[i].getX();
      float _y = map.children[i].getY();
      float _w = map.children[i].getWidth();
      float _h = map.children[i].getHeight();

      int _maxNumberOfDots = 0;
      _maxNumberOfDots = ceil (DATA.getLocalMaxPopulation(_iso));
      
      ArrayList<Dot> _dots = new ArrayList <Dot>();
      RPoint _dot;

      if (_maxNumberOfDots != 0) {
        while (_maxNumberOfDots > 0) {

          // other way to calculate the scattered dot
          //float _x = map (noise(_xoff), 0.25, 0.75, x, x+w);
          //float _y = map (noise(_yoff), 0.25, 0.75, y, y+h);

          // 1 - optimal
          float _dotx = map (noise(_xoff), 0.25, 0.75, _x, _x + _w);
          float _doty = map (noise(_yoff), 0.25, 0.75, _y, _y + _h);
          _dot = new RPoint (_dotx, _doty);

          if (map.children[i].contains(_dot)) {
            _dots.add(new Dot (_dotx, _doty, dotSizeBegin, dotSizeEnd));
            _maxNumberOfDots --;
          }
          _xoff += 5;
          _yoff += 2.5;
        }
        dotMap.put(map.children[i].name, _dots);
        
      } else if (_maxNumberOfDots == 0) {

        dotMap.put(map.children[i].name, null);
      }
    }

    dotMapLoaded = true;
    println ("Dot coords are ready at ", s.getTimestamp());

    startFrame = frameCount;
  }

  RPoint getCentroidFromISO (String ISO) {
    RPoint _c = new RPoint (0, 0);

    _c = new RPoint (width/2, height);

    for (int i = 0; i < map.countChildren(); i++) {
      if (ISO.equals (map.children[i].name) == true) {
        _c = map.children[i].getCentroid();
      }
    }

    return _c;
  }
}
