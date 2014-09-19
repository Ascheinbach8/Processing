//Andrew Scheinbach
//CS 3451 HW0
//1/8/2014


int width = 600; // Screen width
int size = 10;

void setup()
{
  size(width,width); //Sets size of screen
}

void draw()
{ 
 background(255,255,255); //Sets background to white
 noStroke(); //Sets no outline to shapes
 fill(255,0,0);
 
 float baseX=mouseX; //Either use fromThree([-3,3]) or mouseX
 float baseY=mouseY; //Either use fromThree([-3,3]) or mouseY
 drawFractal(0,0,0,baseX,baseY);
 
}

void drawFractal(float x, float y, int power, float baseX, float baseY){
   int []red={0,100,200,255,155,55,0,40,140,240,185};
   int []green={110,210,255,145,45,5,70,170,2450,135,35};
   int []blue={215,235,135,35,5,95,195,235,120,20,255};
 if(power<11){
   fill(red[power],blue[power],green[power]);
   ellipse(fromThree(x),fromThree(y),size,size);
   drawFractal(x+xpower(power,baseX,baseY),y+ypower(power,baseX,baseY),power+1, baseX, baseY);
   drawFractal(x-xpower(power,baseX,baseY),y-ypower(power,baseX,baseY),power+1, baseX, baseY);
 }
}

float fromThree(float x)  //Converts from [-3,3] to regular coordinates
{
  return (x+3)*100.0;
}

float toThree(float x)    //Converts from regular coordinates to [-3,3]
{
  return (x/100.0)-3;
}

float xpower(int power, float baseX, float baseY){
  float x=1;
  float y=0;
  float newX=0;
  for(int i=0; i<power; i++){
    newX=(x*toThree(baseX))-(y*toThree(baseY));
    y=(x*toThree(baseY))+(y*toThree(baseX));
    x=newX;
  }
  return x;
}

float ypower(int power, float baseX, float baseY){
  float x=1;
  float y=0;
  float newY=0;
  for(int i=0; i<power; i++){
    newY=(x*toThree(baseY))+(y*toThree(baseX));
    x=(x*toThree(baseX))-(y*toThree(baseY));
    y=newY;
  }
  return y;
}
