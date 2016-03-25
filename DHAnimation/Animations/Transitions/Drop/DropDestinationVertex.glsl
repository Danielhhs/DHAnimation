#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_screenHeight;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

vec4 updatedPosition()
{
    vec4 position = a_position;
    position.y += u_screenHeight;
    position.y -= u_percent * u_screenHeight;
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}