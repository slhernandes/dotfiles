#version 300 es

precision mediump float;
uniform sampler2D u_texture;

in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;

void main() {
    vec4 color = texture(u_texture, v_texcoord);

    // Luminance weights (perceptual, Rec. 709)
    const vec3 W = vec3(0.2126, 0.7152, 0.0722);
    const vec3 V = -0.25 * vec3(1.0, 1.0, 1.0);

    float luminance = dot(color.rgb, W);

    float max_color = max(color[0], max(color[1], color[2]));
    float min_color = min(color[0], min(color[1], color[2]));

    float saturation = max_color - min_color;
    vec3 p_col = (sign(V) * saturation - 1.0) * V + 1.0;

    color[0] = mix(luminance, color[0], p_col[0]);
    color[1] = mix(luminance, color[1], p_col[1]);
    color[2] = mix(luminance, color[2], p_col[2]);
    fragColor = color;
}
