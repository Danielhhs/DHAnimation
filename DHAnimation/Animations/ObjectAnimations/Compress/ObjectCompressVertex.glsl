#version 300 es

uniform mat4 u_mvpMatrix;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

void main() {
    gl_Position = u_mvpMatrix * a_position;
    v_texCoords = a_texCoords;
}