#version 300 es

uniform mat4 u_mvpMatrix;

uniform vec3 u_direction;
uniform float u_radius;
uniform vec3 u_position;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

vec4 updatedPosition() {
    return a_position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}