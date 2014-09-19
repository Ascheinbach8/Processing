//card3.frag fragment shader for the duck card

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXLIGHT_SHADER

// Set in Processing
uniform sampler2D texture;

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;
varying vec4 vertTexCoordR;
varying vec4 vertTexCoordL;

  //float greyScale = r*0.3 + g*0.6 + b*0.1;
  //color(greyScale, greyScale, greyScale);

void main() { 
  vec4 diffuse_color = texture2D(texture, vertTexCoord.xy);
  float diffuse = clamp(dot (vertNormal, vertLightDir),0.0,1.0);
  int edgeScale = 10;
  
  //0.2989, 0.5870, 0.1140 greyscale rgb
  //greyscale
	float greyC = (diffuse_color.r*.2989 + diffuse_color.g*.5870 + diffuse_color.b*.1140);
 
//Laplacian Filter  
  //Left
	vec2 left = vec2(vertTexCoord.x-(1.0/255.0),vertTexCoord.y);
    vec4 diffuse_colorL = texture2D(texture, left.xy);
	float greyL = (diffuse_colorL.r*.2989 + diffuse_colorL.g*.5870 + diffuse_colorL.b*.1140);
	
  //Right
  	vec2 right = vec2(vertTexCoord.x+(1.0/255.0),vertTexCoord.y);
    vec4 diffuse_colorR = texture2D(texture, right.xy);
	float greyR = (diffuse_colorR.r*.2989 + diffuse_colorR.g*.5870 + diffuse_colorR.b*.1140);

  //Up
  	vec2 up = vec2(vertTexCoord.x,vertTexCoord.y-(1.0/255.0));
    vec4 diffuse_colorU = texture2D(texture, up.xy);
	float greyU = (diffuse_colorU.r*.2989 + diffuse_colorU.g*.5870 + diffuse_colorU.b*.1140);

  //Down
  	vec2 down = vec2(vertTexCoord.x,vertTexCoord.y+(1.0/255.0));
    vec4 diffuse_colorD = texture2D(texture, down.xy);
    float greyD = (diffuse_colorD.r*.2989 + diffuse_colorD.g*.5870 + diffuse_colorD.b*.1140);

	float grey = clamp((greyL+greyR+greyU+greyD)-(greyC*4),0.0,1.0);
	vec4 greyScale = (grey,grey,grey,1.0);
  gl_FragColor = vec4(grey*5 * greyScale.rgb, 1.0);
 }
