#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;
layout(location = 3) in vec3 a_originalCenter;
layout(location = 4) in vec3 a_targetCenter;
layout(location = 4) in float rotation;

out vec2 v_texCoords;

vec4 updatedPosition()
{
    vec3 center = a_originalCenter + (a_targetCenter - a_originalCenter) * u_percent;
    
    vec4 position = a_position;
    position.z = -300.f * (1.f - u_percent);
    
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * a_position;
    v_texCoords = a_texCoords;
}