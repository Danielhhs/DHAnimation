#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_shredderPosition;
uniform float u_time;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;
layout(location = 2) in float a_startY;
layout(location = 3) in float a_length;
layout(location = 4) in float a_radius;
layout(location = 5) in float a_startFallingTime;

out vec2 v_texCoords;
out float v_percent;

vec4 updatedPosition() {
    vec4 position = a_position;
    
    if (u_shredderPosition < a_position.y) {
        v_percent = 1.f;
        return position;
    }
    float l = u_shredderPosition - position.y;
    if (l < a_length) {
        vec3 center = vec3(a_position.x, u_shredderPosition, a_radius);
        float angle = l / a_radius;
        position.x -= l * 0.382;
        position.y = u_shredderPosition - a_radius * sin(angle);
        position.z = a_radius* cos(angle);
    } else {
        l = a_length + a_startY - position.y;
        vec3 center = vec3(a_position.x, a_startY + a_length, a_radius);
        float angle = l / a_radius;
        position.x -= l * 0.382;
        position.y = a_length + a_startY - a_radius * sin(angle);
        position.z = a_radius* cos(angle);
    }
    
    float time = u_time - a_startFallingTime;
    if (time > 0.f) {
        position.y -= 0.5 * 1000.f * time * time;
    }
    v_percent = 0.f;
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}