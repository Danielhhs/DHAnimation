#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_time;

layout(location = 0) in float a_lifeTime;
layout(location = 1) in float a_xPos;
layout(location = 2) in float a_pointSize;
layout(location = 3) in vec2 a_color;
layout(location = 4) in float a_emitTime;
layout(location = 5) in float a_rotation;
layout(location = 6) in vec2 a_yRange;

out float v_lifeTime;
out vec2 v_color;
out float v_percent;
out mat4 v_rotationMatrix;

void main() {
    float percent = (u_time - a_emitTime) / a_lifeTime;
    float yPos = a_yRange.x + percent * a_yRange.y;
    vec4 position = vec4(a_xPos, yPos, 0.f, 1.f);
    gl_Position = u_mvpMatrix * position;
    gl_PointSize = a_pointSize + a_pointSize * 0.7 * percent;
    float red = 1.f;
    float green = 0.3 + (1.f - percent) * 0.5;
    v_color = vec2(red, green);
    v_percent = percent;
    
    float rotation = a_rotation * percent;
    float cos = cos(rotation);
    float sin = sin(rotation);
    mat4 transInMat = mat4(1.0, 0.0, 0.0, 0.0,
                           0.0, 1.0, 0.0, 0.0,
                           0.0, 0.0, 1.0, 0.0,
                           0.5, 0.5, 0.0, 1.0);
    mat4 rotMat = mat4(cos, -sin, 0.0, 0.0,
                       sin, cos, 0.0, 0.0,
                       0.0, 0.0, 1.0, 0.0,
                       0.0, 0.0, 0.0, 1.0);
    mat4 resultMat = transInMat * rotMat;
    resultMat[3][0] = resultMat[3][0] + resultMat[0][0] * -0.5 + resultMat[1][0] * -0.5;
    resultMat[3][1] = resultMat[3][1] + resultMat[0][1] * -0.5 + resultMat[1][1] * -0.5;
    resultMat[3][2] = resultMat[3][2] + resultMat[0][2] * -0.5 + resultMat[1][2] * -0.5;
    v_rotationMatrix = resultMat;
}