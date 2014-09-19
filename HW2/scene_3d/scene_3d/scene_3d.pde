// 3D Scene Example

import processing.opengl.*;

float time = 0;  // keep track of passing of time

void setup() {
  size(400, 400, OPENGL);  // must use OPENGL here !!!
  noStroke();     // do not draw the edges of polygons
}

// Draw a scene with a cylinder, a sphere and a box
void draw() {
  
  resetMatrix();  // set the transformation matrix to the identity (important!)

  background(0);  // clear the screen to black
  
  // set up for perspective projection
  perspective (PI * 0.333, 1.0, 0.01, 1000.0);
  
  // place the camera in the scene (just like gluLookAt())
  camera (0.0, 0.0, 80.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
  
  scale (1.0, -1.0, 1.0);  // change to right-handed coordinate system
  
  // create an ambient light source
  ambientLight(102, 102, 102);
  
  // create two directional light sources
  lightSpecular(204, 204, 204);
  directionalLight(102, 102, 102, -0.7, -0.7, -1);
  directionalLight(152, 152, 152, 0, 0, -1);
  
  // Draw a cylinder
    
  pushMatrix();

  // diffuse (fill), ambient and specular material properties
  fill(200, 100, 100);       // "fill" sets both diffuse and ambient color (yuck!)
  ambient (50, 50, 50);      // set ambient color
  specular(150, 150, 150);   // set specular color
  shininess(5.0);            // set specular exponent
  
  translate(-30, 0, 0);
  rotate (time, 1.0, 0.0, 0.0);      // rotate based on "time"
  translate (0.0, -10.0, 0.0);
  cylinder(10.0, 20.0, 32);
  
  popMatrix();
  
  // Draw a sphere
  
  pushMatrix();

  fill(100, 200, 100);
  ambient (50, 50, 50);
  specular(155, 155, 155);
  shininess(15.0);
  
  sphereDetail (40);
  sphere(13);

  popMatrix();
 
  // Draw a box
  
  pushMatrix();

  fill(100, 100, 200);
  ambient (100, 100, 200);
  specular(0, 0, 0);
  shininess(1.0);
  
  translate(30, 0, 0);
  rotate (-time, 1.0, 0.0, 0.0);
  box(20);
  
  popMatrix();
 
  // step forward in time
  time += 0.05;
}

// Draw a cylinder of a given radius, height and number of sides.
// The base is on the y=0 plane, and it extends vertically in the y direction.
void cylinder (float radius, float height, int sides) {
  int i,ii;
  float []c = new float[sides];
  float []s = new float[sides];

  for (i = 0; i < sides; i++) {
    float theta = TWO_PI * i / (float) sides;
    c[i] = cos(theta);
    s[i] = sin(theta);
  }
  
  // bottom end cap
  
  normal (0.0, -1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (0.0, 0.0, 0.0);
    endShape();
  }
  
  // top end cap

  normal (0.0, 1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    vertex (0.0, height, 0.0);
    endShape();
  }
  
  // main body of cylinder
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape();
    normal (c[i], 0.0, s[i]);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    normal (c[ii], 0.0, s[ii]);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    endShape(CLOSE);
  }
}

