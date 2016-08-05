#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_shredderPosition;
uniform float u_time;
uniform float u_duration;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;
layout(location = 2) in float a_startY;
layout(location = 3) in float a_length;
layout(location = 4) in float a_radius;
layout(location = 5) in float a_startFallingTime;
layout(location = 6) in vec3 a_direction;

out vec2 v_texCoords;
out float v_percent;

#define M_PI 3.14159265358979323846264338327950288

vec4 curledPosition() {
    float yPos = min(u_shredderPosition, a_startY + a_length);
    vec3 center = vec3(a_position.x, yPos, a_radius);
    float l = yPos - a_position.y;
    float angle = l / a_radius;
    vec4 position = a_position;
    position.y = yPos - a_radius * sin(angle);
    position.z = a_radius * (1.f - cos(angle));
    return position;
}

vec4 updatedPosition() {
    vec4 position = a_position;
    
    if (u_shredderPosition < a_position.y) {
        v_percent = 1.f;
        return position;
    }
    
    float yPos = min(u_shredderPosition, a_startY + a_length);
    float l = yPos - a_position.y;
    vec3 offset = l * a_direction;
    position.xyz += offset;
    
    float time = u_time - a_startFallingTime;
    if (time > 0.f) {
        float fallingTime = u_duration - a_startFallingTime;
        float gravity = (a_startY + a_length) * 2.f / fallingTime / fallingTime + 100.f;
        gravity = max(gravity, 1000.f);
        position.y -= 0.5 * gravity * time * time;
    }
    v_percent = 0.f;
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}