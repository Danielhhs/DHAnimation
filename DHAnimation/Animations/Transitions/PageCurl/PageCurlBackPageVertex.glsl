#version 300 es

uniform mat4 u_mvpMatrix;

uniform vec2 u_direction;
uniform float u_radius;
uniform vec2 u_position;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;
out vec3 v_normal;
out vec2 v_gradientTexCoords;

#define M_PI 3.14159265358979323846264338327950288

vec4 updatedPosition() {
    vec2 normal = vec2(u_direction.y, -u_direction.x);
    vec2 vetToPosition = a_position.xy - u_position;
    float distanceToAxis = dot(vetToPosition, normal);
    
    vec2 dv = normal * (2.f * distanceToAxis - M_PI * u_radius);
    float centerAngle = distanceToAxis / u_radius;
    vec2 vertProjectionToNormal = a_position.xy - normal * distanceToAxis;
    vec3 center = vec3(vertProjectionToNormal, u_radius);
    
    float br1 = clamp(sign(distanceToAxis), 0.f, 1.f);
    float br2 = clamp(sign(distanceToAxis - M_PI * u_radius), 0.f, 1.f);
    
    vec3 vProj = vec3(sin(centerAngle) * normal.x, sin(centerAngle) * normal.y, 1.f - cos(centerAngle)) * u_radius;  //vertex position mapped to cylinder
    vProj.xy += vertProjectionToNormal;
    vec4 v = mix(a_position, vec4(vProj, a_position.w), br1);
    v = mix(v, vec4(a_position.x - dv.x, a_position.y - dv.y, 2.f * u_radius, a_position.w), br2);
    
    v_normal = mix(vec3(0.f, 0.f, 1.f), (center - v.xyz) / u_radius, br1);
    v_normal = mix(v_normal, vec3(0.f, 0.f, -1.f), br2);
    
    vec2 vw = v.xy - u_position;
    float vd = dot(vw, -normal);
    v_gradientTexCoords = vec2(-vd / u_radius, 0.5);
    return v;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}