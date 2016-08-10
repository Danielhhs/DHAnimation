#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_time;
uniform float u_duration;
uniform float u_singleCharacterFadeRatio;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;
layout(location = 2) in vec3 a_fadingAnchor;
layout(location = 3) in float a_startFadingTime;

out vec2 v_texCoords;
out float v_percent;

const float M_PI = 3.1415927;
const float c_fallingRatio = 0.5;

float NSBKeyframeAnimationFunctionEaseOutElastic(float t, float b, float c, float d)
{
    float s=1.70158, p=0.f, a=c;
    if (t==0.f) return b;  if ((t/=d)==1.f) return b+c;  if (p == 0.f) p=d*.3;
    if (a < abs(c)) { a=c; s=p/4.f; }
    else s = p/(2.f*M_PI) * asin (c/a);
    return a*pow(2.f,-10.f*t) * sin( (t*d-s)*(2.f*M_PI)/p ) + c + b;
}

vec4 updatedPosition() {
    vec4 position = a_position;
    
    float time = u_time - a_startFadingTime;
    if (time <= 0.f) {
        v_percent = 0.f;
        return position;
    }
    
    v_percent = time / (u_duration * u_singleCharacterFadeRatio);
    
    float percent = NSBKeyframeAnimationFunctionEaseOutElastic(time * 1000.f, 0.f, 1.f, u_duration * 1000.f);
    
    float rotation = M_PI * percent;
    
    vec3 positionToAnchor = a_position.xyz - a_fadingAnchor;
    float l = length(positionToAnchor);
    float originalAngle = acos(positionToAnchor.x / l);
    
    positionToAnchor = vec3(l * cos(originalAngle) * cos(rotation) + l * sin(originalAngle) * sin(rotation), l * sin(originalAngle) * cos(rotation) - l * cos(originalAngle) * sin(rotation), 0.f);
    
    position.xyz = a_fadingAnchor + positionToAnchor;
    
    if (time > u_duration * u_singleCharacterFadeRatio * (1.f - c_fallingRatio)) {
        rotation = M_PI;
        float fallingTime = c_fallingRatio * u_duration * u_singleCharacterFadeRatio;
        float gravity = 2.f * a_fadingAnchor.y / fallingTime / fallingTime;
        float falledTime = time - u_duration * u_singleCharacterFadeRatio * (1.f - c_fallingRatio);
        position.y -= 0.5 * gravity * falledTime * falledTime;
    }
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}