class Sphere extends RayShape {
  Color diffuse, ambient, specular;
  float phong, krelf;  
  float xPos, yPos, zPos, radius;
  PVector center, PVec;
  float t;
  Sphere(float x, float y, float z, float r, Color d, Color a, Color s, float P, float K) {
    xPos = x;
    yPos = y;
    zPos = z;
    radius = r;

    diffuse = d;
    ambient = a;
    specular = s;
    phong = P;
    krelf = K;
    center = new PVector(xPos, yPos, zPos);
    PVec=new PVector(0,0,0);
  }
  float intercepts(Ray currRay) {
    PVector O = currRay.origin;
    PVector R = currRay.direction;

    PVector C = new PVector(center.x, center.y, center.z);

    float a = dotProduct(R, R); //R dot R
    PVector CO = new PVector(O.x - C.x, O.y - C.y, O.z - C.z);
    float b = 2*dotProduct(R, CO);
    float c = dotProduct(CO, CO)-pow(radius, 2);
    if (pow(b, 2)-(4*a*c)< 0) //If NaN
      return -1;
    else {
      float tpos = ((-1*b)+sqrt(pow(b, 2)-(4*a*c)))/(2*a);
      float tneg = ((-1*b)-sqrt(pow(b, 2)-(4*a*c)))/(2*a);
      float t=0;   

      if (tpos>tneg) t=tneg;
      if (tneg<0) t=tpos;

      PVector rt = PVector.mult(R,t);
      PVec = PVector.add(O, rt); // Point of Collision
      return t;
    }
  }
  PVector getNormal() {
    return new PVector(PVec.x - center.x, PVec.y - center.y, PVec.z - center.z); // Center ->Surface
  }

  Color getDiffuse() {
    return new Color(diffuse.getRed(), diffuse.getGreen(), diffuse.getBlue());
  }

  Color getAmbient() {
    return new Color(ambient.getRed(), ambient.getGreen(), ambient.getBlue());
  }

  Color getSpecular() {
    return new Color(specular.getRed(), specular.getGreen(), specular.getBlue());
  }
  
  PVector getP(){
    return PVec;
  }
  
  float getPhong(){
    return phong;
  }
  float getKrelf(){
    return krelf;
  }
}

