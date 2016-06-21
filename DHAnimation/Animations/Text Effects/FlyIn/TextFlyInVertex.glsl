#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_event;
uniform float u_offset;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;
layout(location = 2) in vec2 a_center;

out vec2 v_texCoords;

vec4 updatedPosition() {
    float scale = mix(0.2, 1.f, u_percent);
    vec2 centerToPosition = (a_center - a_position.xy) * scale;
    
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}