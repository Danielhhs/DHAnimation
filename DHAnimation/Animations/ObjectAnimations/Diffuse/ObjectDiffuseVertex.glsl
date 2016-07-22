#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_crackTimeRatio;
uniform float u_duration;
uniform float u_time;
uniform float u_explosionPosition;
uniform float u_direction;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;
layout(location = 4) in float a_rotation;
layout(location = 5) in vec3 a_center;
layout(location = 6) in vec3 a_targetPosition;
layout(location = 8) in float a_startTime;

out vec2 v_texCoords;
out float v_percent;

float NSBKeyframeAnimationFunctionEaseOutExpo(float t, float b, float c, float d)
{
    return (t==d) ? b+c : c * (-pow(2.f, -10.f * t/d) + 1.f) + b;
}

vec4 updatedPosition()
{
    vec4 position = a_position;
    
    float startTime = a_startTime;
    if (u_direction != 0.f) {
        startTime = 1.f - a_startTime;
    }
    float time = u_time - startTime * u_duration * u_crackTimeRatio;
    if (time < 0.f) {
        v_percent = 0.f;
        return position;
    }
    float percent = NSBKeyframeAnimationFunctionEaseOutExpo(time * 1000.f, 0.f, 1.f, (1.f - u_crackTimeRatio) * u_duration * 1000.f);
    vec4 offset = vec4(a_targetPosition, 1.f) - a_position;
    if (u_direction != 0.f) {
        offset.x *= -1.f;
    }
    position += offset * percent;
    position.x += (u_explosionPosition - a_position.x);
    v_percent = percent;
    
    float rotation = percent * a_rotation;
    
    float radius = a_position.x - a_center.x;
    position.z += radius * sin(rotation);
    position.x -= radius * (1.f - cos(rotation));
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}