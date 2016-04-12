#version 300 es

uniform mat4 u_mvpMatrix;
uniform vec2 u_targetCenter;
uniform float u_percent;
uniform float u_rotationRadius;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float pi = 3.1415927;

vec4 updatedPosition()
{
    float rotation = pi * u_percent;
    vec3 rotationCenterToTargetCenter = vec3(u_rotationRadius * sin(rotation), 0.f , u_rotationRadius * cos(rotation));
    vec3 vertexToTargetCenter = a_position.xyz - vec3(u_targetCenter, a_position.z);
    vec3 rotationCenter = vec3(u_targetCenter, -u_rotationRadius);
    vec4 position = vec4(rotationCenter + rotationCenterToTargetCenter + vertexToTargetCenter, 1.f);
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}