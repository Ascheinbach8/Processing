// CS 3451 Spring 2013 Homework 1 
// main program file

void setup() {
  size(360, 360,P3D);
  colorMode(RGB, 255);
  background(0, 0, 0);
}

void draw() {
  // inner loop for drawing
  // unused in this program because we only want to draw based on user input
}

void keyPressed() {
  if ((key >= '0') && (key <= '9')) { gtClear(0, 0, 0); }
  if (key == '1') { line_test(); }
  if (key == '2') { ortho_test(); }
  if (key == '3') { face_test(); }
  if (key == '4') { faces(); }
  if (key == '5') { ortho_cube(); }
  if (key == '6') { cube_no_clip(); }
  if (key == '7') { cube_clip_near(); }
  if (key == '8') { cube_clip_far(); }
  if (key == '9') { ortho_axes(); }
  if (key == '0') { persp_axes(); }
  //println("k="+key+" kc="+keyCode);
}

void mousePressed() {
  if (mouseButton == LEFT) { println("you left clicked pixel ("+mouseX+", "+mouseY+")"); }
}


/* the test cases are below */


/******************************************************************************
Draw some random lines.
******************************************************************************/

void line_test()
{
  int i;
  float x0,y0,x1,y1;

  gtInitialize();
  
  /* draw a bunch of random lines */

  for (i = 0; i < 200; i++) {
    x0 = random(-120, 480);
    y0 = random(-120, 480);
    x1 = random(-120, 480);
    y1 = random(-120, 480);
/*    x0 = random(0, 360);
    y0 = random(0, 360);
    x1 = random(0, 360);
    y1 = random(0, 360);*/
    draw_line (x0, y0, x1, y1);
  }
}


/******************************************************************************
Test the orthographic projection routine.
******************************************************************************/

void ortho_test()
{
  float nnear = -10.0;
  float ffar = 40.0;

  gtInitialize();

  gtOrtho (-100.0, 100.0, -100.0, 100.0, nnear, ffar);

  gtBeginShape (GT_LINES);

  /* three axes */

  gtVertex (0.0, 0.0, 0.0);
  gtVertex (50.0, 0.0, 0.0);

  gtVertex (0.0, 0.0, 0.0);
  gtVertex (0.0, 50.0, 0.0);

 gtVertex (0.0, 0.0, 0.0);
  gtVertex (0.0, 0.0, 50.0);

  /* test clipping */

 gtVertex (0.0, 25.0, 30.0);
  gtVertex (50.0, 25.0, -50.0);

  /* a square */

  gtVertex (-10.0, -10.0, 0.0);
  gtVertex (-90.0, -10.0, 0.0);

  gtVertex (-90.0, -10.0, 0.0);
  gtVertex (-90.0, -90.0, 0.0);

  gtVertex (-90.0, -90.0, 0.0);
  gtVertex (-10.0, -90.0, 0.0);

  gtVertex (-10.0, -90.0, 0.0);
  gtVertex (-10.0, -10.0, 0.0);

  gtEndShape();
}


/******************************************************************************
Draw a cube.
******************************************************************************/

void cube()
{
  gtBeginShape (GT_LINES);

  /* top square */

  gtVertex (-1.0, -1.0,  1.0);
  gtVertex (-1.0,  1.0,  1.0);

  gtVertex (-1.0,  1.0,  1.0);
  gtVertex ( 1.0,  1.0,  1.0);

  gtVertex ( 1.0,  1.0,  1.0);
  gtVertex ( 1.0, -1.0,  1.0);

  gtVertex ( 1.0, -1.0,  1.0);
  gtVertex (-1.0, -1.0,  1.0);

  /* bottom square */

  gtVertex (-1.0, -1.0, -1.0);
  gtVertex (-1.0,  1.0, -1.0);

  gtVertex (-1.0,  1.0, -1.0);
  gtVertex ( 1.0,  1.0, -1.0);

  gtVertex ( 1.0,  1.0, -1.0);
  gtVertex ( 1.0, -1.0, -1.0);

  gtVertex ( 1.0, -1.0, -1.0);
  gtVertex (-1.0, -1.0, -1.0);

  /* connect top to bottom */

  gtVertex (-1.0, -1.0, -1.0);
  gtVertex (-1.0, -1.0,  1.0);

  gtVertex (-1.0,  1.0, -1.0);
  gtVertex (-1.0,  1.0,  1.0);

  gtVertex ( 1.0,  1.0, -1.0);
  gtVertex ( 1.0,  1.0,  1.0);

  gtVertex ( 1.0, -1.0, -1.0);
  gtVertex ( 1.0, -1.0,  1.0);

  gtEndShape();
}


