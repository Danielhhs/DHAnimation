#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_event;
uniform vec2 u_center;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float rotation = 2.f * 3.1415927;

vec4 updatedPosition() {
    vec4 position = a_position;
    
    position.x = u_center.x + (a_position.x - u_center.x) * cos(u_percent * rotation);
    position.z = (a_position.x - u_center.x) * sin(u_percent * rotation);
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}