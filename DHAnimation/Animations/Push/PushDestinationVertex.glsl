#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform int u_direction;
uniform float u_screenWidth;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

vec4 updatedPosition()
{
    vec4 position = a_position;
    if (u_direction == 0) {
        position.x -= u_screenWidth;
        position.x += u_percent * u_screenWidth;
    } else {
        position.x += u_screenWidth;
        position.x -= u_percent * u_screenWidth;
    }
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}