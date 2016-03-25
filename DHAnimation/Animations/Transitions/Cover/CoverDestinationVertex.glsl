#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_screenHeight;
uniform float u_percent;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;
out vec3 v_normal;

vec4 updatedPosition()
{
    vec4 position = a_position;
    v_normal = vec3(0.f, 0.f, 1.f);
    vec4 positionToCenter = a_position;
    if (a_position.y < u_screenHeight / 2.f) {
        float rotation = 3.1415927 * u_percent;
        positionToCenter.y = (u_screenHeight / 2.f - a_position.y) * cos(rotation);
        positionToCenter.z = (u_screenHeight / 2.f - a_position.y) * sin(rotation);
        position = vec4(0.f, u_screenHeight / 2.f, 0.f, 0.f) + positionToCenter;
        v_normal = vec3(0.f, sin(rotation), -cos(rotation));
    }
    
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}