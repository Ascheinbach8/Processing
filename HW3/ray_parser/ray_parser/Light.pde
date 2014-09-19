class Light {
  float red, green, blue, xPos, yPos, zPos;
  PVector location;
  Light(float r, float g, float b, float x, float y, float z) {
    red = r;
    green = g;
    blue = b;
    xPos = x;
    yPos = y;
    zPos = z;
    location = new PVector(x, y, z);
  }

  PVector getVector() {
    return location;
  }
  
  Color getColor() {
    return new Color(red,green,blue);
  }
}
