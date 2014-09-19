// CS 3451 Spring 2013 Homework 1
// provided line drawing and line clipping routines


/* helper class for passing a pair of floats in and out of a function */
class xy {
  float x, y;
  xy (float xx, float yy) { x = xx;  y = yy; }
}

/* helper class for passing a triplet of floats in and out of a function */
class xyz {
  float x, y, z;
  xyz (float xx, float yy, float zz) { x = xx;  y = yy;  z = zz; }
}


/* the clipping window */
static float xmin = 0.0;
static float xmax = 1.0;
static float ymin = 0.0;
static float ymax = 1.0;

//static void set_clip_window(float, float, float, float);
//static int clip_line(float *, float *, float *, float *);


/******************************************************************************
Draw a white line.

Entry:
  x0,y0 - first endpoint of line
  x1,y1 - second line endpoint
******************************************************************************/

void draw_line(float x0, float y0, float x1, float y1)
{
  int i;
  float x,y;
  float dx,dy;
  float xinc,yinc;
  float len;  // length
  int result;
  xy xy0 = new xy(x0, y0);
  xy xy1 = new xy(x1, y1);
  //int width,height;

  /* set the clipping window */
  //gtGetFramebufferSize (&width, &height);
  set_clip_window (0.0, 0.0, width - 0.51, height - 0.51);

  /* clip the line in 2D */
  //result = clip_line (&x0, &y0, &x1, &y1);
  result = clip_line (xy0, xy1);
  x0 = xy0.x;  y0 = xy0.y;
  x1 = xy1.x;  y1 = xy1.y;

  /* return if line is entirely outside the clip window */
  if (result == 0)
    return;

  /* incremental line drawing */

  dx = x1 - x0;
  dy = y1 - y0;

  /* determine whether horizontal or vertical change is larger */

  if (abs(dx) > abs(dy))
    len = abs(dx);
  else
    len = abs(dy);

  /* special case to avoid dividing by zero */

  if (len == 0) {
    loadPixels();
    gtWritePixel (int(floor(x0+0.5)), int(floor(y0+0.5)), 255, 255, 255);
    updatePixels();
    return;
  }

  xinc = dx / len;
  yinc = dy / len;

  x = x0;
  y = y0;

  /* write "len" number of pixels along the line */

  loadPixels();
  for (i = 0; i <= len; i++) {
    gtWritePixel (int(floor(x+0.5)), int(floor(y+0.5)), 255, 255, 255);
    x += xinc;
    y += yinc;
  }

  updatePixels();
}


/******************************************************************************
Specify a clipping window.

Entry:
  x0,y0 - lower left boundaries of clipping window
  x1,y1 - upper right boundaries
******************************************************************************/

static void set_clip_window(float x0, float y0, float x1, float y1)
{
  xmin = x0;
  ymin = y0;

  xmax = x1;
  ymax = y1;
}


/******************************************************************************
Given a point P outside the window and the rise and run of a line, return
the intersection of line with window that is nearest P.

Entry:
  dx,dy - run and rise of line
  x,y   - the given point P

Exit:
  i.x,i.y - intersection point
  return 1 if there was a valid intersection, 0 if not
******************************************************************************/

static int clip_helper(
  float dx,
  float dy,
  float x,
  float y,
  xy i
)
{
  /* if line not vertical, check against left and right edges of window */

  if (dx != 0) {

    /* check against left edge */
    i.y = dy / dx * (xmin - x) + y;
    if (xmin > x && i.y > ymin && i.y < ymax) {
      i.x = xmin;
      return (1);
    }

    /* check against right edge */
    i.y = dy / dx * (xmax - x) + y;
    if (xmax < x && i.y > ymin && i.y < ymax) {
      i.x = xmax;
      return (1);
    }
  }

  /* if line not horizontal, check against top and bottom edges of window */

  if (dy != 0) {

    /* check against bottom edge */
    i.x = dx / dy * (ymin - y) + x;
    if (ymin > y && i.x > xmin && i.x < xmax) {
      i.y = ymin;
      return (1);
    }

    /* check against top edge */
    i.x = dx / dy * (ymax - y) + x;
    if (ymax < y && i.x > xmin && i.x < xmax) {
      i.y = ymax;
      return (1);
    }
  }

  /* if we get here, we found no intersection */
  return (0);
}


/******************************************************************************
Clip a line segment to a pre-specified window.

Entry:
  c0.x,c0.y - first line segment endpoint
  c1.x,c1.y - second endpoint

Exit:
  c0.x,c0.y,c1.x,c1.y  - clipped endpoint positions
  returns 1 if segment is at least partially in window,
  returns 0 if segment is entirely outside window
******************************************************************************/

