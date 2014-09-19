void trees(int treeType){ 
  if(treeType==4){
    pushMatrix();
      fill(51, 51, 0);
      translate(0,-40,0);
      cylinder(5, 40, 50);
      fill(0, 255, 0);
      translate(0,-20,0);
      cone(20, 40, 5, .1);
    popMatrix();
  }
  
  if(treeType==5){
    pushMatrix();
      fill(150, 100, 50);
      translate(0,-40,0);
      cylinder(5, 50, 50);
      fill(102, 255, 0);
      translate(0,-30,0);
      cone(20, 40, 5, .1);
    popMatrix();
  }
}
