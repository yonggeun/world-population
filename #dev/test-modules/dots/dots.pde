
ArrayList<Dot> dots = new ArrayList<Dot>();

void setup () {
  size (500, 500);
  frameRate(60);
  for (int k = 0; k < 100; k++) {
    dots.add(new Dot(random(0, width), random(0, height), 10, 255));
    //print(k);
  }
}
void draw () {
  background (0);
  for (Dot p : dots) {
    p.update();
    p.display();
  }
}

void keyPressed() {
  if (key == CODED) {

    if (keyCode == UP) {
      dots.add(new Dot(random(0, width), random(0, height), 10, 255));
    } else if (keyCode == DOWN) {
    } else {
    }
    println(dots.size());
  }
}
