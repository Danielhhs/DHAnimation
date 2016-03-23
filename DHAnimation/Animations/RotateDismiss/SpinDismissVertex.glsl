#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_screenWidth;
uniform float u_screenHeight;
uniform float u_spinRatio;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;
out vec3 v_normal;

const float pi = 3.1415927;
const float c_zDepth = -500.f;

vec4 rotatedPosition()
{
    vec4 position = a_position;
    float centerX = u_screenWidth / 2.f;
    float xDist = a_position.x - centerX;
    float percent = min(u_percent / u_spinRatio, 1.f);
    float rotation = percent * pi;
    position.x = centerX + xDist * cos(rotation);
    position.z = xDist * sin(rotation);
    position.z = percent * c_zDepth;
    v_normal = vec3(sin(rotation), 0.f, cos(rotation));
    if (u_percent >= u_spinRatio / 2.f ){
        v_normal *= -1.f;
    }
    return position;
}

vec4 updatedPosition()
{
    vec4 position = rotatedPosition();
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}