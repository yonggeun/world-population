class Stage {
  int width;
  //FHD 1280 x 720
  int height;
  float margin;
  int fps;
  int moduleW;
  int moduleH;
  StringDict system;
  StringDict path;
  String playMode;
  Boolean isRecording;
  Boolean isLogging;
  StringList log;
  float hgrid;  
  float vgrid;

  Stage (int _w, int _fps, Boolean _ir, String _vault) {
    width  = _w;
    height = _w/16*9;
    fps = _fps;
    margin = height / 30;
    playMode = getPlayModeFrom (_w);
    isRecording = _ir;
    isLogging = false;
    log = new StringList();
    //
    system = new StringDict();
    system.set("name", System.getProperty("os.name"));
    system.set("arch", System.getProperty("os.arch"));
    system.set("version", System.getProperty("os.version"));
    system.set("username", System.getProperty("user.name"));
    system.set("started", getTimestamp());
    //
    path = new StringDict();
    path.set("user", System.getProperty("user.dir"));
    path.set("file", getClass().getEnclosingClass().getName());

    // set your own screen capture location
    if (split(System.getProperty("os.name"), " ")[0].equals("Windows")) {
      // for windows
      path.set("home", "D:\\yonggeun");
    } else { 
      // for mac
      path.set("home", System.getProperty("user.home"));
    }
    path.set("sequence", path.get("home")+
      _vault + path.get("file")+
      "/"+playMode+"-"+system.get("started")+"/");
    path.set("screenshot", path.get("home")+
      _vault + path.get("file") +
      "/screenshot/");
    trace("00", path.get("file") + " Stage manger initiated.");
    trace("00", "capture path :\t" + path.get("sequence"));
    trace("00", "screenshot path :\t" + path.get("screenshot"));
  }

  void setGrid (float HorizontalSplit, float VerticalSplit) {
    hgrid = width / HorizontalSplit;
    vgrid = height / VerticalSplit;
  }

  void screenshot (KeyEvent _e, String _ext) {
    String _path;
    if (_e.getKeyCode() == 32 && !isRecording) {
      _path = path.get("screenshot")+playMode+"-"+getTimestamp()+" " +"########."+_ext;
      trace ("01", "Screenshot saved at " + path.get("screenshot")+playMode+"-"+getTimestamp()+" " +nf(frameCount, 8)+"."+_ext);
      saveFrame(_path);
    } else if (_e.getKeyCode() == 32 && isRecording) {
      trace("01", "Screenshot is unable to save since capturing is on gonig.");
    }
  }

  // saves image file sequence to merge them into a video file. 
  void capture (String _ext) {
    if (isRecording) {
      String _path = path.get("sequence")+"########."+_ext;
      //String _pathSVG = path.get("sequence")+"########."+"svg";

      saveFrame(_path);
            saveFrame(_path);
   
      trace("01", "Recorder saved this frame at " + path.get("sequence") +nf(frameCount, 8)+"."+_ext);
    }
  }

  // a handy replacement for println();
  void trace(String _pNumber, String msg) {
    println(msg + " " + _pNumber + ". [" + nf(frameCount, 6) + "]");
    log.append(msg + " " + _pNumber + ". [" + nf(frameCount, 6) + "]");
  }

  void turnLog (Boolean _b) {
    if (_b) {
      isLogging = true;
    } else {
      isLogging = false;
    }
  }

  void render() {
    showLog ();
  }

  void showLog () {
    if (isLogging) {
      //println(log);
      String _output = "";
      ;
      for (int j = 0; j < log.size(); j++) {
        StringList _copied = log.copy();
        _copied.reverse();
        _output += "\n" + _copied.get(j);
      }
      
      textSize(10);
      fill(200);
      textAlign(RIGHT, BOTTOM);
      text(_output, -10, height/3*2 - 10, width, height/3);
    } else {
      // do nothing
    }
  }

  void write (float posX, float posY, int alignX, int alignY, String msg, PFont font, float size, float Leading, color clr) {
    textFont(font);
    textSize(size);
    textAlign(alignX, alignY);
    fill (clr);
    textLeading(Leading);
    text(msg, posX, posY);
  }

  void write (float posX, float posY, String msg) {
    textFont(theme.R_M);
    textSize(theme.fontSize.get("headline"));
    textAlign(LEFT, TOP);
    fill (theme.getInverted(theme.c_bg));
    textLeading(theme.fontSize.get("headline"));
    text(msg, posX, posY);
  }


  String getTimestamp() {
    String _return;
    _return = str(year())+"-" +str(month())+"-"+str(day())+ " " + nf(hour(), 2)+":"+nf(minute(), 2)+":"+nf(second(), 2);
    if (split(System.getProperty("os.name"), " ")[0].equals("Windows")) {
      _return = str(year())+"-" +str(month())+"-"+str(day())+ " " + nf(hour(), 2)+" "+nf(minute(), 2)+" "+nf(second(), 2);
    }
    return _return;
  }

  String getPlayModeFrom (int _screenWidth) {
    String _playMode;
    switch (str(_screenWidth)) {
      // 1280(test) 1920 (FHD) 3840(4k) 5120(5k)
    case "1280":
      _playMode = "TEST";
      break;
    case "1920":
      _playMode = "FHD";
      break;
    case "3840":
      _playMode = "4K";
      break;
    case "5120":
      _playMode = "5K";
      break;
    default:
      _playMode = "TEST";
      break;
    }
    return _playMode;
  }

  String getDoublelineString (String S) {
    //String r[];
    String[] lines = split (S, ' ');
    int minIndex = -1;
    int theShortest = S.length();
    int length0 = 0;
    int length1 = 0;

    for (int i = 1; i < lines.length; i++) {
      for (int j = 0; j < i; j++) {
        length0 += lines[j].length();
      }

      for (int k = i; k < lines.length; k++) {
        length1 += lines[k].length();
      }
      if (theShortest > abs(length0 - length1)) {
        theShortest = abs(length0 - length1);
        minIndex = i;
      }
      length0 = 0;
      length1 = 0;
    }
    String result = "";
    for (int m = 0; m < lines.length; m++) {
      result += lines[m];
      if (m == minIndex-1) {
        result += "\n";
      } else {
        result += " ";
      }
    }
    return trim(result);
  }
}
