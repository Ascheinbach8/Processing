// CS 3451 Spring 2013 Homework 1 Stub
// Dummy routines for matrix transformations.
// These are for you to write!
import java.util.Stack;
import java.util.ArrayList;

class gtMatrix {
  float[][] m;
  gtMatrix() {m = new float[4][4];}
}

class gtVertex {
  float[] v;
  gtVertex() {v = new float[4];}
}

gtMatrix CTM = new gtMatrix();
//GT Perspective
float perspectiveK=0;
float nearClip=0;
float farClip=0;
//GT Ortho Stuff
float leftClip=0;
float rightClip=0;
float bottomClip=0;
float topClip=0;

int proj=0; //0 is Orthogonal, 1 is Perspective

boolean drawLines=false;
int stackSize=0;
int vertexSize=0;

Stack mStack = new Stack<gtMatrix>();
ArrayList vertices = new ArrayList<gtVertex>();

void gtInitialize() {
 float a[][]= {{1,0,0,0},
              {0,1,0,0},
              {0,0,1,0},
              {0,0,0,1}};
 gtMatrix iMatrix = new gtMatrix();
 iMatrix.m=a;
 mStack.add(iMatrix);
 
 CTM=iMatrix;
 stackSize=1;
}
void gtPushMatrix() {
  gtMatrix pMatrix = new gtMatrix();
  gtMatrix peekMatrix=(gtMatrix)mStack.peek();
  for(int i=0;i<4;i++){
    for(int j=0;j<4;j++){
      pMatrix.m[i][j]=peekMatrix.m[i][j];
    }
  }
  mStack.push(pMatrix);
  CTM=pMatrix;
  stackSize++;
  }

void gtPopMatrix() {
 if(stackSize==1){
   println("Error, Stack Size One");
   }
   else{
  mStack.pop();
  CTM=(gtMatrix)mStack.peek();
  stackSize--;
   }
}

float[] multiply4by1(float[] vertex, float[][] CTM){
  float[]newVertex = new float[4];
  for(int i=0; i < 4; i++){
  newVertex[i] = (CTM[i][0]*vertex[0])+(CTM[i][1]*vertex[1])+(CTM[i][2]*vertex[2])+(CTM[i][3]*vertex[3]);
  }
  return newVertex;
}

float[][] multiply4by4(float[][]CTM, float[][]trans){
  float[][] newCTM = new float[4][4];

      for(int i = 0; i < 4; i++){
        for(int j = 0; j < 4; j++){
            for(int k = 0; k < 4; k++){
                newCTM[i][j] += CTM[i][k] * trans[k][j];
            }
        }
    }
  return newCTM;
}


void gtTranslate(float tx, float ty, float tz) {
 gtMatrix tMatrix = new gtMatrix();
  float [][] a = {{1,0,0,tx},
                  {0,1,0,ty},
                  {0,0,1,tz},
                  {0,0,0,1}};
   tMatrix.m=a;
   CTM.m=multiply4by4(CTM.m, tMatrix.m);
  }

void gtScale(float sx, float sy, float sz) {
 gtMatrix sMatrix = new gtMatrix();
  float [][]a = { {sx,0,0,0},
                  {0,sy,0,0},
                  {0,0,sz,0},
                  {0,0,0,1}};
  sMatrix.m=a;
  CTM.m=multiply4by4(CTM.m, sMatrix.m);
 }

void gtRotate(float angle, float ax, float ay, float az) {
 gtMatrix rxMatrix = new gtMatrix();
 float ang = radians(angle);
  float [][] x = {{1,0,0,0},
                  {0,cos(ang*ax),-sin(ang*ax),0},
                  {0,sin(ang*ax),cos(ang*ax),0},
                  {0,0,0,1}};
 gtMatrix ryMatrix = new gtMatrix();
  float [][] y = {{cos(ang*ay),0,sin(ang*ay),0},
                  {0,1,0,0},
                  {-sin(ang*ay),0,cos(ang*ay),0},
                  {0,0,0,1}};
   
 gtMatrix rzMatrix = new gtMatrix();
  float [][] z = {{cos(ang*az),-sin(ang*az),0,0},
                  {sin(ang*az),cos(ang*az),0,0},
                  {0,0,1,0},
                  {0,0,0,1}};
  rxMatrix.m=x;
  ryMatrix.m=y;
  rzMatrix.m=z;
  
  if(ax!=0){
    CTM.m=multiply4by4(CTM.m, rxMatrix.m);}
  if(ay!=0){
    CTM.m=multiply4by4(CTM.m, ryMatrix.m);}
  if(az!=0){
    CTM.m=multiply4by4(CTM.m, rzMatrix.m);}
}

