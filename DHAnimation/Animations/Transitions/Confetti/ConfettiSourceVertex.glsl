#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_columnWidth;
uniform float u_columnHeight;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;
layout(location = 3) in vec3 a_vertexToCenter;
layout(location = 4) in float a_rotation;
layout(location = 5) in vec3 a_originalCenter;
layout(location = 6) in vec3 a_targetCenter;

out vec2 v_texCoords;

vec4 updatedPosition()
{
    float rotation = a_rotation * u_percent;
    
    vec3 vertexToCenter = vec3(0.f);
    if (a_position.x < a_originalCenter.x && a_position.y > a_originalCenter.y) {
        vertexToCenter.y = u_columnWidth / 2.f * sqrt(2.f);
    } else if (a_position.x > a_originalCenter.x && a_position.y > a_originalCenter.y) {
        vertexToCenter.x += u_columnWidth * sqrt(2.f) / 2.f;
    } else if (a_position.x < a_originalCenter.x && a_position.y < a_originalCenter.y) {
        vertexToCenter.x -= u_columnWidth / 2.f * sqrt(2.f);
    } else {
        vertexToCenter.y -= u_columnWidth / 2.f * sqrt(2.f);
    }
    vertexToCenter.y *= cos(rotation);
    vertexToCenter.z *= sin(rotation);
    
    vec3 currentCenter = a_originalCenter + (a_targetCenter - a_originalCenter) * u_percent;
    
    vec4 position = vec4(currentCenter + vertexToCenter, 1.f);
    return position;
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}