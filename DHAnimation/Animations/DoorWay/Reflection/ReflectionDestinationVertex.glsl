#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_screenWidth;
uniform float u_maxRotation;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

vec4 updatedPosition()
{
    vec4 position = a_position;
    
    float rotation = u_maxRotation * u_percent;
    position.x = u_screenWidth * cos(rotation);
    position.z = -1.f * u_screenWidth * sin(rotation);
    
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * a_position;
    v_texCoords = a_texCoords;
}