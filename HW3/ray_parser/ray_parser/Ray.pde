class Ray {
  float startX, startY, startZ, endX, endY, endZ;
  PVector origin, direction;
  Ray(float x1, float y1, float z1, float x2, float y2, float z2) {
    startX = x1;
    startY = y1;
    startZ = z1;
    endX = x2;
    endY = y2;
    endZ = z2;

    origin = new PVector(x1, y1, z1);
    direction = new PVector(x2, y2, 2);
  }

  Ray(PVector s, PVector e) {
    origin = s;
    direction = e;

    startX = origin.x;
    startY = origin.y;
    startZ = origin.z;
    endX = direction.x;
    endY = direction.y;
    endZ = direction.z;
  }


  PVector getVector() {
    PVector returnVector = new PVector(endX-startX, endY-startY, endZ-startZ);
    return returnVector;
  }
}

float dotProduct(PVector vector1, PVector vector2) {
  return vector1.dot(vector2);
}

Ray normalRay(Ray oneRay, Ray twoRay) { //Returns Origin and normalized direction
  PVector v1 = oneRay.getVector();
  PVector v2 = twoRay.getVector();
  PVector v3 = v2.cross(v1);
  v3.normalize();

  Ray returnRay = new Ray(oneRay.origin, v3); 
  return returnRay;
}

