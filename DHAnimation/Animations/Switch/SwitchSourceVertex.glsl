#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_screenWidth;
uniform float u_screenHeight;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float pi = 3.1415927;
const float pi_4 = pi / 4.f;

vec4 updatedPositionForRotation(float rotation) {
    vec4 position = a_position;
    if (a_position.x == 0.f && a_position.y == 0.f) {
        return position;
    }
    if (a_position.x != 0.f) {
        position.x = u_screenWidth * cos(rotation);
        position.y = u_screenWidth * sin(rotation);
        if (a_position.y != 0.f) {
            position.y += u_screenHeight * cos(rotation);
            position.x -= u_screenHeight * sin(rotation);
        }
    }
    if (a_position.y != 0.f && a_position.x == 0.f) {
        position.x = -u_screenHeight * sin(rotation);
        position.y = u_screenHeight * cos(rotation);
    }
    return position;
}

vec4 updatedPosition() {
    vec4 position = a_position;
    float rotation = 0.f;
    if (u_percent < 0.5) {
        rotation = pi_4 * u_percent / 0.5;
    } else {
        rotation = pi_4 - pi_4 * (u_percent - 0.5) / 0.5;
    }
    position = updatedPositionForRotation(rotation);
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}