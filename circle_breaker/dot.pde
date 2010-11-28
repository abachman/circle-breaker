class Dot {
  float x,y,rad;
  float l,r,t,b;
  float vx,vy;
  boolean launched;
  Dot() { 
   launched = false; 
  }  
  void launch() {
    x = random(1,width-1);
    y = random(0,1)>.5 ? 0 : height;
    vx = random(SPEED[0], SPEED[1]) * (random(0,1)>.5 ? -1 : 1);
    vy = random(SPEED[0], SPEED[1]);
    launched = true;
    rad = random(3, 18);
  }
  boolean update() {
    x += vx;
    y += vy;
    l = x-rad;
    r = x+rad;
    t = y-rad;
    b = y+rad;
    if (x < 0 || x > width) {
      vx *= -1;
    }
    else if (y < 0 || y > height) {
      vy *= -1;
    }
    return true;
  }  
  void drawme() {
    fill(200, 50);
    // fill(0);
    noStroke();
    ellipse(x,y,rad*2,rad*2);
  }
}

