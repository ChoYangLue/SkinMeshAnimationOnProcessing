#version 150

uniform mat4 transform;
uniform float time;

in vec3 position;
in vec4 color;

in vec3 boneind;
in vec3 boneweight;

uniform vec3 bof[2];
uniform vec3 ibof[2];

out vec4 vertColor;

mat4 rotate(float th, vec3 p) {
  mat4 RM;
  RM[0] = vec4(p[0]*p[0]*(1.0-cos(th))+cos(th), p[0]*p[1]*(1.0-cos(th))-p[2]*sin(th), p[0]*p[2]*(1.0-cos(th))+p[1]*sin(th), 0.0);
  RM[1] = vec4(p[0]*p[1]*(1.0-cos(th))+p[2]*sin(th), p[1]*p[1]*(1.0-cos(th))+cos(th), p[1]*p[2]*(1.0-cos(th))-p[0]*sin(th), 0.0);
  RM[2] = vec4(p[0]*p[2]*(1.0-cos(th))-p[1]*sin(th), p[2]*p[1]*(1.0-cos(th))+p[0]*sin(th), p[2]*p[2]*(1.0-cos(th))+cos(th), 0.0);
  RM[3] = vec4(0.0, 0.0, 0.0, 1.0);
  return RM;
}

mat4 trans(vec3 p) {
  mat4 TM;
  TM[0] = vec4(1.0, 0.0, 0.0, 0.0);
  TM[1] = vec4(0.0, 1.0, 0.0, 0.0);
  TM[2] = vec4(0.0, 0.0, 1.0, 0.0);
  TM[3] = vec4(p[0], p[1], p[2], 1.0);
  return TM;
}

void main() {
  //gl_Position = transform * rotate(time, vec3(0,0,1)) * vec4(position, 1.0);
  vertColor = color;
  float TT = time;
  
  if (boneind[0] == 0) {
    TT = 0;
  } 

  //vertColor = vec4(boneind[0], 0.0, 0.0, 1.0);
  
  //bonem = vec3(400,300,0);vec3(-100,-150,0)
  
  gl_Position = transform * trans(bof[int(boneind[0])]) * rotate(sin(TT)*boneweight[0], vec3(0,0,1)) * trans(ibof[int(boneind[0])])  * vec4(position, 1.0);
  //gl_Position = transform * trans(vec3(400,300,0)) * rotate(sin(TT), vec3(0,0,1)) * trans(vec3(-100,-150,0)) * vec4(position, 1.0) ;
  
}