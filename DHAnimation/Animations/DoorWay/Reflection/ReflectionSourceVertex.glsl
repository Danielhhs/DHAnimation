#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_screenWidth;
uniform float u_rotatePosition;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;
out vec3 v_normal;

void main() {
    gl_Position = u_mvpMatrix * a_position;
    v_texCoords = a_texCoords;
    v_normal = vec3(0.f, 0.f, 1.f);
}