class RayShape {

  float intercepts(Ray currRay) {
    return -1;
  }

  PVector getNormal() {
    return new PVector(0, 0, 0);
  }

  Color getDiffuse() {
    return new Color(0, 0, 0);
  }

  Color getAmbient() {
    return new Color(0, 0, 0);
  }

  Color getSpecular() {
    return new Color(0, 0, 0);
  }
  PVector getP(){
    return new PVector(0,0,0);
  }
  float getPhong(){
    return 0;
  }
  float getKrelf(){
    return 0;
  }
}

