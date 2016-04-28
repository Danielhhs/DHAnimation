#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_yOffset;
uniform float u_time;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float fallTime = 0.3;
const float bounceTime = 0.05;
const float bounceOffset = 10.f;

vec4 updatedPosition() {
    vec4 position = a_position;
    
    if (u_time <= fallTime) {
        float g = 2.f * u_yOffset / fallTime / fallTime;
        
        position.y += u_yOffset;
        position.y -= 0.5 * g * u_time * u_time;
    } else if (u_time <= fallTime + bounceTime) {
        position.y += (u_time - fallTime) / bounceTime * bounceOffset;
    } else if (u_time <= fallTime + 2.f * bounceTime) {
        position.y += bounceOffset;
        position.y -= (u_time - fallTime - bounceTime) / bounceTime * bounceOffset;
    }
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}