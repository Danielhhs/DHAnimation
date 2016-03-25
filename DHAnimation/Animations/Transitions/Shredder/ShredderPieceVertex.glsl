#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_shredderPosition;
uniform float u_fallingOffDistance;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec3 a_normal;
layout(location = 2) in vec2 a_texCoord;
layout(location = 4) in vec3 a_cylinderCenter;

out vec2 v_texCoord;
out vec3 v_normal;
out vec2 v_position;

#define M_PI 3.14159265358979323846264338327950288

void main() {
    vec4 position = a_position;
    vec3 cylinderCenter = a_cylinderCenter;
    cylinderCenter.y = u_shredderPosition;
    if (position.y <= u_shredderPosition) {
        float angle = (cylinderCenter.y - a_position.y) / cylinderCenter.z;
        position.y = cylinderCenter.y - cylinderCenter.z * sin(angle);
        position.z = cylinderCenter.z * (1.0 - cos(angle));
    }
    position.y = position.y + u_fallingOffDistance;
    gl_Position = u_mvpMatrix * position;
    v_texCoord = a_texCoord;
    v_normal = cylinderCenter - position.xyz;
    v_position = a_position.xy;
}