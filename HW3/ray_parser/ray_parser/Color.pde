
class Color {
  float red, green, blue;
  Color(float r, float g, float b) {
    red = r;
    green = g;
    blue = b;
  }
  Color getColor() {
    Color newColor = new Color(red, green, blue);
    return newColor;
  }
  void add(Color newColor) {
    red += newColor.red;
    green += newColor.green;
    blue += newColor.blue;
  }
  
  void multiply(float a){
  red *=a;
  green *=a;
  blue *=a;
  }
  
  float getRed(){return red;}
  float getGreen(){return green;}
  float getBlue(){return blue;}
}

