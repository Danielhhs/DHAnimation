#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_direcction;
uniform float u_event;
uniform float u_percent;
uniform vec2 u_targetXPositionRange;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;
out float v_shouldShow;

void main()
{
    gl_Position = u_mvpMatrix * a_position;
    v_texCoords = a_texCoords;
    float range = u_targetXPositionRange.y - u_targetXPositionRange.x;
    if (a_position.x < u_targetXPositionRange.x + range * u_percent) {
        v_shouldShow = 0.f;
    } else {
        v_shouldShow = 1.f;
    }
}