void gtPerspective(float fovy, float nnear, float ffar) {
   proj=2;
   float fov=radians(fovy);
   float k = nnear*tan(fov/2);
   perspectiveK = k;
   nearClip=nnear;
   farClip=ffar;
   
  }

void gtOrtho(float left, float right, float bottom, float top, float nnear, float ffar) {
    proj=1;
    leftClip=left;
    rightClip=right;
    bottomClip=bottom;
    topClip=top;
    nearClip=nnear;
    farClip=ffar;
  }

void gtBeginShape(int type) {
 drawLines=true;
 vertices.clear();
 vertexSize=0;
 }

void gtEndShape() { 
 drawLines=false;
 vertices.clear();
 vertexSize=0;
}

void gtVertex(float x, float y, float z) {
  
 if(drawLines){
   gtVertex newVertex = new gtVertex();
   float [] a = {x,y,z,1};
   newVertex.v = a;
   vertices.add(newVertex);
   vertexSize++;
   
   
   if(vertexSize==2){
       gtVertex vStart=(gtVertex)vertices.get(0);
       gtVertex vEnd=(gtVertex)vertices.get(1);
       vStart.v=multiply4by1(vStart.v, CTM.m); //Transformations
       vEnd.v=multiply4by1(vEnd.v, CTM.m);
       
      if(proj==1){ //Orthographic Mode
         gtMatrix projector = new gtMatrix();
         float [][]cent1 = {{width/2,0,0,abs(width-1)/2},
                         {0,height/2,0,abs(height-1)/2},
                         {0,0,1,0},
                         {0,0,0,1}};
                         
         float [][]cent2 = {{2/abs(rightClip-leftClip),0,0,0},
                         {0,2/abs(topClip-bottomClip),0,0},
                         {0,0,2/abs(nearClip-farClip),0},
                         {0,0,0,1}};
                         
         float [][]cent3 = {{1,0,0,abs(leftClip+rightClip)/-2},
                         {0,1,0,abs(bottomClip+topClip)/-2},
                         {0,0,1,abs(nearClip+farClip)/-2},
                         {0,0,0,1}};
       projector.m=multiply4by4(multiply4by4(cent1, cent2), cent3);
       vStart.v=multiply4by1(vStart.v, projector.m); //Transformations
       vEnd.v=multiply4by1(vEnd.v, projector.m);
       }
       
       
       if(proj==2){ //Perspective Mode

         float xStartp=(nearClip)*(vStart.v[0]/abs(vStart.v[2]));//Perspective -x/z = x'
         float yStartp=(nearClip)*(vStart.v[1]/abs(vStart.v[2]));//Perspective -y/z = y'
         
         float xEndp=(nearClip)*(vEnd.v[0]/abs(vEnd.v[2]));//Perspective -x/z = x'
         float yEndp=(nearClip)*(vEnd.v[1]/abs(vEnd.v[2]));//Perspective -y/z = y'
         
         vStart.v[0]=(xStartp+perspectiveK)*width/(2*perspectiveK);
         vEnd.v[0]=(xEndp+perspectiveK)*width/(2*perspectiveK);
         vStart.v[1]=(yStartp+perspectiveK)*height/(2*perspectiveK);
         vEnd.v[1]=(yEndp+perspectiveK)*height/(2*perspectiveK);
       }
       
       xyz p0 = new xyz(vStart.v[0], vStart.v[1], vStart.v[2]);
       xyz p1 = new xyz(vEnd.v[0], vEnd.v[1], vEnd.v[2]);
       
      if(near_far_clip(-1*nearClip, -1*farClip, p0, p1)==1){
        near_far_clip(-1*nearClip, -1*farClip, p0, p1);
         draw_line(p0.x,p0.y, p1.x,p1.y);
       }

         vertexSize=0;
         vertices.clear();
   }
 }
}

