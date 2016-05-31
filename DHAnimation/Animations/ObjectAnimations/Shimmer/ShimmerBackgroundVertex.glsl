#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_event;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;
layout(location = 5) in vec4 a_originalCenter;

out vec2 v_texCoords;

const float transitionRatio = 0.7;

vec4 updatedPosition()
{
    float percent = u_percent;
    if (u_event != 0.f) {
        percent = 1.f - u_percent;
    }
    if (percent < transitionRatio) {
        vec4 position = a_originalCenter + (a_position - a_originalCenter) * percent / transitionRatio;
        return position;
    } else {
        return a_position; 
    }
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}