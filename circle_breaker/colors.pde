/// Color cycles
void load_colors() {
  for (int n=0; n < MAX_COLORS; n++) { 
    COLORS[n] = cur.get((int)random(cur.width), (int)random(cur.height));
  }
}

/// Color cycle, ordered by value
void load_colors_by_value() {
  for (int n=0; n < MAX_VALUED_COLORS; n++) { 
    VALUED_COLORS[n] = cur.get((int)random(cur.width), (int)random(cur.height));
  }
  sort_valued_colors();
}

// memoized color value lookup, not sure if this is faster
HashMap valued_colors = new HashMap(MAX_VALUED_COLORS * 2);
int get_color_value(color colr) {
  String cv = colr + "";
  if (!valued_colors.containsKey(colr + "")) {
    int r = (colr >> 16) & 0xFF;  // Faster way of getting red(argb)
    int g = (colr >> 8) & 0xFF;   // Faster way of getting green(argb)
    int b =  colr & 0xFF;          // Faster way of getting blue(argb)

    valued_colors.put(colr + "", r + g + b);
  }
  return Integer.parseInt(valued_colors.get(cv).toString());
}

// BUBBLESORT, lol
// arrange colors in order according to composite value
void sort_valued_colors() {
  color tmp;
  for (int a=0; a < MAX_VALUED_COLORS; a++) {
    for (int b=0; b < MAX_VALUED_COLORS - 1; b++) {
      // < is high-to-low, > is low-to-high
      if (get_color_value(VALUED_COLORS[b]) < get_color_value(VALUED_COLORS[b + 1])) {
        // swap
        tmp = VALUED_COLORS[b];
        VALUED_COLORS[b] = VALUED_COLORS[b + 1];
        VALUED_COLORS[b + 1] = tmp;
      }
    }
  }
}

// run through list of random colors
color next_color() {
  // CURRENT_COLOR is index into COLORS
  CURRENT_COLOR = (CURRENT_COLOR + 1) % MAX_COLORS;
  return COLORS[CURRENT_COLOR];
}

// run through list of colors in an orderly fashion
color next_color(int level) {
  // println( (level % MAX_COLORS) + " of " + MAX_COLORS ); 
  return VALUED_COLORS[level % MAX_COLORS];
}
