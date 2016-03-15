#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_shredderPosition;
uniform float u_fallingDistance;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;
layout(location = 2) in vec2 a_yRange;

out vec2 v_texCoords;
out vec2 v_yRange;
out vec2 v_position;

#define SHREDDER_ANGLE 3.14 / 12.0

void main() {
    vec4 position = a_position;
    if (u_shredderPosition >= a_yRange.x) {
        float anchor = clamp(u_shredderPosition, a_yRange.x, a_yRange.y);
        float d = anchor - position.y;
        
        position.x = position.x - d * sin(SHREDDER_ANGLE);
        position.y = position.y - d * (1.0 - cos(SHREDDER_ANGLE));
        position.z = d * sin(SHREDDER_ANGLE);
    }
    position.y += u_fallingDistance;
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
    v_yRange = a_yRange;
    v_position = a_position.xy;
}