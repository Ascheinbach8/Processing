//card1.frag: fragment shader for the swiss cheese card.

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

varying vec2 centers[9];
varying vec2 tempCenter;
float alpha;
float radius = 0.1;

void main() { 
  vec4 diffuse_color = vec4 (0.0, 1.0, 1.0, 1.0);
  float diffuse = clamp(dot (vertNormal, vertLightDir),0.0,1.0);
  
  //Array of centers at .15, .5 ,.85 in x and y
  for(int i = 0; i< 9; i++){
	int col = (i%3);
	int row = (i/3);
	tempCenter = vec2((.15 + col*.35),(.15 + row*.35));
	centers[i] = tempCenter;
  }
  
  //Initially sets alpha to .8 then changes to 0 if in circle
  alpha = 0.8;
  for(int i = 0; i < 9; i++){
	float xDif = centers[i].x - vertTexCoord.x;
	float yDif = centers[i].y - vertTexCoord.y;
	
	float r = sqrt(pow(xDif, 2.0) + pow(yDif, 2.0));
	
	if(r < radius){
		alpha = 0.0;
	}
  }
    gl_FragColor = vec4(diffuse * diffuse_color.rgb, alpha);
}
