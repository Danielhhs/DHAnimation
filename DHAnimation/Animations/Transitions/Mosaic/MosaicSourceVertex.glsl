#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_columnWidth;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;
layout(location = 3) in vec3 a_columnStartPosition;
layout(location = 4) in float a_rotation;

out vec2 v_texCoords;
out vec3 v_normal;

vec4 updatedPosition()
{
    vec4 position = a_position;
    if (position.x == a_columnStartPosition.x) {
        position.x += u_columnWidth / 2.f * (1.f - cos(a_rotation));
        position.z = u_columnWidth / 2.f * sin(a_rotation);
    } else {
        position.x -= u_columnWidth / 2.f * (1.f - cos(a_rotation));
        position.z = -u_columnWidth / 2.f * sin(a_rotation);
    }
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}