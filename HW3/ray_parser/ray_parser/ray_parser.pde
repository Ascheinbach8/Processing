///////////////////////////////////////////////////////////////////////
//
// Command Line Interface (CLI) Parser  
//
///////////////////////////////////////////////////////////////////////
String gCurrentFile = new String("rect_test.cli"); // A global variable for holding current active file name.

///////////////////////////////////////////////////////////////////////
//
// Press key 1 to 9 and 0 to run different test cases.
//
///////////////////////////////////////////////////////////////////////
void keyPressed() {
  switch(key) {
  case '1':  
    gCurrentFile = new String("t0.cli"); 
    interpreter(); 
    break;
  case '2':  
    gCurrentFile = new String("t1.cli"); 
    interpreter(); 
    break;
  case '3':  
    gCurrentFile = new String("t2.cli"); 
    interpreter(); 
    break;
  case '4':  
    gCurrentFile = new String("t3.cli"); 
    interpreter(); 
    break;
  case '5':  
    gCurrentFile = new String("c0.cli"); 
    interpreter(); 
    break;
  case '6':  
    gCurrentFile = new String("c1.cli"); 
    interpreter(); 
    break;
  case '7':  
    gCurrentFile = new String("c2.cli"); 
    interpreter(); 
    break;
  case '8':  
    gCurrentFile = new String("c3.cli"); 
    interpreter(); 
    break;
  case '9':  
    gCurrentFile = new String("c4.cli"); 
    interpreter(); 
    break;
  case '0':  
    gCurrentFile = new String("c5.cli"); 
    interpreter(); 
    break;
  }
}

ArrayList<RayShape> shapes = new ArrayList<RayShape>();
ArrayList<Light> lights = new ArrayList<Light>();
Color background = new Color(0, 0, 0);

ArrayList<Vertex> vertices = new ArrayList<Vertex>();
ArrayList<Color> colors = new ArrayList<Color>();
float phong = 0;
float krelf = 0;
boolean newBack=false;

float perspectiveK = 0;


///////////////////////////////////////////////////////////////////////
//
//  Parser core. It parses the CLI file and processes it based on each 
//  token. Only "color", "rect", and "write" tokens are implemented. 
//  You should start from here and add more functionalities for your
//  ray tracer.
//
//  Note: Function "splitToken()" is only available in processing 1.25 
//       or higher.
//
///////////////////////////////////////////////////////////////////////


void interpreter() {

  String str[] = loadStrings(gCurrentFile);
  if (str == null) println("Error! Failed to read the file.");
  for (int i=0; i<str.length; i++) {

    String[] token = splitTokens(str[i], " "); // Get a line and parse tokens.
    if (token.length == 0) continue; // Skip blank line.


    if (token[0].equals("fov")) {
      float ang = float(token[1]);
      perspectiveK = tan(radians(ang)/2);
    }
    else if (token[0].equals("background")) {
      float r =float(token[1]);
      float g =float(token[2]);
      float b =float(token[3]);

      background = new Color(r, g, b);
      newBack=true;
    }
    else if (token[0].equals("light")) {
      float x =float(token[1]);
      float y =float(token[2]);
      float z =float(token[3]);

      float r =float(token[4]);
      float g =float(token[5]);
      float b =float(token[6]);

      Light newLight = new Light(r, g, b, x, y, z);

      if (lights.size()<10)
        lights.add(newLight);
    }
    else if (token[0].equals("surface")) {
      colors.clear();
      float cdr =float(token[1]);
      float cdg =float(token[2]);
      float cdb =float(token[3]);

      float car =float(token[4]);
      float cag =float(token[5]);
      float cab =float(token[6]);

      float csr =float(token[7]);
      float csg =float(token[8]);
      float csb =float(token[9]);

      float P = float(token[10]);
      float K = float(token[11]);

      Color diffuse = new Color(cdr, cdg, cdb);
      Color ambient = new Color(car, cag, cab);
      Color specular = new Color(csr, csg, csb);

      colors.add(diffuse);
      colors.add(ambient);
      colors.add(specular);

      phong=P;
      krelf=K;
    }    
    else if (token[0].equals("sphere")) {
      float radius = float(token[1]);
      float x =float(token[2]);
      float y =float(token[3]);
      float z =float(token[4]);

      Sphere newSphere = new Sphere(x, y, z, radius, colors.get(0), colors.get(1), colors.get(2), phong, krelf);
      shapes.add(newSphere);
    }
    else if (token[0].equals("begin")) {
      vertices.clear();
    }
    else if (token[0].equals("vertex")) {
      float x =float(token[1]);
      float y =float(token[2]);
      float z =float(token[3]);

      Vertex v = new Vertex(x, y, z);
      vertices.add(v);
    }
    else if (token[0].equals("end")) {
      Triangle newTriangle = new Triangle(vertices.get(0), vertices.get(1), vertices.get(2), colors.get(0), colors.get(1), colors.get(2), phong, krelf);
      shapes.add(newTriangle);
    }
    else if (token[0].equals("color")) {
      float r =float(token[1]);
      float g =float(token[2]);
      float b =float(token[3]);
      fill(r, g, b);
    }
    else if (token[0].equals("rect")) {
      float x0 = float(token[1]);
      float y0 = float(token[2]);
      float x1 = float(token[3]);
      float y1 = float(token[4]);
      rect(x0, height-y1, x1-x0, y1-y0);
    }
    else if (token[0].equals("write")) {
      save(token[1]); 
      rayTrace();
      lights.clear(); 
      shapes.clear();
      newBack=true;
      background = new Color(0, 0, 0);
    }
  }
}

