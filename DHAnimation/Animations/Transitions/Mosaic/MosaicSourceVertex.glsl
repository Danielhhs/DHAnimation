#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_columnWidth;
uniform float u_time;
uniform float u_rotationTime;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;
layout(location = 3) in vec3 a_columnStartPosition;
layout(location = 5) in vec3 a_originalCenter;
layout(location = 8) in float a_startTime;

out vec2 v_texCoords;
out vec3 v_normal;

const float pi = 3.1415927;

vec4 updatedPosition()
{
    vec4 position = a_position;
    float time = u_time - a_startTime;
    if (time < 0.f) {
        v_normal = vec3(0.f, 0.f, 1.f);
        return position;
    }
    float percent = time / u_rotationTime;
    percent = min(percent, 1.f);
    float rotation = pi * percent;
    if (position.x == a_columnStartPosition.x) {
        position.x += u_columnWidth / 2.f * (1.f - cos(rotation));
        position.z = u_columnWidth / 2.f * sin(rotation);
    } else {
        position.x -= u_columnWidth / 2.f * (1.f - cos(rotation));
        position.z = -u_columnWidth / 2.f * sin(rotation);
    }
    vec3 pos = position.xyz - a_originalCenter;
    if (a_position.x < a_originalCenter.x) {
        pos = a_originalCenter - position.xyz;
    }
    v_normal = vec3(-pos.z, 0.f, pos.x);
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}