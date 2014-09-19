//card2.frag: fragment shader for the mandelbrot card

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

//z(n+1) = z(n)^2 + c
//z(0) = (0,0)
//z(1)=z(0)^2+c, z(2)=z(1)^2+c


void main() { 
  vec4 diffuse_color = vec4 (1.0, 0.0, 0.0, 1.0);
  float diffuse = clamp(dot (vertNormal, vertLightDir),0.0,1.0);
  
  //Modified c values for x,y coordinates
  float cX =((vertTexCoord.x*3.0)-2.1);
  float cY =((vertTexCoord.y*3.0)-1.5);
  
  //Initial Z
  vec2 z = (0.0, 0.0);
  for(int i = 0; i< 20; i++){
	float r = sqrt(pow(z.x, 2.0) + pow(z.y, 2.0));
	
	float zX2 = pow(z.x,2) - pow(z.y,2); //a^2 - b^2
	float zY2 = 2 * z.x * z.y; //2abi
	
	//White color in Mandelbrot
	if(r<2.0){
		diffuse_color = vec4 (1.0, 1.0, 1.0, 1.0);
	}
	//Non white outside Mandelbrot
	if(r>2.0){
		diffuse_color = vec4 (cX/2, cY/2, r/2, 1.0);
	}
	z = vec2(zX2 + cX, zY2 + cY);
  }
    gl_FragColor = vec4(diffuse * diffuse_color.rgb, 1.0); 
}