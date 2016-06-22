#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_event;
uniform float u_time;
uniform float u_duration;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;
layout(location = 2) in vec2 a_center;
layout(location = 3) in float a_startTime;
layout(location = 4) in float a_lifeTime;
layout(location = 5) in float a_offset;

out vec2 v_texCoords;

float easeInOut(float t, float b, float c, float d) {
    if ((t/=d/2.f) < 1.f) return c/2.f*t*t*t + b;
    return c/2.f*((t-=2.f)*t*t + 2.f) + b;
}

vec4 updatedPosition() {
    float time = u_time;
    if (u_event == 1.f) {
        time = u_duration - u_time;
    }
    time = time - a_startTime;
    if (time < 0.f) {
        return vec4(0.f);
    } else if (time > a_lifeTime) {
        return a_position;
    }
    float percent = easeInOut(time * 1000.f, 0.f, 1.f, a_lifeTime * 1000.f);

    float scale = mix(0.2f, 1.f, percent);
    vec2 center = a_center;
    vec2 centerToPosition = (a_position.xy - a_center) * scale;
    center.x += a_offset * (1.f - percent);
    vec4 position = vec4(center + centerToPosition, 0.f, 1.f);
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}