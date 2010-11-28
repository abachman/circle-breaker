///
// Control Pad Methods
///
//

ControllIO controll;
ControllDevice device;
ControllStick  dpad;

float transX, transY;
boolean use_controlpad;
boolean buttons[];

// reticle movement
float EASING = 0.2;
Reticle reticle;

void initControlPad() {
  controll = ControllIO.getInstance(this);

  device = controll.getDevice(0);
  device.setTolerance(0.05f);

  controll.printDevices();
  device.printSticks(); 
  device.printButtons();

  initButtons();

  transX = 0.0;
  transY = 0.0;

  reticle = new Reticle(device.getStick(0));
} 

class Reticle {
  float cx,cy,vx,vy,ncx,ncy,r,d, dx, dy, gx, gy;
  // bbox: left, right, top, bottom
  float bboxl, bboxr, bboxt, bboxb;
  ControllStick dpad;

  // targeting system
  Reticle(ControllStick _dpad) {
    r = 5.0;
    d = r * 2;
    cx = width / 2.0;
    cy = height / 2.0;

    ncx = cx; ncy = cy;

    vx = 25.0; vy = 25.0;

    if (BOUNDING_BOX) {
      bboxl = bboxx;
      bboxr = bboxx + bboxw;
      bboxt = bboxy;
      bboxb = bboxy + bboxh;
    } else {
      bboxl = 0;
      bboxr = width;
      bboxt = 0;
      bboxb = height;
    }


    dpad = _dpad;
  }

  void debug() {
    String out = "cx:" + cx + " cy:" + cy + "\nvx:" + vx + " vy:" + vy + "\ngx:" + gx + " gy:" + gy;
    fill(200);
    text(out, width/2, height - 60);

  }

  void update() {/**/
    // get input (flipped, lame controller)
    gx = dpad.getY();
    gy = dpad.getX();

    // update new center
    if (gx > 0.5 && ncx + d < bboxr)   ncx += vx; // right
    else if (gx < -0.5 && ncx > bboxl) ncx -= vx; // left
    
    if (gy > 0.5 && ncy + d < bboxb)   ncy += vy; // up
    else if (gy < -0.5 && ncy > bboxt) ncy -= vy; // down

    // corrections
    if (ncx + d > bboxr)  { ncx = bboxr - d; }
    else if (ncx < bboxl) { ncx = bboxl; }

    if (ncy + d > bboxb)  { ncy = bboxb - d; }
    else if (ncy < bboxt) { ncy = bboxt; }

    // move position towards new center
    dx = ncx - cx;
    if (abs(dx) > 1) cx += dx * EASING;
    else cx =  ncx;

    dy = ncy - cy;
    if (abs(dy) > 1) cy += dy * EASING;
    else cy = ncy;
    
  /**/}

  void drawme() {
    // centered
    stroke(255);
    noFill();
    line(0, cy + r, width, cy + r);
    line(cx + r, 0, cx + r, height);
    ellipse(cx + r, cy + r, d, d);
  }

  void trigger() {
    StartExplosion(cx, cy);
  }
}
void initButtons() {
  buttons = new boolean[10];
  for (int b = 0; b < buttons.length; b++) {
    // more specific behaviors
    // _setCallback("b" + b + "Press", "b" + b + "Release", b);
    _setCallback("buttonPress", "buttonRelease", b);
  } 
}

void _setCallback(String funcOn, String funcOff, int but) {
  device.plug(this, funcOn, ControllIO.ON_PRESS, but);
  device.plug(this, funcOff, ControllIO.ON_RELEASE, but);
}

void buttonPress()   { handleButtonPress(0);   }
void buttonRelease() { handleButtonRelease(0); }

/* unused */ /*
void b0Press() { buttons[0] = true; handleButtonPress(0); }
void b1Press() { buttons[1] = true; handleButtonPress(1); }
void b2Press() { buttons[2] = true; handleButtonPress(2); }
void b3Press() { buttons[3] = true; handleButtonPress(3); }
void b4Press() { buttons[4] = true; handleButtonPress(4); }
void b5Press() { buttons[5] = true; handleButtonPress(5); }
void b6Press() { buttons[6] = true; handleButtonPress(6); }
void b7Press() { buttons[7] = true; handleButtonPress(7); }
void b8Press() { buttons[8] = true; handleButtonPress(8); }
void b9Press() { buttons[9] = true; handleButtonPress(9); }

void b0Release() {buttons[0] = false; handleButtonRelease(); }
void b1Release() {buttons[1] = false; handleButtonRelease(); }
void b2Release() {buttons[2] = false; handleButtonRelease(); }
void b3Release() {buttons[3] = false; handleButtonRelease(); }
void b4Release() {buttons[4] = false; handleButtonRelease(); }
void b5Release() {buttons[5] = false; handleButtonRelease(); }
void b6Release() {buttons[6] = false; handleButtonRelease(); }
void b7Release() {buttons[7] = false; handleButtonRelease(); }
void b8Release() {buttons[8] = false; handleButtonRelease(); }
void b9Release() {buttons[9] = false; handleButtonRelease(); }
*/
void handleButtonPress(final int n){
  // print("receiving " + n);

  if (reticle != null) { 
    reticle.trigger();
  }
}

void handleButtonRelease(final int n){ }
