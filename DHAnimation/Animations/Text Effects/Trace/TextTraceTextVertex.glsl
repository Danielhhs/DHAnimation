#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_time;
uniform float u_duration;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;

out vec2 v_texCoords;
out float v_percent;

void main() {
    gl_Position = u_mvpMatrix * a_position;
    v_texCoords = a_texCoords;
    v_percent = u_time / u_duration;
}