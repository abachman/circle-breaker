class Starter {
  float x, y, d, r;
  int steps;
  int c_val;
  color c;

  Starter(float _x, float _y) {
    d = 30;
    r = d / 2.0;
    c_val = 255;
    x = _x - r;
    y = _y - r;
  }

  void update() {
    d -= 2;
    r -= 1;
    x = x + 1;
    y = y + 1;
    c_val -= 255 / steps;
    c = color(c_val);
  } 

  void drawme() {
    if (r > 0) {
      stroke(c);
    }
  }
}
