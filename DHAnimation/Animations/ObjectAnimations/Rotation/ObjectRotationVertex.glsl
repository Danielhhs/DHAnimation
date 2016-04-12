#version 300 es

uniform mat4 u_mvpMatrix;
uniform vec2 u_targetCenter;
uniform float u_percent;
uniform float u_rotationRadius;
uniform float u_targetWidth;
uniform float u_direction;
uniform float u_event;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;
layout(location = 3) in vec4 a_columnStartPosition;

out vec2 v_texCoords;

const float pi = 3.1415927;

vec4 updatedPosition()
{
    float percent = u_percent;
    if (u_event != 1.f) {
        percent = 1.f - u_percent;
    }
    float rotation = pi * percent;
    if (u_direction != 0.f) {
        rotation *= -1.f;
    }
    vec3 rotationCenterToTargetCenter = vec3(u_rotationRadius * sin(rotation), 0.f , u_rotationRadius * cos(rotation));
    vec3 vertexToTargetCenter = a_position.xyz - vec3(u_targetCenter, a_position.z);
    vec3 rotationCenter = vec3(u_targetCenter, -u_rotationRadius);
    vec3 vertexRotationVector;
    if (a_position.x == a_columnStartPosition.x) {
        vertexRotationVector = vec3(u_targetWidth / 2.f * (1.f - cos(rotation)), 0.f, u_targetWidth / 2.f * sin(rotation));
    } else {
        vertexRotationVector = vec3(-u_targetWidth / 2.f * (1.f - cos(rotation)), 0.f, -u_targetWidth / 2.f * sin(rotation));
    }
    vec4 position = vec4(rotationCenter + rotationCenterToTargetCenter + vertexToTargetCenter + vertexRotationVector, 1.f);
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}