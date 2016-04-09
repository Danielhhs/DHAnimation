#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_elapsedTime;

in float v_rotation;
in float v_startShiningTime;
in float v_lifeTime;
in mat4 v_rotationMatrix;

layout(location = 0) out vec4 out_color;

void main() {
    if (u_elapsedTime - v_startShiningTime > v_lifeTime || u_elapsedTime < v_startShiningTime) {
        discard;
    }
    vec2 texCoord = (v_rotationMatrix * vec4(gl_PointCoord, 0, 1)).xy;
    out_color = texture(s_tex, texCoord);
}