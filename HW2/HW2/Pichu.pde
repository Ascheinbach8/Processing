//Pichu is copyright of Game Freak, Inc. under the Pokemon Media Franchise
//I do not own Pichu in any way, all I have done is recreated a model of it in Processing


void pichu(float x, float y, float z, float scale, float yAngle, int moveState, float time){
  float centerX=x/scale;
  float centerY=y/scale;
  float centerZ=z/scale;
  float armRotate=0;
  float feetRotate=0;
  float armAngle=120;
  float feetAngle=20;
  float armTime=(time%armAngle);//[0,angle]
  float feetTime=(time%feetAngle);//[0,angle]
  boolean armFlip;
  boolean feetFlip;
  if(armTime<armAngle/2 -1)
    armFlip=false;
  else
    armFlip=true;
    
  if(feetTime<feetAngle/2 -1)
    feetFlip=false;
  else
    feetFlip=true;
  
  if(moveState==1){
    if(!armFlip){
      armRotate=radians(armTime-armAngle/4);}
    if(armFlip){
      armRotate=radians((armAngle*3/4)-armTime);}
      
    if(!feetFlip){
      feetRotate=radians(feetTime-feetAngle/4);}
    if(feetFlip){
      feetRotate=radians((feetAngle*3/4)-feetTime);}
    }
  else{
    armRotate=0;
    feetRotate=0;
  }
  
  pushMatrix();
    scale(scale,scale,scale);
    translate(centerX, centerY, centerZ);
    rotate(yAngle, 0,1,0);
    
    pushMatrix();
      translate(0,-25,0);
      head();  
    popMatrix();
    
    body();
    
    pushMatrix();
    translate(0,-5,0);
      arms(armRotate);
    popMatrix();
    
    pushMatrix();
      translate(10,6,-8);
      tail();
    popMatrix();
    
    pushMatrix();
      translate(0,15,5);
      feet(feetRotate);
    popMatrix();
    
  popMatrix();
}

void body(){
  pushMatrix();
    fill(255,255,50);
    scale(1.1,1.1,1);
    sphere(12);
  popMatrix();
  pushMatrix();
    fill(0);
    translate(0,-10,10);
    rotate(radians(20),1,0,0);
    pushMatrix();
    rotate(radians(-15),0,1,0);
    rotate(radians(12),0,0,1);
      triangle(-12,0,-4,0,-6,8);
    popMatrix();
    
    pushMatrix();
      triangle(5,0,-5,0,0,4);
    popMatrix();
    
    pushMatrix();
      rotate(radians(15),0,1,0);
      rotate(radians(-12),0,0,1);
      triangle(12,0,4,0,6,8);
    popMatrix();
  popMatrix();
}

void arms(float armRotate){
  fill(255,255,50);
 pushMatrix();
    pushMatrix();
      rotate(armRotate,1,0,0);
      translate(-20,10,0);
      rotate(radians(-135),0,0,1);
      cone(5,20,10,.5);
    popMatrix();
    
    pushMatrix();
      rotate(armRotate*-1,1,0,0);
      translate(20,10,0);
      rotate(radians(135),0,0,1);
      cone(5,20,10,.5);
    popMatrix();
  popMatrix(); 
}

void feet(float feetRotate){
  pushMatrix();
    pushMatrix();

      rotate(radians(-20),0,1,0);
      fill(255,255,50);
      translate(-10,0,0);
            rotate(feetRotate,1,0,0);
      box(8,4,16);
      fill(0);
      translate(-2,0,6);
      box(1,-4,4);
      translate(2,0,0);
      box(1,-4,4);
      translate(2,0,0);
      box(1,-4,4);
    popMatrix();
    
    pushMatrix();

      rotate(radians(20),0,1,0);
      fill(255,255,50);
      translate(10,0,0);
            rotate(feetRotate*-1,1,0,0);
      box(8,4,16);
      fill(0);
      translate(2,0,6);
      box(1,-4,4);
      translate(-2,0,0);
      box(1,-4,4);
      translate(-2,0,0);
      box(1,-4,4);
    popMatrix();
  popMatrix();
}

