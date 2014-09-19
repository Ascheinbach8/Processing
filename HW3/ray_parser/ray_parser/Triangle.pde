class Triangle extends RayShape {
  Color diffuse, ambient, specular;
  float phong, krelf;  
  Vertex v1, v2, v3;
  Ray r12, r13, r23;
  PVector Normal, PVec;
  float t;
  Triangle(Vertex one, Vertex two, Vertex three, Color d, Color a, Color s, float P, float K) {
    v1 = one;
    v2 = two;
    v3 = three;
    diffuse = d;
    ambient = a;
    specular = s;
    phong = P;
    krelf = K;

    r12 = new Ray(v1.xPos, v1.yPos, v1.zPos, v2.xPos, v2.yPos, v2.zPos);
    r13 = new Ray(v1.xPos, v1.yPos, v1.zPos, v3.xPos, v3.yPos, v3.zPos);
    r23 = new Ray(v2.xPos, v2.yPos, v2.zPos, v3.xPos, v3.yPos, v3.zPos);

    Ray normalRay = normalRay(r12, r13);
    Normal = normalRay.direction;
    PVec=new PVector(0,0,0);
  }


  float intercepts(Ray currRay) {
    //Plane "Ax+By+Cz+D=0"
    //Normal "Normal"
    //Point "P1 = v1 = (x,y,z)
    // -(ax+by+cz)=d
    // t = -QOdotN/RdotN
    PVector O = currRay.origin;
    PVector R = currRay.direction;
    PVector N = new PVector(Normal.x, Normal.y, Normal.z);        //Triangle Normal
    PVector Q = new PVector(v1.xPos, v1.yPos, v1.zPos);            //Triangle Point


    PVector QO = new PVector(O.x - Q.x, O.y-Q.y, O.z - Q.z); //QO Vector

    float QON = dotProduct(QO, N);  //QO dot N
    float RN = dotProduct(R, N); //R dot N
    float t= -1*QON/RN;

    if (t>=0) {
      PVector rt = PVector.mult(R,t);
      PVec = PVector.add(O, rt);
      if (inTriangle(PVec))
        return t;
      else
        return -1;
    }
    else
      return -1;
  }

  boolean sameSide(PVector A, PVector B, PVector C, PVector P) {
    PVector BA = new PVector(B.x-A.x, B.y-A.y, B.z-A.z);
    PVector CA = new PVector(C.x-A.x, C.y-A.y, C.z-A.z);
    PVector PA = new PVector(P.x-A.x, P.y-A.y, P.z-A.z);

    PVector N = BA.cross(CA);
    PVector M = BA.cross(PA);

    float check = dotProduct(N, M);

    return check>=0;
  }

  boolean inTriangle(PVector P) {
    PVector A = new PVector(v1.xPos, v1.yPos, v1.zPos);
    PVector B = new PVector(v2.xPos, v2.yPos, v2.zPos);
    PVector C = new PVector(v3.xPos, v3.yPos, v3.zPos);
    if (!sameSide(A, B, C, P)) return false;
    else if (!sameSide(B, C, A, P)) return false;
    else if (!sameSide(C, A, B, P)) return false;
    else {
      return true;
    }
  }  
  PVector getNormal() {
    return new PVector(Normal.x, Normal.y, Normal.z);
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

