#version 300 es

precision highp float;

uniform sampler2D s_tex;

uniform float u_percent;
uniform float u_event;

in vec2 v_texCoords;
in vec2 v_blurTexCoords[14];

layout(location = 0) out vec4 out_color;

void main() {
    out_color = vec4(0.0);
    out_color += texture(s_tex, v_blurTexCoords[ 0])*0.0044299121055113265;
    out_color += texture(s_tex, v_blurTexCoords[ 1])*0.00895781211794;
    out_color += texture(s_tex, v_blurTexCoords[ 2])*0.0215963866053;
    out_color += texture(s_tex, v_blurTexCoords[ 3])*0.0443683338718;
    out_color += texture(s_tex, v_blurTexCoords[ 4])*0.0776744219933;
    out_color += texture(s_tex, v_blurTexCoords[ 5])*0.115876621105;
    out_color += texture(s_tex, v_blurTexCoords[ 6])*0.147308056121;
    out_color += texture(s_tex, v_texCoords         )*0.159576912161;
    out_color += texture(s_tex, v_blurTexCoords[ 7])*0.147308056121;
    out_color += texture(s_tex, v_blurTexCoords[ 8])*0.115876621105;
    out_color += texture(s_tex, v_blurTexCoords[ 9])*0.0776744219933;
    out_color += texture(s_tex, v_blurTexCoords[10])*0.0443683338718;
    out_color += texture(s_tex, v_blurTexCoords[11])*0.0215963866053;
    out_color += texture(s_tex, v_blurTexCoords[12])*0.00895781211794;
    out_color += texture(s_tex, v_blurTexCoords[13])*0.0044299121055113265;
    float percent = u_percent;
    if (u_event == 1.f) {
        percent = 1.f - u_percent;
    }
    out_color.a = percent * percent;
}