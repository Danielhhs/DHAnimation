#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_depth;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

void main() {
    vec4 position = a_position;
    position.z = u_depth * (1.f - u_percent);
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}