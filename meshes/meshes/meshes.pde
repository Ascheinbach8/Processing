// Sample code for starting the meshes project

import processing.opengl.*;

float time = 0;  // keep track of passing of time (for automatic rotation)
boolean rotate_flag = true;       // automatic rotation of model?

polyhedra currentPoly;
int colorMode = 0;
int normalMode = 0;
color[] colors;

// initialize stuff
void setup() {
  size(400, 400, OPENGL);  // must use OPENGL here !!!
  noStroke();     // do not draw the edges of polygons
}

// Draw the scene
void draw() {
  
  resetMatrix();  // set the transformation matrix to the identity (important!)

  background(0);  // clear the screen to black
  
  // set up for perspective projection
  perspective (PI * 0.333, 1.0, 0.01, 1000.0);
  
  // place the camera in the scene (just like gluLookAt())
  camera (0.0, 0.0, 5.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
  
  scale (1.0, -1.0, 1.0);  // change to right-handed coordinate system
  
  // create an ambient light source
  ambientLight(102, 102, 102);
  
  // create two directional light sources
  lightSpecular(204, 204, 204);
  directionalLight(102, 102, 102, -0.7, -0.7, -1);
  directionalLight(152, 152, 152, 0, 0, -1);
  
  pushMatrix();

  fill(50, 50, 200);            // set polygon color to blue
  ambient (200, 200, 200);
  specular(0, 0, 0);
  shininess(1.0);
  
  rotate (time, 1.0, 0.0, 0.0);
  
  // THIS IS WHERE YOU SHOULD DRAW THE MESH
  if(currentPoly != null){
    createPolygon();
  }
  
  popMatrix();
 
  // maybe step forward in time (for object rotation)
  if (rotate_flag )
    time += 0.02;
}


void createPolygon(){
  vert[] geometryTable  = currentPoly.getGeometryTable();
  int[] vertexTable =currentPoly.getVertexTable();
  for(int i = 0; i< currentPoly.getFaceNum(); i++){
    vert one = geometryTable[vertexTable[i*3]];
    vert two = geometryTable[vertexTable[(i*3)+1]];
    vert three = geometryTable[vertexTable[(i*3)+2]];
    
    PVector faceNormal = calculateFaceNormal(one, two, three);
    PVector oneNormal = calculateVertexNormal(i*3); //Caluclate vertex normal for this #vertex
    PVector twoNormal = calculateVertexNormal((i*3)+1);
    PVector threeNormal = calculateVertexNormal((i*3)+2);
    if(colorMode == 0){
      fill(255);
    }
    else{
      fill(colors[i]);
     }
    beginShape(TRIANGLE);
    if(normalMode == 0){
      normal(faceNormal.x, faceNormal.y, faceNormal.z);
    }
    
    if(normalMode == 1){
      normal(one.x, one.y, one.z);

    }
    one.makeVertex();
    
    if(normalMode == 1){
      normal(two.x, two.y, two.z);
    }
    two.makeVertex();
    
    if(normalMode == 1){
     normal(three.x, three.y, three.z);
    }
    three.makeVertex();
    
    endShape(CLOSE);
  }
}
PVector calculateFaceNormal(vert a, vert b, vert c){
    PVector V = new PVector((b.getX()-a.getX()),(b.getY()-a.getY()),(b.getZ()-a.getZ()));
    PVector W = new PVector((c.getX()-a.getX()),(c.getY()-a.getY()),(c.getZ()-a.getZ()));
    
    PVector N = V.cross(W);
    N.normalize();
    
    return N;
}

PVector calculateVertexNormal(int vertexNumber){
   PVector N = new PVector(0,0,0);
   int[] vertexTable = currentPoly.getVertexTable();
   vert[] geometryTable = currentPoly.getGeometryTable();
    for(int i = 0; i< vertexTable.length; i+=3){
       vert a = geometryTable[vertexTable[i]];
       vert b = geometryTable[vertexTable[i+1]];
       vert c = geometryTable[vertexTable[i+2]];
      PVector faceNorm = calculateFaceNormal(a,b,c);
      if(i == vertexNumber || (i+1) == vertexNumber || (i+2) == vertexNumber){
        N.add(faceNorm);
      }
      
    }
    
    N.normalize(); 
    return N;
}

vert calculateCentroid(vert a, vert b, vert c){    
    vert cent = new vert((a.getX()+b.getX()+c.getX())/3,(a.getY()+b.getY()+c.getY())/3,(a.getZ()+b.getZ()+c.getZ())/3,0);
    return cent;
}

color[] randomColors(int[] vertexTable){
  color[] colors = new color[vertexTable.length/3];
  for(int i = 0; i< colors.length; i++){
    int red = int(random(256));
    int green = int(random(256));
    int blue = int(random(256));
    
    colors[i] = color(red, green, blue);
  }
  return colors;
}

// handle keyboard input
void keyPressed() {
  if (key == '1') {
    read_mesh ("tetra.ply");
  }
  else if (key == '2') {
    read_mesh ("octa.ply");
  }
  else if (key == '3') {
    read_mesh ("icos.ply");
  }
  else if (key == '4') {
    read_mesh ("star.ply");
  }
  else if (key == '5') {
    read_mesh ("torus.ply");
  }
  else if (key == '6') {
    create_sphere();                     // create a sphere
  }
  else if (key == ' ') {
    rotate_flag = !rotate_flag;          // rotate the model?
  }
  else if (key == 'q' || key == 'Q') {
    exit();                               // quit the program
  }
  else if (key == 'd') {
    dual();         
  }
  else if (key == 'n') {
    if(normalMode == 0){
      normalMode = 1;
    }
    else{
      normalMode = 0; 
    }      
  }
  else if (key == 'w') {
    //Change colors white
    colorMode = 0;
  }
  else if (key == 'r') {
    //Change colors random
    colorMode = 1;
    int[] vertexTable = currentPoly.getVertexTable();
    colors = randomColors(vertexTable);
  }
}

// Read polygon mesh from .ply file
//
// You should modify this routine to store all of the mesh data
// into a mesh data structure instead of printing it to the screen.
void read_mesh (String filename)
{
  int i;
  String[] words;
  
  String lines[] = loadStrings(filename);
  
  words = split (lines[0], " ");
  int num_vertices = int(words[1]);
  println ("number of vertices = " + num_vertices);
  
  words = split (lines[1], " ");
  int num_faces = int(words[1]);
  println ("number of faces = " + num_faces);
  
  // read in the vertices
  vert[] geometryTable = new vert[num_vertices];
  for (i = 0; i < num_vertices; i++) {
    words = split (lines[i+2], " ");
    float x = float(words[0]);
    float y = float(words[1]);
    float z = float(words[2]);
    println ("vertex = " + x + " " + y + " " + z);
    vert v = new vert(x,y,z,i);
    geometryTable[i] = v;
    
  }
  
  // read in the faces
  int[]  vertexTable = new int[num_faces*3];
  for (i = 0; i < num_faces; i++) {
    
    int j = i + num_vertices + 2;
    words = split (lines[j], " ");
    
    int nverts = int(words[0]);
    if (nverts != 3) {
      println ("error: this face is not a triangle.");
      exit();
    }
    
    int index1 = int(words[1]);
    int index2 = int(words[2]);
    int index3 = int(words[3]);
    
    vertexTable[3*i] = index1;
    vertexTable[(3*i)+1] = index2;
    vertexTable[(3*i)+2] = index3;
    println ("face = " + index1 + " " + index2 + " " + index3);
  }
  polyhedra tempPoly = new polyhedra(num_vertices, num_faces, geometryTable, vertexTable);
  currentPoly = tempPoly;
  colors = randomColors(vertexTable);
  
}

void dual(){
  vert[] geometryTable = currentPoly.getGeometryTable();
  int [] vertexTable = currentPoly.getVertexTable();
  int[] opposites = currentPoly.getOppositeTable();
  
  ArrayList<Integer> vertexPrime = new ArrayList<Integer>(); //V prime
  ArrayList<vert> geometryPrime = new ArrayList<vert>();  //G prime with Centroids
  
  for(int i =0; i<vertexTable.length; i+=3){
       vert a = geometryTable[vertexTable[i]];
       vert b = geometryTable[vertexTable[i+1]];
       vert c = geometryTable[vertexTable[i+2]];
       
       vert centroid = calculateCentroid(a,b,c);
       geometryPrime.add(centroid);
  }
 
  for(int i = 0; i< geometryTable.length; i++){
    
    int cTriangle = 0; //Start/End C
    for(int j = 0; j<vertexTable.length; j++){
      if(vertexTable[j] == i){
        cTriangle = j;
        break;
      }
    }
    
    ArrayList<Integer> cTris = new ArrayList<Integer>(); //Swing around centerpoint
    cTris.add(cTriangle);
    int currC = swing(cTriangle, opposites); //Swinging C
    while(currC !=cTriangle){ //Swings through and adds to the cTris
      cTris.add(currC);
      currC = swing(currC, opposites);
    }//cTris now full
    
    vert cSum = new vert(0,0,0,0); //Sums up supercentroid
    for(int c = 0; c< cTris.size(); c++){
      int j = cTris.get(c); //current C in cTris
      int jf = j/3;  //Current Face associated with vertex C
      vert currCentroid = geometryPrime.get(jf); //Current face centroid
      cSum.sum(currCentroid);
    }
    
    vert avgVert =cSum.average(cTris.size()); //Calculates superCentroid
    geometryPrime.add(avgVert); //Adds superCentroid to size-1 location;

    for(int c = 0; c< cTris.size(); c++){
      int j = cTris.get(c); //current C in cTris
      int jf = j/3;  //Current Face associated with vertex C
      
      int k = cTris.get((c+1)%cTris.size());
      int jk = k/3;
      
      vertexPrime.add(jf);
      vertexPrime.add(jk);
      vertexPrime.add(geometryPrime.size()-1);
    }
    
  }
  
  int newFaceNum = vertexPrime.size()/3;
  int newVertexNum = geometryPrime.size();
  
  vert[] newVertices = new vert[newVertexNum];
  int[] newFaces = new int[vertexPrime.size()];

  for(int i = 0; i< newVertexNum; i++){
    newVertices[i] = geometryPrime.get(i);
  }

  for(int i = 0; i< vertexPrime.size(); i++){
    newFaces[i] = vertexPrime.get(i);

  }
  colors = randomColors(newFaces);
  polyhedra newPoly = new polyhedra(newVertexNum, newFaceNum, newVertices, newFaces);

  currentPoly = newPoly;
  
}
  //c.n = n(c) = 3(c/3) + (c+1)%3 next
  //c.p = p(c) = n(n(c)) previous
  //c.s = s(c) = n(o(n(c)) swing
int next(int i){
  return (3*(i/3) + (i+1)%3);
}

int previous(int i){
  return next(next(i));
}
int swing(int i, int[] opp){
  return next(opp[next(i)]);
}


void create_sphere() {}

