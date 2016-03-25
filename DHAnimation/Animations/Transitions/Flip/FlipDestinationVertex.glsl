#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_screenWidth;
uniform float u_screenHeight;
uniform float u_percent;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;
out vec3 v_normal;

vec4 updatedPosition()
{
    float rotation = u_percent * 3.1416927;
    vec4 position = a_position;
    float centerX = u_screenWidth / 2.f;
    float xDist = a_position.x - centerX;
    position.x = centerX + xDist * cos(rotation);
    position.z = xDist * sin(rotation);
    v_normal = vec3(0.f, sin(rotation), -cos(rotation));
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}