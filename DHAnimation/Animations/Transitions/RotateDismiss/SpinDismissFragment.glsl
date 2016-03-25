#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_percent;
uniform float u_screenHeight;
uniform float u_spinRatio;

in vec2 v_texCoords;
in vec3 v_normal;

layout(location = 0) out vec4 out_color;

const vec3 c_light = vec3(0.f, 0.f, 1.f);

void main() {
    float centerY = u_screenHeight;
    float yDist = abs(gl_FragCoord.y - centerY);
    if (u_percent >= u_spinRatio && yDist > centerY - (u_percent - u_spinRatio) / (1.f - u_spinRatio) * centerY) {
        discard;
    } else {
        vec4 texture_color = texture(s_tex, v_texCoords);
        vec3 normalizedNormal = normalize(v_normal);
        float alpha = dot(c_light, normalizedNormal);
        out_color = vec4(texture_color.rgb * alpha, 1.f);
    }
}