void head(){
  pushMatrix();//Head
    fill(255, 255, 50);
    scale(1.2,1,1);
    sphere(18);
  
    pushMatrix(); //Eyes
      translate(0,-8,12);
    
      pushMatrix(); //Left
        fill(0);
        translate(-8,0,0);
        sphere(4);
        fill(255);
        translate(0,-1,2);
        sphere(2);
      popMatrix();
    
      pushMatrix(); //Right
        fill(0);
        translate(8,0,0);
        sphere(4);
        fill(255);
        translate(0,-1,2);
        sphere(2);
      popMatrix();
    
    popMatrix();
  
  pushMatrix(); //Cheeks
    translate(0,6,12.2);
    fill(255,0,0);
    pushMatrix();
      translate(-12,0,0);
      rotate(radians(-42),0,1,0);
      rotate(radians(-13),1,0,0);
      ellipse(0,0,10,10); 
    popMatrix();
    
    pushMatrix();
      translate(12,0,0);
      rotate(radians(42),0,1,0); 
      rotate(radians(-13),1,0,0);
      ellipse(0,0,10,10);
    popMatrix();
  popMatrix();
  
  pushMatrix(); //Ears
    translate(-10,-18,0);
    rotate(-PI/6,0,0,1);
    ear();
  popMatrix();
  pushMatrix(); //Ears
    translate(14,-16,0);
    rotate(PI/4,0,0,1);
    ear();
  popMatrix();
  
  pushMatrix(); //Mouth
    fill(0);
    translate(0,0,16);
    rotate(10,1,0,0);
    ellipse(0,-2,8,6);
  popMatrix();
  
  pushMatrix();//Nose
    fill(0);
    translate(0,-4,17);
    sphere(1);
  popMatrix();
 popMatrix();
  
}
void ear(){
  pushMatrix();
    scale(1,1,1.2);
    translate(-1,0,0);
    earPiece();
    translate(2,0,0);
    earPiece();
  popMatrix();
  
  fill(0);
  beginShape(QUADS);
  
  vertex(-8,0,-1);
  vertex(-8,0,1);
  vertex(0,-20,1);
  vertex(0,-20,-1);
  
  vertex(8,0,-1);
  vertex(8,0,1);
  vertex(0,-20,1);
  vertex(0,-20,-1);
  
  endShape(CLOSE);
  
  beginShape(TRIANGLES);
  vertex(-8, 0, -1);
  vertex(0,-20,-1);
  vertex(8,0,-1);
  
  vertex(-8, 0, 1);
  vertex(0,-20,1);
  vertex(8,0,1);
  
  vertex(-8,0,-1);
  vertex(0,4,-1);
  vertex(8,0,-1);
  
  vertex(-8,0,1);
  vertex(0,4,1);
  vertex(8,0,1);
  
  endShape(CLOSE);
  
}

void earPiece(){
  fill(255,255,0);
  beginShape(QUADS);
  vertex(0, 4, -1);
  vertex(0, 4, 1);
  vertex(-4, 2,1);
  vertex(-4, 2,-1);
  
  vertex(0, 4, -1);
  vertex(0, 4, 1);
  vertex(4, 2, 1);
  vertex(4, 2, -1);
  
  vertex(-4, 2,1);
  vertex(-4, 2,-1);
  vertex(0, -10, -1);
  vertex(0, -10, 1);
  
  vertex(4, 2,1);
  vertex(4, 2,-1);
  vertex(0, -10, -1);
  vertex(0, -10, 1);
  
  vertex(0,4,-1);
  vertex(-4,2, -1);
  vertex(0,-10,-1);
  vertex(4,2, -1);
  
  vertex(0,4,1);
  vertex(-4,2, 1);
  vertex(0,-10,1);
  vertex(4,2, 1);
  
  endShape(CLOSE);
  
}

void tail(){
  pushMatrix();
    fill(0); 
    rotate(radians(-30),0,0,1);
    box(20,4,2);
    translate(10,5,0);
    box(10,15,2);
  popMatrix();
}
