#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_time;

layout(location = 0) in vec3 a_position;
layout(location = 1) in float a_appearTime;
layout(location = 2) in float a_lifeTime;
layout(location = 3) in vec4 a_color;
layout(location = 4) in float a_shining;

out float v_percent;
out vec4 v_color;
out float v_shining;

const float c_shinging_duration = 0.05;
const float c_shining_gap = 0.3;

bool shouldShine() {
    if (a_shining == 0.f) {
        return false;
    }
    float i = 0.f;
    float t = u_time - a_appearTime;
    while (i * c_shining_gap < a_lifeTime) {
        if (t > i * c_shining_gap && t < i * c_shining_gap + c_shinging_duration) {
            return true;
        }
        i += 1.f;
    }
    return false;
}

void main() {
    if (u_time > a_appearTime && u_time < a_appearTime + a_lifeTime) {
        gl_Position = u_mvpMatrix * vec4(a_position, 1.f);
        v_percent = (u_time - a_appearTime) / a_lifeTime;
        gl_PointSize = 20.f * ((1.f - v_percent) * 0.8 + 0.2);
        v_color = a_color;
        if (shouldShine()) {
            v_shining = 1.f;
        } else {
            v_shining = 0.f;
        }
    } else {
        gl_PointSize = 0.f;
        v_percent = 1.f;
    }
}
