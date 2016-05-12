#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_pointSize;

layout(location = 0) in vec4 a_startingPosition;
layout(location = 1) in vec4 a_targetingPosition;

void main() {
    vec4 updatedPosition = a_startingPosition + (a_targetingPosition - a_startingPosition) * u_percent;
    gl_Position = u_mvpMatrix * updatedPosition;
    gl_PointSize = u_pointSize;
    if (u_percent <= 0.f) {
        gl_PointSize = 0.f;
    }
}