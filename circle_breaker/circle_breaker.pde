/***
 * Circle Breaker - a color explosion toy
 *
 * TODO:
 * - get rid of bounding box
 * - improve explosion chain efficiency
 * - allow multiple "modes". e.g., 'negative SHRINK',
 *
 **/
import procontroll.*;
import net.java.games.input.*;

boolean DEBUG_MODE = false;
int MAXDOTS = 850;

float[] SPEED = new float[] {.5, 3};
Dot[] dots = new Dot[MAXDOTS];

int MAX_EXPLOSION_ROOTS = 30;     // explosion chains
int NEXT_EXPLOSION_ROOT = 0;
float MAXEXPL = 60;
float SHRINK = 3; // each propagated explosion will be SHRINK pixels smaller
Explosion[] explosion_roots = new Explosion[MAX_EXPLOSION_ROOTS];

boolean BOUNDING_BOX = false;
float bboxx, bboxy, bboxh, bboxw;
float bbox_ratio = 0.90;

// Image
final int MAX_COLORS = 10;
int CURRENT_COLOR = 0;
color[] COLORS = new color[MAX_COLORS];

final int MAX_VALUED_COLORS = 20;
color[] VALUED_COLORS = new color[MAX_VALUED_COLORS];
PImage cur;

// flower, flower-2, hillside, mountains (.jpg)
String image = "hillside.jpg";

void setup() {
  if (DEBUG_MODE) {
    size(400, 400, P2D);
  } else {
    size(1100, 700, P2D);
  }
  frameRate(24);
  //smooth();

  for (int f=0;f<MAXDOTS;f++) {
    dots[f] = new Dot();
    dots[f].launch();
  }

  PFont font;
  font = loadFont("comic.vlw");
  textFont(font, 40);
  // font = loadFont("LucidaSans-11.vlw");
  // textFont(font, 11);
  if (BOUNDING_BOX) {
    bboxh = height * bbox_ratio;
    bboxw = width * bbox_ratio;
    bboxx = (width - bboxw) / 2;
    bboxy = (height - bboxh) / 2;
  }

  cur = loadImage(image);
  load_colors_by_value();

  /// Startup control pad, attach handlers, etc.
  initControlPad();
}

int MAXCHAIN = 0, NEWCHAIN = 0, MINEXPL = (int)MAXEXPL, MINCHAIN = 1000;
boolean DONE = false;

void draw() {
  // if (DONE) {
  //   frameRate(10);
  //   noStroke();
  //   fill(255);
  //   text("GAME OVER", width/2, height/2);
  //   text("Max chain: " + Integer.toString(MAXCHAIN), width/2, height/2 + 10);
  //   text("Max propagation: " + Float.toString((MAXEXPL-MINEXPL)/SHRINK), width/2, height/2 + 20);
  //   fill(0, 10);
  //   rect(0,0,width,height);
  //   noLoop();
  // }
  // else {
  //   background(0);
  // }

  background(0);

  int dotcount = 0;
  for (int f=0;f<MAXDOTS;f++) {
    Dot d = dots[f];
    if (d.launched) {
      if (d.update()) {
        d.drawme();
        dotcount++;
      }
    }
    else if (random(0, 1) > .95) {
      d.launch();
      dotcount++;
    }
  }

  Explosion current_explosion;
  boolean is_active;
  for (int ers=0; ers < explosion_roots.length; ers++) {
    current_explosion = explosion_roots[ers];
    if (current_explosion != null) {
      is_active = current_explosion.update();
      if (is_active) {
        current_explosion.drawme();
      }
      else {
        current_explosion.destroy();
        explosion_roots[ers] = null;
      }
    }
  }

  printScore();

  if (BOUNDING_BOX) {
    stroke(100);
    noFill();
    rect(bboxx, bboxy, bboxw, bboxh);
  }

  if (reticle != null) {
    reticle.update();
    reticle.drawme();
  }
}

void printScore() {

  // Simple scores
  fill(0, 255, 153);
  text(MAXCHAIN, 40, height / 10);
  text(MINCHAIN, width - 90, height / 10);
  fill(200);
  text(NEWCHAIN, 40, height / 10 + 40);

  /** Complex scores (only works with smaller font)
  text(MINCHAIN, 40, height - 10);
  text(MAXCHAIN, 0, height - 10);

  text(NEWCHAIN, 0, height - 20);
  fill(100);
  text(dotcount, 0, height - 30);
  fill(100);
  text((MAXEXPL-MINEXPL)/SHRINK, 0, height - 40);
  */
}

void StartExplosion(float x, float y) {
  if (!BOUNDING_BOX || (x>bboxx && x<bboxx + bboxw && y>bboxy && y < bboxy + bboxh)) {
    // load_colors(); // random color list
    load_colors_by_value(); // sorted color list

    // record scores
    if (NEWCHAIN > 1) MINCHAIN = NEWCHAIN < MINCHAIN ? NEWCHAIN : MINCHAIN;
    MAXCHAIN = NEWCHAIN > MAXCHAIN ? NEWCHAIN : MAXCHAIN;

    // start explosion chain
    NEWCHAIN = 1;
    Explosion e = new Explosion(x, y, MAXEXPL, 0);
    explosion_roots[NEXT_EXPLOSION_ROOT] = e;
    NEXT_EXPLOSION_ROOT = (NEXT_EXPLOSION_ROOT + 1) % MAX_EXPLOSION_ROOTS;
  }

  println("roots: " + count_active_roots());
}

int count_active_roots() {
  int count = 0;
  for (int i=0; i < MAX_EXPLOSION_ROOTS; i++) {
    if (explosion_roots[i] != null && explosion_roots[i].isActive()) {
      count++;
    }
  }
  return count;
}

void mousePressed() {
  StartExplosion(mouseX, mouseY);
}

