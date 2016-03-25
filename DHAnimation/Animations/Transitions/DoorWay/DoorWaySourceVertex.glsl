#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_columnWidth;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;
layout(location = 3) in vec3 a_columnStartPosition;

out vec2 v_texCoords;
out vec3 v_normal;

const float pi = 3.141592654;

vec4 updatedPosition() {
    vec4 position = a_position;
    float alpha = pi / 4.f * u_percent;
    if (a_columnStartPosition.x == 0.f) {
        float offset = u_columnWidth * sin(pi / 4.f) * u_percent;
        if (a_position.x != 0.f) {
            position.x = a_position.x * cos(alpha);
            position.z = -1.f * a_position.x * sin(alpha);
        }
        position.x -= offset;
        position.z += offset;
        v_normal = vec3(sin(alpha), 0.f, cos(alpha));
    } else {
        float offset = u_columnWidth * sin(pi / 4.f) * u_percent;
        if (a_position.x == a_columnStartPosition.x) {
            position.x = a_position.x + a_position.x * (1.f - cos(alpha));
            position.z = -1.f * a_position.x * sin(alpha);
        }
        position.x += offset;
        position.z += offset;
        v_normal = vec3(-sin(alpha), 0.f, cos(alpha));
    }
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}