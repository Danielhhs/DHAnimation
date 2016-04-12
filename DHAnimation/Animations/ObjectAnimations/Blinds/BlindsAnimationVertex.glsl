#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_direction;
uniform float u_event;
uniform float u_columnWidth;
uniform float u_columnHeight;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;
layout(location = 3) in vec4 a_columnStartPosition;

out vec2 v_texCoords;

const float pi = 3.1416927;
const float pi_2 = pi / 2.f;
const float pi_4 = pi / 4.f;

vec4 updatedPosition()
{
    float percent = u_percent;
    if (u_event == 0.f) {
        percent = 1.f - u_percent;
    }
    float rotation = pi_2 * percent;
    if (u_direction == 0.f || u_direction == 3.f) {
        rotation *= -1.f;
    }
    float rotationRadius;
    vec3 rotationCenter;
    
    vec3 columnCenter;
    vec3 rotationCenterToColumnCenter;
    vec3 columnCenterToVertex;
    
    vec3 vertexRotationVector;
    if (u_direction == 0.f || u_direction == 1.f) {
        rotationRadius = u_columnWidth;
        rotationCenter = vec3(a_columnStartPosition.x + u_columnWidth / 2.f, a_position.y, -rotationRadius);
        columnCenter = vec3(a_columnStartPosition.x + u_columnWidth / 2.f, a_position.y , a_position.z);
        columnCenterToVertex = a_position.xyz - columnCenter;
        if (a_position.x != a_columnStartPosition.x) {
            vertexRotationVector = vec3(u_columnWidth / 2.f * (1.f - cos(rotation)), 0.f, u_columnWidth / 2.f * sin(rotation)) * -1.f;
        } else {
            vertexRotationVector = vec3(u_columnWidth / 2.f * (1.f - cos(rotation)), 0.f, u_columnWidth / 2.f * sin(rotation));
        }
        rotationCenterToColumnCenter = vec3(rotationRadius * sin(rotation), 0.f, rotationRadius * cos(rotation));
    } else {
        rotationRadius = u_columnHeight;
        rotationCenter = vec3(a_position.x, a_columnStartPosition.y + u_columnHeight / 2.f, -rotationRadius);
        columnCenter = vec3(a_position.x, a_columnStartPosition.y + u_columnHeight / 2.f , a_position.z);
        columnCenterToVertex = a_position.xyz - columnCenter;
        if (a_position.y != a_columnStartPosition.y) {
            vertexRotationVector = vec3(0.f, -u_columnHeight / 2.f * (1.f - cos(rotation)), -u_columnHeight / 2.f * sin(rotation));
        } else {
            vertexRotationVector = vec3(0.f, -u_columnHeight / 2.f * (1.f - cos(rotation)), -u_columnHeight / 2.f * sin(rotation)) * -1.f;
        }
        rotationCenterToColumnCenter = vec3(0.f, rotationRadius * sin(rotation), rotationRadius * cos(rotation));
    }
    
    vec4 position = vec4(rotationCenter + rotationCenterToColumnCenter + columnCenterToVertex + vertexRotationVector, 1.f);
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}