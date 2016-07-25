#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_minStartTime;
uniform float u_startTimeRange;
uniform float u_time;
uniform float u_duration;
uniform float u_blowingTimeRatio;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;
layout(location = 6) in vec4 a_offset;
layout(location = 8) in float a_startTime;

out vec2 v_texCoords;
out float v_percent;

float NSBKeyframeAnimationFunctionEaseOutExpo(float t, float b, float c, float d)
{
    return (t==d) ? b+c : c * (-pow(2.f, -10.f * t/d) + 1.f) + b;
}

vec4 updatedPosition() {
    vec4 position = a_position;
    
    float time = u_time - (a_startTime - u_minStartTime) / u_startTimeRange * u_duration * (1.f - u_blowingTimeRatio);
    if (time < 0.f) {
        return position;
    }
    
    float percent = NSBKeyframeAnimationFunctionEaseOutExpo(time * 1000.f, 0.f, 1.f, u_duration * u_blowingTimeRatio * 1000.f);
    v_percent = percent;
    
    position += a_offset * percent;
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}