#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform vec2 u_center;
uniform float u_columnWidth;
uniform float u_event;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;
layout(location = 3) in vec4 a_columnStartPosition;

out vec2 v_texCoords;

const float pi = 3.1415927;

vec4 updatedPosition() {
    float percent = u_percent;
    if (u_event == 1.f) {
        percent = 1.f - u_percent;
    }
    float rotation = percent * pi;
    vec4 position = a_position;

    float radius = u_columnWidth / 2.f;
    if (a_position.x == a_columnStartPosition.x) {
        position.x = u_center.x - radius * cos(rotation);
        position.z = radius * sin(rotation);
    } else {
        position.x = u_center.x + radius * cos(rotation);
        position.z = -radius * sin(rotation);
    }
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}