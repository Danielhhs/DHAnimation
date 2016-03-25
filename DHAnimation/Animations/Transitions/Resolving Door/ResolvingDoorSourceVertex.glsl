#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_prepareRatio;
uniform float u_pauseRatio;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float pi_2 = 3.1415927 / 2.f;

vec4 updatedPosition()
{
    vec4 position = a_position;
    
    if (u_percent < u_prepareRatio) {
        if (position.x != 0.f) {
            float rotation = -u_percent / u_prepareRatio * pi_2 / 3.f;
            position.x = a_position.x * cos(rotation);
            position.z = a_position.z * sin(rotation);
        }
    } else if (u_percent < u_prepareRatio + u_pauseRatio) {
        
        if (position.x != 0.f) {
            float rotation = - pi_2 / 3.f;
            position.x = a_position.x * cos(rotation);
            position.z = a_position.z * sin(rotation);
        }
    } else {
        if (position.x != 0.f) {
            float rotation = -pi_2 / 3.f + (u_percent - u_prepareRatio - u_pauseRatio) / (1.f - u_prepareRatio - u_pauseRatio) * (pi_2 + pi_2 / 3.f);
            position.x = a_position.x * cos(rotation);
            position.z = a_position.z * sin(rotation);
        }
    }
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}