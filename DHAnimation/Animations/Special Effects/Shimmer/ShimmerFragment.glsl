#version 300 es

precision highp float;

uniform sampler2D s_tex;
uniform float u_percent;
uniform mat4 u_rotationMatrix;
uniform sampler2D s_texBack;
uniform float u_event;

layout(location = 0) out vec4 out_color;

in vec2 v_texCoords;

const vec4 whiteColor = vec4(1.f, 1.f, 1.f, 1.f);

void main() {
    
    float percent = u_percent;
    if (u_event != 0.f) {
        percent = 1.f - u_percent;
    }
    if (percent <= 0.f || percent >= 1.f) {
        discard;
    } else {
        vec4 background_color = texture(s_texBack, v_texCoords);
        if (background_color.a >= 0.1) {
            vec2 texCoord = (u_rotationMatrix * vec4(gl_PointCoord, 0.f, 1.f)).xy;
            
            out_color = texture(s_tex, texCoord);
            
            if ((out_color.r < 0.1 && out_color.g < 0.1 && out_color.b < 0.1) || out_color.a < 0.1) {
                discard;
            } else {
                out_color = whiteColor - (whiteColor - background_color) * percent;
                out_color.a = 0.8 - 0.5 * percent;
            }
        } else {
            discard;
        }
    }
}