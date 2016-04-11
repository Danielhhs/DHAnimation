#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_elapsedTime;

layout(location = 0) in vec3 a_emitterPosition;
layout(location = 1) in vec3 a_emitterVelocity;
layout(location = 2) in vec3 a_emitterGravity;
layout(location = 3) in float a_emitTime;
layout(location = 4) in float a_lifeTime;
layout(location = 5) in float a_size;

vec4 updatedPosition(float elapsedTime)
{
    vec3 position = a_emitterVelocity * elapsedTime + 0.5 * a_emitterGravity * elapsedTime * elapsedTime + a_emitterPosition;
    return vec4(position,1.f);
}

void main() {
    float elapsedTime = u_elapsedTime - a_emitTime;
    vec4 position = updatedPosition(elapsedTime);
    gl_Position = u_mvpMatrix * position;
    if (elapsedTime > a_lifeTime) {
        gl_PointSize = 0.f;
    } else {
        gl_PointSize = a_size * (1.f - (elapsedTime / a_lifeTime));
    }
}