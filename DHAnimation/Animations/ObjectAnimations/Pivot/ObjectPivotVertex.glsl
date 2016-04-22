#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform vec3 u_anchorPoint;
uniform float u_yOffset;
uniform float u_event;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float pi = 3.1415927;

vec4 updatedPosition()
{
    float percent = u_percent;
    if (u_event == 0.f) {
        percent = 1.f - u_percent;
    }
    vec4 position = a_position;
    float radius = distance(a_position.xyz, u_anchorPoint);;
    float angle = 0.f;
    if (a_position.x == u_anchorPoint.x) {
        if (a_position.y != u_anchorPoint.y) {
            angle = 0.f;
        }
    }
    if (a_position.y == u_anchorPoint.y) {
        if (a_position.x != u_anchorPoint.x) {
            angle = pi / 2.f;
        }
    }
    if (a_position.x != u_anchorPoint.x && a_position.y != u_anchorPoint.y) {
        angle = pi / 4.f;
    }
    float rotation = angle - percent * pi / 4.f;
    position.x = radius * sin(rotation) + u_anchorPoint.x;
    position.y = radius * cos(rotation) + u_anchorPoint.y;
    
    position.y += u_yOffset * percent;
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}