/******************************************************************************
Orthographic cube.
******************************************************************************/

void ortho_cube()
{
  gtInitialize();
    
  gtOrtho (-2.0, 2.0, -2.0, 2.0, 0.0, 10000.0);

  gtPushMatrix();
  gtTranslate (0.0, 0.0, -4.0);
  cube();
  gtPopMatrix();
}


/******************************************************************************
Pespective cube, no clipping.
******************************************************************************/

void cube_no_clip()
{
  gtInitialize();
    
  gtPerspective (60.0, 0.001, 10000.0);

  gtPushMatrix();
  gtTranslate (0.0, 0.0, -4.0);
  cube();
  gtPopMatrix();
}


/******************************************************************************
Pespective cube, clipped at near end.
******************************************************************************/

void cube_clip_near()
{
  gtInitialize();
  gtPerspective (60.0, 3.5, 10000.0);

  gtPushMatrix();
  gtTranslate (0.0, 0.0, -4.0);
  cube();
  gtPopMatrix();
}


/******************************************************************************
Pespective cube, clipped at far end.
******************************************************************************/

void cube_clip_far()
{
  gtInitialize();
  gtPerspective (60.0, 2.0, 4.8);

  gtPushMatrix();
  gtTranslate (0.0, 0.0, -4.0);
  cube();
  gtPopMatrix();
}


/******************************************************************************
Draw X, Y, Z axes.
******************************************************************************/

void axes()
{
  /* x, y, and z axes */

  gtBeginShape (GT_LINES);

  gtVertex (0.0, 0.0, 0.0);
  gtVertex (50.0, 0.0, 0.0);

  gtVertex (0.0, 0.0, 0.0);
  gtVertex (0.0, 50.0, 0.0);

  gtVertex (0.0, 0.0, 0.0);
  gtVertex (0.0, 0.0, 50.0);

  gtEndShape();

  /* the letter X */

  gtPushMatrix();

  gtTranslate (60.0, 0.0, 0.0);
  gtScale (5.0, 5.0, 5.0);

  gtBeginShape (GT_LINES);
  gtVertex (1.0, 1.0, 0.0);
  gtVertex (-1.0, -1.0, 0.0);
  gtVertex (1.0, -1.0, 0.0);
  gtVertex (-1.0, 1.0, 0.0);
  gtEndShape();

  gtPopMatrix();

  /* the letter Y */

  gtPushMatrix();

  gtTranslate (0.0, 60.0, 0.0);
  gtScale (5.0, 5.0, 5.0);

  gtBeginShape (GT_LINES);
  gtVertex (1.0, 1.0, 0.0);
  gtVertex (0.0, 0.0, 0.0);
  gtVertex (-1.0, 1.0, 0.0);
  gtVertex (0.0, 0.0, 0.0);
  gtVertex (0.0, 0.0, 0.0);
  gtVertex (0.0, -1.0, 0.0);
  gtEndShape();

  gtPopMatrix();

  /* the letter Z */

  gtPushMatrix();

  gtTranslate (0.0, 0.0, 60.0);
  gtScale (5.0, 5.0, 5.0);

  gtBeginShape (GT_LINES);
  gtVertex (1.0, 1.0, 0.0);
  gtVertex (-1.0, -1.0, 0.0);
  gtVertex (-1.0, 1.0, 0.0);
  gtVertex (1.0, 1.0, 0.0);
  gtVertex (-1.0, -1.0, 0.0);
  gtVertex (1.0, -1.0, 0.0);
  gtEndShape();

  gtPopMatrix();

  /* three cubes along the -z axis */

  gtPushMatrix();
  gtTranslate (0.0, 0.0, -100.0);
  gtScale (10.0, 10.0, 10.0);
  cube();
  gtPopMatrix();

  gtPushMatrix();
  gtTranslate (0.0, 0.0, -200.0);
  gtScale (10.0, 10.0, 10.0);
  cube();
  gtPopMatrix();

  gtPushMatrix();
  gtTranslate (0.0, 0.0, -400.0);
  gtScale (10.0, 10.0, 10.0);
  cube();
  gtPopMatrix();
}


