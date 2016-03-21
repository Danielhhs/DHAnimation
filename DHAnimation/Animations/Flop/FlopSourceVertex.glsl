#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_screenHeight;
uniform float u_cylinderRadius;
uniform float u_percent;
uniform vec3 u_targetCenter;

layout (location = 0) in vec4 a_position;
layout (location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float curlTimeRatio = 0.2;
const float centerAngle = 90.f / 180.f * 3.1415927;

vec4 updatedPosition()
{
    vec4 position = a_position;
    vec3 originalCenter = vec3(0.f, u_screenHeight / 4.f * 3.f, -u_cylinderRadius);
    vec3 currentCenter = mix(originalCenter, u_targetCenter, u_percent);
//    vec3 currentCenter = u_targetCenter;
//    currentCenter.y = originalCenter.y - (u_percent * centerAngle * u_cylinderRadius - u_cylinderRadius * sin(u_percent * centerAngle / 2.f) * 2.f) / 2.f;
    
    if (position.y >= u_screenHeight / 2.f) {
        float d = position.y - u_screenHeight / 2.f;
        float projAngle = d / u_cylinderRadius;
        vec3 proj = vec3(a_position.x, -sin(centerAngle / 2.f - projAngle) * u_cylinderRadius, cos(centerAngle / 2.f - projAngle) * u_cylinderRadius);
        position = vec4(currentCenter + proj, a_position.w);
        position.z = max(position.z, 0.f);
        position.y -= (u_percent * centerAngle * u_cylinderRadius - u_cylinderRadius * sin(u_percent * centerAngle / 2.f) * 2.f) / 2.f;
    }
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}
