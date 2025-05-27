// Original shader collected from: https://www.shadertoy.com/view/WsVSzV
// Licensed under Shadertoy's default since the original creator didn't provide any license. (CC BY NC SA 3.0)
// Slight modifications were made to give a green-ish effect.

float warp = 0.07; // simulate curvature of CRT monitor
float scan = 0.30; // simulate darkness between scanlines
float time_scale = -200.0;
float exp_scale = 0.01;
float offset = 0.95;

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // squared distance from center
    vec2 uv = fragCoord / iResolution.xy;
    vec2 dc = abs(0.5 - uv);
    dc *= dc;

    // warp the fragment coordinates
    uv.x -= 0.5; uv.x *= 1.0 + (dc.y * (0.3 * warp)); uv.x += 0.5;
    uv.y -= 0.5; uv.y *= 1.0 + (dc.x * (0.4 * warp)); uv.y += 0.5;

    vec2 res = iResolution.xy;
    float y_line = mod(time_scale * iTime, res.y);
    float y_dist = mod(fragCoord.y - y_line + res.y, res.y);
    float y_scale = 1.0 - ((1.0 - exp(-y_dist * exp_scale)) * (1.0 - offset));

    // sample inside boundaries, otherwise set to black
    if (uv.y > 1.0 || uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0)
        fragColor = vec4(0.1, 0.25, 0.2, 1.0);
    else
    {
        // determine if we are drawing in a scanline
        float apply = abs(sin(fragCoord.y) * 0.5 * scan);

        // sample the texture and apply a teal tint
        vec3 color = texture(iChannel0, uv).rgb;
        vec3 tealTint = y_scale * vec3(0.8, 0.95, 0.9);

        // mix the sampled color with the teal tint based on scanline intensity
        fragColor = vec4(mix(color * tealTint, vec3(0.0), apply), 1.0);
    }
}
