#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform int u_blurAmount;
uniform float u_blurScale;
uniform float u_blurStrength;
uniform vec2 u_resolution;

in vec2 v_texCoords;

layout(location = 0) out vec4 out_color;

float Gaussian(float x, float deviation) {
    return (1.0 / sqrt(2.0 * 3.141592 * deviation)) * exp(-((x * x) / (2.0 * deviation)));
}

void main() {
    float halfBlur = float(u_blurAmount) * 0.5;
    vec4 color = vec4(0.f);
    vec4 texture_color = vec4(0.f);
    
    float deviation = halfBlur * 0.35;
    deviation *= deviation;
    float strength = 1.f - u_blurStrength;
    
    for (int i = 0; i < 10; ++i) {
        if (i >= u_blurAmount) {
            break;
        }
        float offset = float(i) - halfBlur;
        texture_color = texture(s_tex, v_texCoords + vec2(offset * 1.f * u_blurScale, 0.f)) * Gaussian(offset * strength, deviation);
        color += texture_color;
    }
    out_color = clamp(color, 0.f, 1.f);
}