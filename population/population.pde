import processing.svg.*; //<>// //<>// //<>//

// The source code is under MIT licencce.  //<>// //<>// //<>// //<>// //<>// //<>//
// Yonggeun Kim, vizualizer.com / vizualizer@gmail.com
// 11 June 2020

// https://worldpopulationhistory.org/map/
import geomerative.*;  
import java.util.Map;

boolean zen = true;
boolean movieIsOver = false;
boolean movieIsReady = false;

// timer all in frames
int     annum;
int     framerate = 60;
// zen mode duration? 90 -> 1.5 sec (framerate * 15 / 10 is the regular speed)
float   durationInSec; // in sec
int     duration = 0;  
int     startFrame = 0;
int     endFrame = 0;
int     framesSinceActive;
float   progress;      
//
float renderScale = 10; // 10 is optimal.

Stage s = new Stage (1920, framerate, false, "/waterfall/processing/");

Data data;
Paper paper;
Oven oven;
Graph annualGraph;
Theme theme;
Scroll scroll;

public void settings() {
  fullScreen();
  size (s.width, s.height);
  smooth(2);
}

void setup() {
  frameRate(framerate);

  s.setGrid (8, 6); //dotSize = grid / 10;
  theme = new Theme ("day");
  if (zen) {
    durationInSec = 1.27;
  } else {
    durationInSec = 1.48;
  }
  duration = int (map (durationInSec, 0, 1, 0, float(framerate)));

  // grid calculation 

  // VERY IMPORTANT: Allways initialize the library before using it
  RG.init(this);
  RG.ignoreStyles(true);
  RG.setPolygonizer(RG.ADAPTATIVE);

  // load map
  //Paper (float RenderScale, float DotSizeBegin, float DotSizeEnd) {
  paper = new Paper (renderScale, s.vgrid / 35, float (s.width) / 2000); /// 0.0125

  if (zen) {
    paper.loadMap("world.svg", s.vgrid * 0.416, 0, 0); //1.5
  } else {
    paper.loadMap("world.svg", s.vgrid * 0.830, 0, -s.vgrid * 0.4); //1.5
  }
  paper.applyTheme(theme);

  // load data
  data = new Data (renderScale);
  data.attachPaper (paper);
  data.init (loadTable("population.csv", "header"));   // Load data from local CSV file
  annum = data.annumBeginsIn;

  // timeline
  //   Scroll (float X, float Y, float W, float H) {
  scroll = new Scroll (s.vgrid * 4.54 - width/2, s.vgrid * 0.17  - height/2, s.vgrid * 6, theme.fontSize.get("headline") * 3);
  scroll.loadData("timeline.csv");
  scroll.setAnnumRange(data.annumBeginsIn, data.annumEndsIn);
  scroll.setColor (theme.c_timelineHeadline);

  //
  oven = new Oven (20, s.vgrid * 2.2); // 2.25
  oven.applyTheme (theme);
  oven.init (paper, data);
  paper.attachOven (oven);

  annualGraph = new Graph (data, s.vgrid*3.04, s.vgrid * 0.175, s.vgrid * 1.4, s.vgrid*0.46);
  annualGraph.applyTheme (theme);
  annualGraph.parseData(data.annals);

  // run a seperate thread to get the random dot coord for each territory
  if (data.annalsLoaded && data.rawTableLoaded && data.localAnnalsLoaded) {
    movieIsReady = true;
    println("Ready for dot scattering!");
    thread ("getDotMap");
  }
}

void getDotMap () {
  paper.getDotMapFromData(data);
}

