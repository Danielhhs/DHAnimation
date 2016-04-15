#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_elapsedTime;
uniform float u_emissionTime;

layout(location = 0) in vec3 a_emissionPosition;
layout(location = 1) in vec3 a_emissionDirection;
layout(location = 2) in float a_emissionVelocity;
layout(location = 3) in vec3 a_emissionForce;
layout(location = 4) in float a_emissionTime;
layout(location = 5) in float a_lifeTime;
layout(location = 6) in float a_size;
layout(location = 7) in float a_shouldUpdatePosition;
layout(location = 8) in float a_offset;

vec4 updatedPosition()
{
    vec3 position = a_emissionPosition + normalize(a_emissionDirection) * a_offset;
    float time = (u_elapsedTime - u_emissionTime);
    if (a_shouldUpdatePosition == 0.f) {
        time = (a_emissionTime - u_emissionTime);
    }
    position = a_emissionVelocity * time * a_emissionDirection + a_emissionPosition + 0.5 * (a_emissionForce) * time * time;
    return vec4(position, 1.f);
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    gl_PointSize = a_size;
    if (u_elapsedTime - a_emissionTime > a_lifeTime) {
        gl_PointSize = 0.f;
    }
}
