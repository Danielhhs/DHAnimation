#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_time;
uniform float u_duration;
uniform float u_shredderDisappearTime;
uniform float u_maxShredderPosition;
uniform float u_shredderPosition;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;
layout(location = 2) in float a_radius;
layout(location = 3) in float a_columnCenter;
layout(location = 4) in float a_shredderedZOffset;

out vec2 v_texCoords;
out float v_columnCenter;
out float v_shredderedZOffset;

vec4 updatedPosition() {
    vec4 position = a_position;
    
    if (a_position.y > u_shredderPosition) {
        return position;
    }
    
    if (u_time < u_duration - u_shredderDisappearTime) {
        vec3 centerPosition = vec3(position.x, u_shredderPosition, a_radius);
        
        float len = u_shredderPosition - a_position.y;
        float angle = len / a_radius;
        position.y = u_shredderPosition - a_radius * sin(angle);
        position.z = a_radius * (1.f - cos(angle));
        position.z += a_shredderedZOffset;
    } else {
        vec3 centerPosition = vec3(position.x, u_maxShredderPosition, a_radius);
        
        float len = u_shredderPosition - a_position.y;
        float angle = len / a_radius;
        position.y = u_shredderPosition - a_radius * sin(angle);
        position.z = a_radius * (1.f - cos(angle));
        position.z += a_shredderedZOffset;
        
        float percent = (u_time - (u_duration - u_shredderDisappearTime)) / u_shredderDisappearTime;
        position.y -= percent * (u_maxShredderPosition * 1.2);
    }
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
    v_columnCenter = a_columnCenter;
    v_shredderedZOffset = a_shredderedZOffset;
}