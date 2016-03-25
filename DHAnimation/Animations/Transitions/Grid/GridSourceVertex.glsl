#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_screenWidth;
uniform int u_direction;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float zoomInRatio = 0.2;
const float zoomInStopRatio = 0.1;
const float zoomOutRatio = 0.2;
const float zoomOutStopRatio = 0.1;
const float transitionRatio = 0.4;

vec4 updatedPosition()
{
    vec4 position = a_position;
    if (u_percent <= zoomOutRatio) {
        position.z = -1.f * u_percent / zoomInRatio * 500.f;
    } else if (u_percent <= zoomOutRatio + zoomOutStopRatio){
        position.z = -500.f;
    } else if (u_percent <= zoomOutRatio + zoomOutStopRatio + transitionRatio) {
        position.z = -500.f;
        float offset = (u_percent - zoomOutRatio - zoomOutStopRatio) / transitionRatio * u_screenWidth * 1.5;
        if (u_direction == 1) {
            offset *= -1.f;
        }
        position.x -= offset;
    } else {
        position.x -= u_screenWidth * 1.5;
    }
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}