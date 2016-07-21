#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_crackTimeRatio;
uniform float u_duration;
uniform float u_time;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;
layout(location = 4) in float a_rotation;
layout(location = 6) in vec3 a_targetPosition;
layout(location = 8) in float a_startTime;

out vec2 v_texCoords;
out float v_percent;

vec4 updatedPosition()
{
    vec4 position = a_position;
    
    float time = u_time - a_startTime * u_duration * u_crackTimeRatio;
    if (time < 0.f) {
        v_percent = 0.f;
        return position;
    }
    float percent = time / (1.f - u_crackTimeRatio) / u_duration;
    position += (vec4(a_targetPosition, 1.f) - a_position) * percent;
    v_percent = percent;
    
    float rotation = percent * a_rotation;
    
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}