/*static*/ int clip_line(xy c0, xy c1)
{
  int count;
  float dx,dy;
  float xx0 = c0.x;
  float yy0 = c0.y;
  float xx1 = c1.x;
  float yy1 = c1.y;
  xy xy0 = new xy(0, 0);
  xy xy1 = new xy(0, 0);

  int code04 = (xx0 < xmin) ? 1 : 0;
  int code03 = (xx0 > xmax) ? 1 : 0;
  int code02 = (yy0 < ymin) ? 1 : 0;
  int code01 = (yy0 > ymax) ? 1 : 0;

  int code14 = (xx1 < xmin) ? 1 : 0;
  int code13 = (xx1 > xmax) ? 1 : 0;
  int code12 = (yy1 < ymin) ? 1 : 0;
  int code11 = (yy1 > ymax) ? 1 : 0;

  int sum0 = code01 + code02 + code03 + code04;
  int sum1 = code11 + code12 + code13 + code14;

  /* completely inside window? */
  if (sum0 == 0 && sum1 == 0)
    return (1);

  /* check for trivial invisibility (both endpoints on wrong side of */
  /* a single side of the window) */

  if (((code01 == 1) && (code11 == 1)) || ((code02 == 1) && (code12 == 1)) ||
      ((code03 == 1) && (code13 == 1)) || ((code04 == 1) && (code14 == 1))) {
    return (0);
  }

  /* compute run and rise */
  dx = xx1 - xx0;
  dy = yy1 - yy0;

  /* case: only x0,y0 is inside window */
  if (sum0 == 0) {
    xy1.x = xx1;
    xy1.y = yy1;
    int dummy = clip_helper (dx, dy, xx1, yy1, xy1);
    c0.x = xx0;
    c0.y = yy0;
    c1.x = xy1.x;
    c1.y = xy1.y;
    return (1);
  }

  /* case: only x1,y1 is inside window */
  if (sum1 == 0) {
    xy0.x = xx0;
    xy0.y = yy0;
    int dummy = clip_helper (dx, dy, xx0, yy0, xy0);
    c0.x = xy0.x;
    c0.y = xy0.y;
    c1.x = xx1;
    c1.y = yy1;
    return (1);
  }

  /* neither endpoint is inside the window */

  xy0.x = xx0;
  xy0.y = yy0;
  xy1.x = xx1;
  xy1.y = yy1;
  count = 0;
  count += clip_helper (dx, dy, xx0, yy0, xy0);
  count += clip_helper (dx, dy, xx1, yy1, xy1);

  c0.x = xy0.x;
  c0.y = xy0.y;
  c1.x = xy1.x;
  c1.y = xy1.y;

  if (count > 0)
    return (1);
  else
    return (0);
}


/******************************************************************************
Clip a line segment to front and back clipping planes.  These clip planes
are along the z-axis.  If your objects are on the negative z portion of
the axis, be sure to specify negative values for "near" and "far".

Entry:
  near,far - clip planes along z-axis
  p0.x,p0.y,p0.z - first line segment endpoint
  p1.x,p1.y,p1.z - second endpoint

Exit:
  p0.x,p0.y,p0.z,p1.x,p1.y,p1.z - clipped endpoint positions
  returns 1 if segment is at least partially in window,
  returns 0 if segment is entirely outside window
******************************************************************************/

int near_far_clip(
  float nnear,
  float ffar,
  xyz p0,
  xyz p1
)
{
  float temp;
  float fract;
  float xx0 = p0.x;
  float yy0 = p0.y;
  float zz0 = p0.z;
  float xx1 = p1.x;
  float yy1 = p1.y;
  float zz1 = p1.z;
  int code00,code01,code10,code11;

  /* make sure near < far */

  if (nnear > ffar) {
    temp = ffar;
    ffar = nnear;
    nnear = temp;
  }

  /* figure out which endpoints are outside the clipping volume */

  code00 = (zz0 < nnear) ? 1 : 0;
  code01 = (zz0 > ffar)  ? 1 : 0;
  code10 = (zz1 < nnear) ? 1 : 0;
  code11 = (zz1 > ffar)  ? 1 : 0;

  /* return without clipping if all endpoints are inside clip volume */

  if (code00 + code01 + code10 + code11 == 0)
    return (1);  /* signals inside volume */

  /* if both endpoints are entirely out of clip volume, exit and signal this */

  if (((code00 == 1) && (code10 == 1)) || ((code01 == 1) && (code11 == 1)))
    return (0);  /* signals outside volume */

  /* clip to near plane if necessary */

  if (code00 == 1) {
    fract = (nnear - zz0) / (zz1 - zz0);
    xx0 = xx0 + fract * (xx1 - xx0);
    yy0 = yy0 + fract * (yy1 - yy0);
    zz0 = nnear;
  }
  else if (code10 == 1) {
    fract = (nnear - zz1) / (zz0 - zz1);
    xx1 = xx1 + fract * (xx0 - xx1);
    yy1 = yy1 + fract * (yy0 - yy1);
    zz1 = nnear;
  }

  /* clip to far plane if necessary */

  if (code01 == 1) {
    fract = (ffar - zz0) / (zz1 - zz0);
    xx0 = xx0 + fract * (xx1 - xx0);
    yy0 = yy0 + fract * (yy1 - yy0);
    zz0 = ffar;
  }
  else if (code11 == 1) {
    fract = (ffar - zz1) / (zz0 - zz1);
    xx1 = xx1 + fract * (xx0 - xx1);
    yy1 = yy1 + fract * (yy0 - yy1);
    zz1 = ffar;
  }

  /* copy the clipped endpoints */

  p0.x = xx0;
  p0.y = yy0;
  p0.z = zz0;
  p1.x = xx1;
  p1.y = yy1;
  p1.z = zz1;

  /* signal that we're inside the clip volume */
  return (1);
}
