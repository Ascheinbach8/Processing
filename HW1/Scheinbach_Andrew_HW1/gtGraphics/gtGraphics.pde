// CS 3451 Spring 2013
// provided gt library routines


// declare some enumerated constants
static final int GT_NONE = 0;
static final int GT_POLYGON = 1;
static final int GT_LINES = 2;

void gtClear(float r, float g, float b) {
  color bg = color(r, g, b);  // set rgb background color (with range 0..255 since the colorMode is RGB, 255)
  loadPixels();
  for (int i = 0; i < width * height; i++) { pixels[i] = bg; }
  updatePixels();
}

// assumes loadPixels() has been called before calls to this routine
// assumes updatePixels() will be called after calls to this routine
void gtWritePixel (int x, int y, int r, int g, int b) {
  int index = (height - y - 1) * width + x;
  pixels[index] = color (r, g, b);
}


// the range of each color component here should be the same as in opengl, i.e. 0.0 to 1.0 inclusive
void gtColor3f (float r, float g, float b) {
  // unused
}

void gtVertex2f (float x, float y) {
     // draws a dot at each vertex (change this!)
     loadPixels();
     gtWritePixel (int(x*360), int(y*360), 255, 255, 255);
     updatePixels();
}

