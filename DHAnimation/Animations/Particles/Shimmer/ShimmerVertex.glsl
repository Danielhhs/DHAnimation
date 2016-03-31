#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_cellWidth;
uniform float u_cellHeight;
uniform float u_percent;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float pi = 3.1415927;
const float pi_4 = pi / 4.f;

vec4 updatedPosition() {
    vec4 position = a_position;
    float centerX = u_cellWidth / 2.f;
    float centerY = u_cellHeight / 2.f;
    float r = sqrt(centerX * centerX + centerY * centerY);
    float rotation = u_percent * pi * 2.f;
    float rotationOffset = 0.f;
    if (a_position.x == 0.f) {
        if (a_position.y == 0.f) {
            rotationOffset = pi + pi_4;
        } else {
            rotationOffset = -pi_4;
        }
    } else {
        if (a_position.y == 0.f) {
            rotationOffset = pi - pi_4;
        } else {
            rotationOffset = pi_4;
        }
    }
    position.x = centerX + r * sin(rotationOffset + rotation);
    position.y = centerY + r * cos(rotationOffset + rotation);
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}