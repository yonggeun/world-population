class Theme {
  String style;
  // colors
  color c_bg;
  color c_title;
  color c_titleZen;

  color c_legendFont;
  color c_legendBG1;
  color c_legendBG2;

  color c_dotBegin;
  color c_dotEnd;
  color c_dotLine;
  color c_dotLineEnd;

  color c_graphFill;
  color c_graphFillHigh;
  color c_graphFillBG;
  color c_graphPop;

  color c_pie;
  color c_pieRank;
  color c_pieLabel;
  color c_pieCurve;
  color c_pieLabelPop;

  color c_territoryFill;
  color c_timelineHeadline;

  // FONT
  FloatDict   fontSize;
  PFont       RC;
  PFont       R_M;
  PFont       RS;
  PFont       R_T;
  PFont       RS_T;
  PFont       RS_B;

  Theme (String Style) {
    // FONT
    // size
    fontSize = new FloatDict();
    fontSize.set("title", 0.21 * s.vgrid);
    fontSize.set("annum", 0.57 * s.vgrid);
    fontSize.set("annumZen", 0.45 * s.vgrid);
    fontSize.set("headline", 0.2  * s.vgrid);
    fontSize.set("pieRank", 0.15 * s.vgrid);
    fontSize.set("pieISO", 0.11 * s.vgrid);
    fontSize.set("piePopulation", 0.13 * s.vgrid);
    // 13
    fontSize.set("legend", 0.108 * s.vgrid);
    fontSize.set("annualPop", s.vgrid * 0.17);

    fontSize.set("timeline", s.vgrid * 0.15);
    // font family
    R_T = createFont("Roboto 100.ttf", 32);
    R_M = createFont("Roboto 500.ttf", 32);
    RC  = createFont("Roboto Condensed regular.ttf", 32);
    RS  = createFont("Roboto Slab regular.ttf", 32);
    RS_T = createFont("Roboto Slab 100.ttf", 32);
    RS_B = createFont("Roboto Slab 700.ttf", 32);
    //
    choose (Style);
  }
  String choose (String Style) {
    switch (Style) {
    case "day":
      style = "day";
      setStyleAsDay ();
      break;
    case "night":
      style = "night";
      setStyleAsNight ();
      break;
    default:
      style = "day";
      setStyleAsDay ();
      break;
    }
    return style;
  }
  void setStyleAsNight () {
    c_bg           = color (0, 0, 0, 255);
    c_title        = color (203, 203, 203);
    c_titleZen     = color (255, 255, 255, 64);
    //
    c_legendBG1    = color (26, 255);
    c_legendBG2    = color (26, 178.5);
    c_legendFont  = color (115, 255);

    c_dotBegin    = color (255, 255, 0, 192);
    c_dotEnd      = color (255, 255, 255, 82);
    c_dotLine     = color ( 18, 18, 18, 255);
    c_dotLineEnd  = color ( 18, 18, 18, 0);
    //
    c_graphFill   = color (101, 101, 101);
    c_graphFillHigh = color (255, 255, 0, 192);
    c_graphFillBG = color (255, 255, 255, 32);

    c_graphPop    = color (203, 203, 203);

    c_pie         = color (51, 51, 51, 255);
    c_pieRank     = color (255, 255, 0, 128);
    c_pieLabel    = color (204, 204, 204, 192);
    c_pieCurve    = color (255, 255, 64, 96);
    c_territoryFill  = color (0, 0, 0, 255);
    //
    c_timelineHeadline =  color(179, 179, 179, 192);
  }
  void setStyleAsDay () {
    setStyleAsNight();
    c_bg           = getInverted (c_bg);  
    c_title        = getInverted (c_title);
    c_titleZen     = getInverted (c_titleZen);
    //
    c_legendBG1    = getInverted (c_legendBG1);
    c_legendBG2    = getInverted (c_legendBG2);
    c_legendFont  = getInverted (c_legendFont);

    //c_dotBegin    = getInverted (c_dotBegin);
    //c_dotBegin    = color (227, 125, 52, 255);
    //c_dotBegin    = color (254, 88, 6, 255);
    c_dotBegin    = color (0, 0, 0, 255);
    c_dotEnd      = color (0, 0, 0, 96);
    c_dotLine     = color (255, 255, 255, 255);
    c_dotLineEnd  = color (255, 255, 255, 0);
    //
    c_graphFill   = getInverted (c_graphFill);
    c_graphFillHigh = color (0, 0, 0, 192);
    c_graphFillBG = getInverted (c_graphFillBG);

    c_graphPop    = getInverted (c_graphPop);

    c_pie         = getInverted(c_pieLabel);
    c_pieRank     = color (0, 0, 0, 128);
    c_pieLabel    = getInverted(c_pieLabel);
    c_pieLabelPop = color (255, 255, 255, 255);
    c_pieCurve    = color (57, 57, 57, 96) ;
    c_territoryFill  = getInverted (c_territoryFill);

    c_timelineHeadline =  getInverted (c_territoryFill);
  }
  color getInverted (color C) {
    float r = 255 - red(C);
    float g = 255 - green(C);
    float b = 255 - blue (C);
    float a = alpha (C);
    return color (r, g, b, a);
  }
}
