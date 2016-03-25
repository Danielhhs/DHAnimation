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

vec4 updatedPosition() {
    vec4 position = a_position;
    
    if (u_percent <= zoomOutRatio) {
        position.x += 1.5 * u_screenWidth;
    } else if (u_percent <= zoomOutRatio + zoomOutStopRatio) {
        position.x += 1.5 * u_screenWidth;
        position.z = -500.f;
    } else if (u_percent <= zoomOutRatio + zoomOutStopRatio + transitionRatio) {
        float offset = (1.f - (u_percent - zoomOutRatio - zoomOutStopRatio) / transitionRatio) * 1.5 * u_screenWidth;
        if (u_direction == 1) {
            offset *= -1.f;
        }
        position.x += offset;
        position.z = -500.f;
    } else if (u_percent <= zoomOutStopRatio + zoomOutRatio + transitionRatio + zoomInStopRatio) {
        position.z = -500.f;
    } else {
        position.z = (1.f - (u_percent - zoomOutRatio - transitionRatio - zoomInStopRatio - zoomOutStopRatio) / zoomInRatio) * -500.f;
    }
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}