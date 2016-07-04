#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform vec3 u_anchorPoint;
uniform float u_yOffset;
uniform float u_event;
uniform vec2 u_center;

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
    float xSign = 1.f;
    float ySign = 1.f;
    float rotationDirection = 1.f;
    float radius = distance(a_position.xyz, u_anchorPoint);
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
    if (a_position.x < u_anchorPoint.x) {
        xSign = -1.f;
        rotationDirection = -1.f;
    }
    if (a_position.y < u_anchorPoint.y) {
        ySign = -1.f;
        rotationDirection = -1.f;
    }
    if (a_position.x != u_anchorPoint.x && a_position.y != u_anchorPoint.y) {
        if (a_position.x < u_anchorPoint.x) {
            angle = pi * 1.5 + atan((a_position.y - u_anchorPoint.y) / (a_position.x - u_anchorPoint.x));
        } else {
            angle = pi / 2.f - atan((a_position.y - u_anchorPoint.y) / (a_position.x - u_anchorPoint.x));
        }
        xSign = 1.f;
    }
    float rotation = angle - rotationDirection * percent * pi / 4.f;
    
    position.x = xSign * radius * sin(rotation) + u_anchorPoint.x;
    position.y = ySign * radius * cos(rotation) + u_anchorPoint.y;
    
    position.y += u_yOffset * percent;
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}