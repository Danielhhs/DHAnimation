#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_screenHeight;
uniform float u_cylinderRadius;
uniform float u_percent;
uniform vec3 u_targetCenter;
uniform float u_centerAngle;

layout (location = 0) in vec4 a_position;
layout (location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float curlTimeRatio = 0.2;

vec4 updatedPositionForCurling(float percent)
{
    vec4 position = a_position;
    vec3 originalCenter = vec3(0.f, u_screenHeight / 4.f * 3.f, -u_cylinderRadius);
    vec3 currentCenter = originalCenter;
    currentCenter.z = mix(originalCenter.z, u_targetCenter.z, percent);
    
    if (position.y >= u_screenHeight / 2.f) {
        float d = position.y - u_screenHeight / 2.f;
        float projAngle = d / u_cylinderRadius;
        vec3 proj = vec3(a_position.x, -sin(u_centerAngle / 2.f - projAngle) * u_cylinderRadius, cos(u_centerAngle / 2.f - projAngle) * u_cylinderRadius);
        position = vec4(currentCenter + proj, a_position.w);
        if (position.z < 0.f) {
            position.z = 0.f;
            position.y = a_position.y;
            if (position.y > currentCenter.y) {
                position.y -= (percent * u_centerAngle * u_cylinderRadius - u_cylinderRadius * sin(percent * u_centerAngle / 2.f) * 2.f);
            }
        } else {
            position.y -= (percent * u_centerAngle * u_cylinderRadius - u_cylinderRadius * sin(percent * u_centerAngle / 2.f) * 2.f) / 2.f;
        }
    }
    return position;
}

vec4 updatedPositionForFlopping(float percent) {
    vec4 position = a_position;
    if (position.y > u_screenHeight / 2.f) {
        vec3 startCenter = u_targetCenter;
        vec3 targetCenter = u_targetCenter;
        targetCenter.y = u_screenHeight / 2.f - (startCenter.y - u_screenHeight / 2.f);
        
        vec4 curledPosition = updatedPositionForCurling(1.f);
        vec4 positionToCenter = curledPosition - vec4(u_targetCenter, a_position.w);
        
        float rotatedAngle = 
        vec4 rotatedPositionToCenter =
        
        vec3 currentCenter = startCenter;
        if (percent < 0.5) {
            currentCenter.z = (u_cylinderRadius * sin(u_centerAngle / 2.f) - currentCenter.z) * percent + currentCenter.z;
        } else {
            currentCenter.z = u_cylinderRadius * sin(u_centerAngle / 2.f) + (currentCenter.z - u_cylinderRadius * sin(u_centerAngle / 2.f)) * percent;
        }
        currentCenter.y = startCenter.y + (targetCenter.y - startCenter.y) * percent;
        
        position = positionToCenter + vec4(currentCenter, a_position.w);
    }
    
    return position;
}

vec4 updatedPosition()
{
    if (u_percent < curlTimeRatio) {
        return updatedPositionForCurling(u_percent / curlTimeRatio);
    } else {
        return updatedPositionForFlopping((u_percent - curlTimeRatio) / (1.f - curlTimeRatio));
    }
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}