///////////////////////////////////////////////////////////////////////
//
// Some initializations for the scene.
//
///////////////////////////////////////////////////////////////////////
void setup() {
  size(300, 300);  
  noStroke();
  colorMode(RGB, 1.0);
  background(0, 0, 0);
  interpreter();
}

void rayTrace() {
  if (newBack)
    background(background.red, background.green, background.blue);
  for (int xPix = 0; xPix< 300; xPix++) {
    for (int yPix = 0; yPix< 300; yPix++) {

      float xPrime=(xPix-150)*(perspectiveK/150);
      float yPrime=-1*(yPix-150)*(perspectiveK/150);
      float zPrime=-1;

      PVector direction = new PVector(xPrime, yPrime, zPrime);
      direction.normalize();
      float mainT=Integer.MAX_VALUE;
      PVector origin = new PVector(0, 0, 0);
      for (int i =0; i< shapes.size(); i++) { //Traces original shape
        RayShape currShape = shapes.get(i);
        Ray currRay = new Ray(origin, direction);
        float t = currShape.intercepts(currRay);
        if (t>=0 && t<= mainT) {
          mainT=t;
          Color Full = trueColor(currRay, lights, currShape, i, shapes, 0);
          set(xPix, yPix, color(Full.getRed(), Full.getGreen(), Full.getBlue()));
        }
      }
    }
  }
}

Color trueColor(Ray currRay, ArrayList<Light> lights, RayShape currShape, float index, ArrayList<RayShape> shapes, float reflect) {
  float red=currShape.getAmbient().getRed();
  float green=currShape.getAmbient().getGreen();
  float blue=currShape.getAmbient().getBlue();
  float pho = currShape.getPhong();
  float kre = currShape.getKrelf();
  Color Crelf =new Color(0,0,0); 

  PVector p = currShape.getP();
  PVector O = currRay.origin;
  O.normalize();
  PVector dir = currRay.direction;
  dir.normalize();

  PVector N = currShape.getNormal();
  N.normalize();
  PVector V = new PVector(O.x - p.x, O.y -  p.y, O.z -  p.z); // Surface -> Eye
  V.normalize();

  for (int i = 0; i < lights.size(); i++) { //Go through lights
    Color lightC = new Color(lights.get(i).getColor().getRed(), lights.get(i).getColor().getGreen(), lights.get(i).getColor().getBlue());
    PVector lightV = new PVector(lights.get(i).getVector().x, lights.get(i).getVector().y, lights.get(i).getVector().z);
    // lightV.normalize();
    PVector L = new PVector(lightV.x - p.x, lightV.y - p.y, lightV.z - p.z); // Surface -> Light
    L.normalize();

    PVector R = PVector.sub(PVector.mult(N, dotProduct(N,V)*2),V);
    R.normalize();
    

    float lR = lightC.getRed();
    float lG = lightC.getGreen();
    float lB = lightC.getBlue();

    PVector origin = lights.get(i).getVector();
    PVector surface = currShape.getP();

    PVector direction = PVector.sub(surface, origin); //Light to main surface
    direction.normalize();
    Ray lightRay = new Ray(origin, direction);
    float currT = currShape.intercepts(lightRay);


    //End reflection
    float dR = currShape.getDiffuse().getRed();
    float dG = currShape.getDiffuse().getGreen();
    float dB = currShape.getDiffuse().getBlue();

    float sR = currShape.getSpecular().getRed();
    float sG = currShape.getSpecular().getGreen();
    float sB = currShape.getSpecular().getBlue();

    dR = dR*max(0, dotProduct(N, L));
    dG = dG*max(0, dotProduct(N, L));
    dB = dB*max(0, dotProduct(N, L));

    sR = sR*pow(max(0, dotProduct(V, R)), pho);
    sG = sG*pow(max(0, dotProduct(V, R)), pho);
    sB = sB*pow(max(0, dotProduct(V, R)), pho);

    //Shadow
    for (int j = 0; j< shapes.size(); j++) {
      if (j!=index) {
        RayShape shadowShape = shapes.get(j);
        float shadowT = shadowShape.intercepts(lightRay);

        if (shadowT>=0 && shadowT<=currT) {
          lR = 0;
          lG = 0;
          lB = 0;
          j = shapes.size();
        }
      }
    }
    //End Shadow
    //Reflection
    if (reflect<4 && kre>0) {
      for (int j = 0; j< shapes.size(); j++) {
        RayShape reflectShape = shapes.get(j);
        surface.add(PVector.mult(R,.0001));
        Ray reflectRay = new Ray(surface, R); //Start from surface, move to reflect direction
        float currReflectT =reflectShape.intercepts(reflectRay);
        if (currReflectT >= 0) {
          Crelf = trueColor(reflectRay, lights, reflectShape, j, shapes, reflect+1);
        }
      }
    }
    else
      Crelf=background;

    lR=lR*(dR+sR);
    lG=lG*(dG+sG);
    lB=lB*(dB+sB);
    
    red+=lR+(Crelf.red*kre);
    green+=lG+(Crelf.green*kre);
    blue+=lB+(Crelf.blue*kre);
  }
  return new Color(red, green, blue);
}

///////////////////////////////////////////////////////////////////////
//
// Draw frames.  Should leave this empty.
//
///////////////////////////////////////////////////////////////////////
void draw() {
}

