import processing.opengl.*;

float time =0;
float oldTime=0; //Time reference

float xPos=0; //Object x pos
float yPos=0; //Object y pos
float zPos=0;  //Object z pos
float yRot=0; //Object rotation
int speed=8; //Obj movement speed
float charge = 0; //Lightning charge
float objTime=0; //Internal time for pichu
float objScale=.25;

float r = 200*objScale; //Radius of Camera View
float yAngle=0; //Camera y axis rotation
float xAngle=-PI/8; //Camera x axis rotation

boolean speedup=false; //Speeds up time if true

float sunAngle=0; //Sun's Angle

int moveState=0; //-1 backwards, 0 idle, 1 forward
boolean charging=false;

float oldMouseX=mouseX; //Stores old mouse pos
float oldMouseY=mouseY; //Stores old mouse pos

int[][] treeArray;

void setup(){
  size(400,400,OPENGL);
  noStroke();
  treeArray=createTreeArray(); //Creating an array of trees. Object Instancing
}

void draw(){
  resetMatrix(); //Clear matrix stack
  
  background(0); //Background black
  
  perspective(PI*(.333), 1.0, 0.01, 1000.0*1.42); //Pespective projection
  
  scale(1.0, -1.0, 1.0); //Right handed coordinate system
  
  camera(xPos+r*sin(yAngle)*cos(xAngle),yPos+ r*sin(xAngle),zPos + -1* r*cos(yAngle)*cos(xAngle), xPos, yPos, zPos, 0.0, 1.0, 0.0);    
  
  ambientLight(102,102,102); //Ambient Light
  sunAngle=radians(time%24)*10;
  // Two dimensional light
  lightSpecular(204,204,204);
  if(time%24<18){
    pointLight(255,255,255,200*cos(sunAngle),-200*sin(sunAngle),0);} //Acts like a sun
    pointLight(255,255,255,0,-200,0);
    directionalLight(126,126,126,0,-1,0);
 
  
 pushMatrix();
     
    ambient (50, 50, 50);    
    specular(150, 150, 150);
    shininess(5.0);
    //Creation of instanced Data
    //All trees are flat agaisnt the ground
    drawTrees(treeArray);
  pushMatrix();
    specular(50,50,50);
     translate(xPos,0,zPos);
     fill(30,126,255);
     box(1000,1000,1000);   
     fill(50,255,50);
     scale(1000,1,1000);
     box(1,1,1);
  popMatrix();
    translate(0,-20*objScale,0);
    pichu(xPos, yPos, zPos, objScale , yRot, moveState, objTime);
  popMatrix();
 // Generic Draw polygon
  if(charging){
    if(charge<250){charge+=5;}
    pushMatrix();
    fill(0,126,255,126);
    translate(xPos,yPos-(30*objScale),zPos);
    sphere(charge/4 * objScale);
    popMatrix();
  }
  
  if(!speedup)
    time+=0.05;
  if(speedup)
    time+=0.5;
  
  if(!charging){
    if(time-oldTime<1){
        lightning(xPos, yPos, zPos, yRot, charge);
    }
    else{
      charge=0;
    }
  }
  
  
} //End draw
int getTreeLocation(float xPos, float zPos){
  int xMap = int(xPos+500)/100;
  int zMap = int(zPos+500)/100;
  int treeLocation=0;
  if((xMap<0) || (xMap>9) || (zMap<0) || (zMap>9)) treeLocation = 0;
  
  //else treeLocation = treeArray[xMap][zMap];
  
  return treeLocation;
}

void keyPressed() {
  if (key == 'a') { //xPos+=speed*cos(yAngle);
                    //zPos+=speed*sin(yAngle); }
                    yRot+=.3;
                    objTime+=2;}
  if (key == 'd') { //xPos-=speed*cos(yAngle);
                    //zPos-=speed*sin(yAngle); }
                    yRot-=.3;
                    objTime+=2;}
  if (key == 'w') {
                    float newZ=zPos+speed*cos(yRot);
                    float newX=xPos+speed*sin(yRot);
                    int treeLocation=getTreeLocation(newX, newZ);
                    if(treeLocation==0){
                     xPos=newX;
                     zPos=newZ;
                   }
                    moveState=1;
                    objTime+=2;}
  if (key == 's') {
                   float newZ=zPos-speed*cos(yRot);
                   float newX=xPos-speed*sin(yRot); 
                   int treeLocation=getTreeLocation(newX, newZ);
                   if(treeLocation==0){
                     xPos=newX;
                     zPos=newZ;
                   }
                   moveState=1;
                   objTime+=2;}
  if(key == 't'){ speedup=true;}
}

void keyReleased(){
    if(key == 'w'){moveState=0;}
    if(key == 's'){moveState=0;}
    if(key == 't'){speedup=false;}
}

void mouseDragged() {
  if(mouseButton==LEFT){
    if(oldMouseY>mouseY){
      if(xAngle>(PI/-4)+.08){
      xAngle-=.06;
      }
      oldMouseY=mouseY;
    }
    if(oldMouseY<mouseY){
      if(xAngle<(PI/128)-.08){
      xAngle+=.06;
      }
      oldMouseY=mouseY;
    }
    if(oldMouseX>mouseX){
      yAngle+=.1;
      oldMouseX=mouseX;
    }
    if(oldMouseX<mouseX){
      yAngle-=.1;
      oldMouseX=mouseX;
    }
  }
}

void mousePressed(){
  if(mouseButton==RIGHT){
    charging=true;
    charge=0;
  }
}

void mouseReleased(){
  if(mouseButton==RIGHT){
    charging=false;
    oldTime=time;
  }
}

void lightning(float xPos, float yPos, float zPos, float yRot, float charge){
  if(charge>0){
    pushMatrix();
      translate(0,-40*objScale,0);
      scale(objScale, objScale, objScale);
      fill(0,126,200);
      ambient(255,255,255);
      translate(xPos/objScale, yPos, (zPos/objScale));
      rotate(yRot,0,1,0);
      translate(0,0,(charge/2)+20*objScale);
      pushMatrix();
        translate(-10,-10,0);
        box(8,8,charge);
      popMatrix();
      
      pushMatrix();
        translate(10,10,0);
        box(8,8,charge);
      popMatrix();
    
      pushMatrix();  
        translate(-10,10,0);
        box(8,8,charge);
      popMatrix();
      
      pushMatrix();
        translate(10,-10,0);
        box(8,8,charge);
      popMatrix();
    popMatrix();
  } 
  for(int i=0; i<charge; i+=100){
    pointLight(30,30,30,xPos+(i)*cos(yRot), yPos, zPos+(i)*sin(yRot));
  }
}

int [][] createTreeArray(){
  int [][] treeArray = new int[10][10];
  for(int x=0; x<treeArray.length; x++){
    for(int z=0; z<treeArray[0].length; z++){
      treeArray[x][z] = int(random(6));
    }
  }
  treeArray[5][5]=0;
  return treeArray;
}

void drawTrees(int [][] treeArray){
  float w = 1000/treeArray.length;
  float d = 1000/treeArray[0].length;
  for(int x=0;x<treeArray.length; x++){
    for(int z=0;z<treeArray[x].length;z++){
      pushMatrix();
        translate(w*x -500, 0, d*z -500);
        trees(treeArray[x][z]);
      popMatrix();
    }
  }
  
}

