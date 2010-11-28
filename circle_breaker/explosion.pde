int MAX_NEIGHBORS = 30;
class Explosion {
  float x, y, l, r, t, b;
  float rad = .5, maxrad;
  int level;
  int next_neighbor, active_neighbors;

  Explosion[] connections = new Explosion[MAX_NEIGHBORS];
  Explosion parent = null;
  boolean drawable = true;
  color my_color;

  Explosion(float _x,float _y,float _maxrad, int _level) {
    // println("explosion (" + _x + ", " + _y + ") at level " + _level);
    x = _x;
    y = _y;
    maxrad = _maxrad;
    level = _level;
    my_color = next_color(level);
    next_neighbor = 0;
    active_neighbors = 0;
  }

  boolean isActive() {
    if (drawable) {
      return true;
    } else if (active_neighbors > 0) {
      return true;
    } else {
      boolean active_decendants = false;
      for (int d=0; d<next_neighbor; d++) {
        active_decendants = active_decendants || connections[d].isActive();
      }
      return active_decendants;
    }
  }

  boolean update() {
    // update myself and all my downstream connections
    if (!drawable) {
      update_connections();
      return isActive();
    }

    rad += 3;
    l = x - rad;
    r = x + rad;
    t = y - rad;
    b = y + rad;
    if (rad > maxrad) {
      drawable = false;
      if (parent != null) parent.active_neighbors--;
      update_connections();
      return isActive();
    }

    update_connections();

    // each explosion examines every dot. eek.
    float da, db, dc;
    for (int f=0;f<MAXDOTS;f++) {
      Dot d = dots[f];
      if (d.launched) {
        // examine the bounding box
        if (r < d.l || l > d.r || b < d.t || t > d.b) {// ||)
          continue;
        }

        // then check actual distance
        da = (x-d.x);
        db = (y-d.y);
        dc = d.rad + rad;
        if ((da * da + db * db) < (dc * dc)) {
          NEWCHAIN += 1;
          // spread
          Explosion e = new Explosion(d.x, d.y, maxrad - SHRINK, level + 1);

          // add self to child
          e.parent = this;

          // add child to self
          connections[next_neighbor] = e;

          next_neighbor = (next_neighbor + 1) % MAX_NEIGHBORS;
          active_neighbors++;

          // dot we hit reverts to pre-launch state
          d.launched = false;
        }
      }
    }
    return isActive();
  }

  private void update_connections() {
    for (int n=0; n < next_neighbor; n++) {
      connections[n].update();
    }
  }

  private void draw_connections() {
    for (int n=0; n < next_neighbor; n++) {
      connections[n].drawme();
    }
  }

  void drawme() {
    noStroke();
    noFill();
    if (drawable) {
      fill(my_color, 120);
      ellipse(x , y, rad*2, rad*2);
    }

    stroke(255);
    for (int i=0; i < next_neighbor; i++) {
      Explosion e = connections[i];
      line(x, y, e.x, e.y);
    }

    draw_connections();
  }

  void destroy() {
    for (int d=0; d<next_neighbor; d++) {
      Explosion next = connections[d];
      next.destroy();
      connections[d] = null;
    }
  }
}
