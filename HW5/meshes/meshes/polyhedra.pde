class polyhedra{
  int numV;
  int numF;
  vert[] geometryTable;
  int [] vertexTable;
  int[] opposite;
  
  polyhedra(int numVertices, int numFaces, vert[] vertices,  int[] vertexT){
    numV = numVertices;
    numF = numFaces;
    geometryTable = vertices;
    vertexTable = vertexT;
    
    opposite = calculateOpposite(vertexTable);
  }
  
 int[]  calculateOpposite(int[] vertexTable){
     int[] opposites = new int[vertexTable.length];
    for(int i = 0; i< vertexTable.length; i++){
      for(int j = 0; j< vertexTable.length; j++){
        if(i!=j){
          if((vertexTable[next(i)] == vertexTable[previous(j)]) && (vertexTable[previous(i)] == vertexTable[next(j)])){
            opposites[i] = j;
            opposites[j] = i;
          }
        }
      }
    }
    return opposites;
  }

  int getVertNum(){
    return numV;
  }
  
  int getFaceNum(){
    return numF;
  }
  
  vert[] getGeometryTable(){
    return geometryTable;
  }
  
  int[] getVertexTable(){
    return vertexTable;
  }
  int[] getOppositeTable(){
    return opposite;
  }
}

class vert{
  float x, y, z;
  PVector normal;
    
  int vertexNumber;
  
  vert(float a, float b, float c, int vNum){
    x = a;
    y = b;
    z = c;
    vertexNumber = vNum;
  }
  
  void makeVertex(){
    vertex(x,y,z);
  }
  
  void sum(vert newVert){
    float xn = newVert.getX();
    float yn = newVert.getY();
    float zn = newVert.getZ();
    
    x = x + xn;
    y = y + yn;
    z = z + zn;
  }
  
  vert average(int size){
    vert avgVert = new vert(x/size,y/size,z/size, 0);
    return avgVert;
  }
  
  float getX(){
    return x;
  }
  float getY(){
    return y;
  }
  float getZ(){
    return z;
  }

}
