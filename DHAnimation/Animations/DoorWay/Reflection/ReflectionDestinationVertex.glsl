#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_screenWidth;
uniform float u_maxRotation;
uniform int u_direction;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;
out vec3 v_normal;

vec4 updatedPosition()
{
    vec4 position = a_position;
    
    if (u_direction == 0) {
        if (a_position.x == 0.f) {
            position.z = u_screenWidth;
        } else {
            position.x = 0.f;
        }
    } else {
        if (a_position.x == 0.f) {
            position.x = u_screenWidth;
        } else {
            position.z = u_screenWidth;
        }
    }
    
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
    v_normal = vec3(1.f, 0.f, 0.f);
}