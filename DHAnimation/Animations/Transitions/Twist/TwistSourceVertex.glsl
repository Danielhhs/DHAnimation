#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_centerPosition;
uniform int u_direction;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;
layout(location = 4) in float a_rotation;

out vec2 v_texCoords;
out vec3 v_normal;

vec4 updatedPosition() {
    vec4 position = a_position;
    if (u_direction == 0 || u_direction == 1) {
        if (position.y == 0.) {
            position.y = u_centerPosition * (1.f - cos(a_rotation));
            position.z = -u_centerPosition * (sin(a_rotation));
        } else {
            position.y = u_centerPosition * (1.f + cos(a_rotation));
            position.z = u_centerPosition * sin(a_rotation);
        }
        v_normal = vec3(0.f, sin(a_rotation), cos(a_rotation));
    } else {
        if (position.x == 0.) {
            position.x = u_centerPosition * (1.f - cos(a_rotation));
            position.z = -u_centerPosition * sin(a_rotation);
        } else {
            position.x = u_centerPosition * (1.f + cos(a_rotation));
            position.z = u_centerPosition * sin(a_rotation);
        }
        v_normal = vec3(-sin(a_rotation), 0.f, cos(a_rotation));
    }
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}