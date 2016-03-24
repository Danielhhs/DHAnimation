#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float pi_2 = 3.1415927 / 2.f;

vec4 updatedPosition()
{
    vec4 position = a_position;
    
    if (position.x != 0.f) {
        float rotation = u_percent * pi_2;
        position.x = a_position.x * cos(rotation);
        position.z = a_position.z * sin(rotation);
    }
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}