void draw() {
  // get mouse coord
  // RPoint m = new RPoint(mouseX-width/2, mouseY-height/2);
  translate(width/2, height/2);
  background(theme.c_bg);

  // A if dot coords are confirmed,  
  if (paper.dotMapLoaded && movieIsReady) {
    // the the number of dots between current annum and the next
    framesSinceActive = frameCount - startFrame;
    annum = data.annumBeginsIn + (framesSinceActive / duration);
    annum = (annum > data.annumEndsIn) ? data.annumEndsIn : annum;
    progress = float(framesSinceActive - duration * (framesSinceActive / duration)) / float(duration);

    //update the values upon each year (annum)
    if (progress == 0.0 && !movieIsOver) {
      //
      oven.parseYear (annum);
      oven.update ();
      //
      scroll.update(annum);
    }

    // Drawing the bottom pies and lines to each countries. 
    if (zen) {
    } else {
      oven.display();
      scroll.display();
    }
    dashboard();

    // B process for each country. ISO is accessible.
    for (int i = 0; i < paper.map.countChildren(); i++) {

      // get TableRow for each country
      String iso = paper.map.children[i].name;
      TableRow row = data.getTableByAnnum(annum).findRow(iso, "iso");      

      // -------------------------  
      // COUNTRY-SPECIFIC PROCESS
      // several rows will return null until the year of 1949
      //
      if (row != null) {

        // Population for each country
        int dotCount = ceil(row.getFloat("value"));
        int dotCountNext = 0;
        if (annum < data.annumEndsIn) {
          dotCountNext = ceil (data.annals.get(str(annum + 1)).findRow(iso, "iso").getFloat("value"));
        } else {
          dotCountNext = ceil (data.annals.get(str(annum    )).findRow(iso, "iso").getFloat("value"));
        }

        // get the final number of dots to draw based on the value, scale then pogress.
        int dotNum = ceil (dotCount + ((dotCountNext - dotCount) * progress)); 
        //println("dotnum ", dotNum);

        // draw dots
        if (dotNum > 0) {
          for (int k = 0; k < dotNum; k++) {
            paper.dotMap.get(iso).get(k).update();
            paper.dotMap.get(iso).get(k).display();
          }
        }
      }
      // end of drawing dots for each country
    } // B finished.
    s.capture("tga");

    // A finished.
  } else { 
    // in case the movie is still preparing, then show the basic setting.
    printMovieSettings ();
  }

  // 
  if (framesSinceActive > duration * (data.annumEndsIn - data.annumBeginsIn + 1 + 5) && !movieIsOver) {
    movieIsOver = true;
    endFrame = frameCount - startFrame;
    println("finshied on ", s.getTimestamp());
  }

  if (movieIsOver && framesSinceActive > endFrame) {
    println("movie completed on ", s.getTimestamp());
    exit();
  }
  //
}

void dashboard () {
  // 
  pushMatrix();
  translate (-width/2, -height/2);
  if (zen) {
    // annum
    s.write (5.3 * s.vgrid, 4.9 * s.vgrid, CENTER, TOP, str(annum), 
      theme.R_T, theme.fontSize.get("annumZen"), theme.fontSize.get("annumZen"), 
      theme.c_titleZen);
  } else {
    //title 
    s.write (s.vgrid * 1.6, s.vgrid * 0.13, RIGHT, TOP, "WORLD\nPOPULATION", 
      theme.RS_B, theme.fontSize.get("title"), theme.fontSize.get("title") * 1.25, 
      theme.c_title);

    // annum
    s.write (s.vgrid * 1.725, s.vgrid * 0.765, LEFT, BOTTOM, str(annum), 
      theme.RS_T, theme.fontSize.get("annum"), theme.fontSize.get("annum"), 
      theme.c_title);

    //legend
    noStroke();
    fill(theme.c_legendBG1);
    //rect (21, 92, 20, 20);
    rect (0.193 * s.vgrid, 0.77 * s.vgrid, 0.167 * s.vgrid, 0.167 * s.vgrid);
    fill(theme.c_legendBG2);
    //rect (21, 92, 169, 20);
    rect (0.193 * s.vgrid, 0.77 * s.vgrid, 1.4 * s.vgrid, 0.167 * s.vgrid);
    // circle
    fill (red(theme.c_dotEnd), green (theme.c_dotEnd), blue (theme.c_dotEnd));
    ellipse(0.275 * s.vgrid, 0.84 * s.vgrid, paper.dotSizeEnd, paper.dotSizeEnd);
    // caption
    fill (theme.c_legendFont);
    //void write (float posX, float posY, int alignX, int alignY, String msg, PFont font, float size, float Leading, color clr) {
    s.write(0.39 * s.vgrid, 0.92 * s.vgrid, LEFT, BOTTOM, nfc(int(1000000 / renderScale)) + " population", 
      theme.RC, theme.fontSize.get("legend"), theme.fontSize.get("legend"), theme.c_legendFont);
    annualGraph.update(annum);
    annualGraph.render();
  }
  popMatrix ();
}

void printMovieSettings () {
  //println("duration : ", duration);
  String msg = "";
  msg += "renderScale : " + renderScale;
  msg += "\ndotSizeBegin : "  + paper.dotSizeBegin;
  msg += "\ndotSizeEnd : " + paper.dotSizeEnd;
  msg += "\nduraion in seconds : " + durationInSec;
  msg += "\nduraion : " + duration;
  msg += "\ntheme ; " + paper.theme.style;

  s.write(s.vgrid/10, s.vgrid / 10, msg);
  for (int  i = 0; i < 5; i++) {
    // println( i);
    fill (lerpColor(theme.c_dotBegin, theme.c_dotEnd, map(i, 0, 4, 0, 1)));
    float w = map (i, 0, 4, paper.dotSizeBegin, paper.dotSizeEnd);
    ellipse (s.vgrid/10 * i + s.vgrid/10, -s.vgrid/10, w, w);
  }
}


void keyPressed(KeyEvent e) {
  s.screenshot(e, "tga");
}
