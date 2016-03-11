#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_centerPosition;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;
layout(location = 4) in float a_rotation;

out vec2 v_texCoords;

void main() {
    vec4 position = a_position;
    if (position.y == 0.) {
        position.y = u_centerPosition * (1.f - cos(a_rotation));
        position.z = -u_centerPosition * (sin(a_rotation));
    } else {
        position.y = u_centerPosition * (1.f + cos(a_rotation));
        position.z = u_centerPosition * sin(a_rotation);
    }
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;

}