/******************************************************************************
Draw axes orthographically.
******************************************************************************/

void ortho_axes()
{
  gtInitialize();
  gtOrtho (-100.0, 100.0, -100.0, 100.0, -1000.0, 1000.0);

  gtPushMatrix();
  gtRotate (45.0, 1.0, -1.0, 0.0);
  gtTranslate (-100.0, -100.0, -150.0);
  axes();
  gtPopMatrix();
}


/******************************************************************************
Draw axes in perspective.
******************************************************************************/

void persp_axes()
{
  gtInitialize();
  gtPerspective (60.0, 1.0, 1000.0);

  gtPushMatrix();
  gtRotate (45.0, 1.0, -1.0, 0.0);
  gtTranslate (-100.0, -100.0, -150.0);
  axes();
  gtPopMatrix();
}


/******************************************************************************
Draw a circle of unit radius.
******************************************************************************/

void circle()
{
  int i;
  float theta;
  float x0,y0,x1,y1;
  float steps = 50;

  gtBeginShape (GT_LINES);

  x0 = 1.0;
  y0 = 0.0;
  for (i = 0; i <= steps; i++) {
    theta = 2 * 3.1415926535 * i / steps;
    x1 = cos (theta);
    y1 = sin (theta);
    gtVertex (x0, y0, 0.0);
    gtVertex (x1, y1, 0.0);
    x0 = x1;
    y0 = y1;
  }

  gtEndShape();
}


/******************************************************************************
Draw a face.
******************************************************************************/

void face()
{
  /* head */

  gtPushMatrix();
  gtTranslate (0.5, 0.5, 0.0);
  gtScale (0.4, 0.4, 1.0);
  circle();
  gtPopMatrix();

  /* right eye */

  gtPushMatrix();
  gtTranslate (0.7, 0.7, 0.0);
  gtScale (0.1, 0.1, 1.0);
  circle();
  gtPopMatrix();

  /* left eye */

  gtPushMatrix();
  gtTranslate (0.3, 0.7, 0.0);
  gtScale (0.1, 0.1, 1.0);
  circle();
  gtPopMatrix();

  /* nose */

  gtPushMatrix();
  gtTranslate (0.5, 0.5, 0.0);
  gtScale (0.07, 0.07, 1.0);
  circle();
  gtPopMatrix();

  /* mouth */

  gtPushMatrix();
  gtTranslate (0.5, 0.25, 0.0);
  gtScale (0.2, 0.1, 1.0);
  circle();
  gtPopMatrix();
}


/******************************************************************************
Test the matrix stack by drawing a face.
******************************************************************************/

void face_test()
{
  float nnear = -10.0;
  float ffar = 100000.0;

  gtInitialize ();

  gtOrtho (0.0, 1.0, 0.0, 1.0, nnear, ffar);

  face();
}


/******************************************************************************
Draw four faces.
******************************************************************************/

void faces()
{
  float nnear = -10.0;
  float ffar = 100000.0;

  gtInitialize ();

  gtOrtho (0.0, 1.0, 0.0, 1.0, nnear, ffar);

  gtPushMatrix();
  gtTranslate (0.75, 0.25, 0.0);
  gtScale (0.5, 0.5, 1.0);
  gtTranslate (-0.5, -0.5, 0.0);
  face();
  gtPopMatrix();

  gtPushMatrix();
  gtTranslate (0.25, 0.25, 0.0);
  gtScale (0.5, 0.5, 1.0);
  gtTranslate (-0.5, -0.5, 0.0);
  face();
  gtPopMatrix();

  gtPushMatrix();
  gtTranslate (0.75, 0.75, 0.0);
  gtScale (0.5, 0.5, 1.0);
  gtTranslate (-0.5, -0.5, 0.0);
  face();
  gtPopMatrix();

  gtPushMatrix();
  gtTranslate (0.25, 0.75, 0.0);
  gtScale (0.5, 0.5, 1.0);
  gtRotate (30.0, 0.0, 0.0, 1.0);
  gtTranslate (-0.5, -0.5, 0.0);
  face();
  gtPopMatrix();
}
