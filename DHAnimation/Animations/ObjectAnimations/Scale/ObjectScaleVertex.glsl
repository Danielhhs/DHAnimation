#version 300 es

uniform mat4 u_mvpMatrix;
uniform vec2 u_center;
uniform vec2 u_resolution;
uniform float u_percent;
uniform float u_event;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

vec4 updatedPosition()
{
    float percent = u_percent;
    if (u_event == 1.f) {
        percent = 1.f - u_percent;
    }
    vec4 position = a_position;
    position.x = (a_position.x - u_center.x) * percent + u_center.x;
    position.y = (a_position.y - u_center.y) * percent + u_center.y;
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}