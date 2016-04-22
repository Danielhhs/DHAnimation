#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_event;
uniform float u_percent;
uniform vec2 u_center;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

vec4 updatedPosition() {
    vec4 position = a_position;
    float percent = u_percent;
    if (u_event == 1.f) {
        percent = 1.f - u_percent;
    }
    
    float scale = 3.f - (3.f - 1.f) * percent;
    position.x = u_center.x + (a_position.x - u_center.x) * scale;
    position.y = u_center.y + (a_position.y - u_center.y) * scale;
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}