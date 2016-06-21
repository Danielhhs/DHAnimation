#version 300 es

uniform mat4 u_mvpMatrix;
uniform vec2 u_center;
uniform float u_percent;
uniform float u_rotation;
uniform float u_event;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;
layout(location = 2) in float a_direction;
layout(location = 3) in float a_radius;

out vec2 v_texCoords;

const float pi = 3.1415927;
const float totalRotation = pi * 2.f;

vec2 rotatedPositionToCenter(vec2 center) {
    float percent = u_percent;
    if (u_event == 1.f) {
        percent = 1.f - u_percent;
    }
    vec2 position = a_position.xy;
    
    float rotation;
    vec2 posToCenter = position - center;
    if (position.x > center.x && position.y > center.y) {
        rotation = atan(posToCenter.y / posToCenter.x);
    } else if (position.x < center.x && position.y > center.y) {
        rotation = atan(posToCenter.y / posToCenter.x) + pi;
    } else if (position.x < center.x && position.y < center.y) {
        rotation = atan(posToCenter.y / posToCenter.x) + pi;
    } else {
        rotation = atan(posToCenter.y / posToCenter.x);
    }
    
    float radius = distance(position, center);
    
    position.x = radius * cos(rotation + percent * totalRotation);
    position.y = radius * sin(rotation + percent * totalRotation);
    return position;
}

vec4 updatedPosition() {
    float percent = u_percent;
    if (u_event == 1.f) {
        percent = 1.f - u_percent;
    }
    vec2 a_center = vec2(u_center.x + a_radius, u_center.y);
    vec2 centerToPosition = rotatedPositionToCenter(a_center);
    float angle = u_rotation * percent;
    
    if (a_direction == -1.f) {
        angle *= -1.f;
    }
    float centerX = a_radius * cos(angle);
    float centerY = a_radius * sin(angle);
    vec2 updatedCenter = u_center  + vec2(centerX, centerY);
    return vec4(updatedCenter + centerToPosition, 0.f, a_position.w);
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}