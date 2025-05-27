#define RADIUS 5.0
#define THICCNESS 5.0

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fragCoord/iResolution.xy;

  vec2 p1 = vec2(200.0, 200.0);
  vec2 p2 = vec2((sin(iTime) + 1) * 100 + 300.0, (cos(iTime) + 1) * 100);

  vec3 col;
  col.r = texture(iChannel0, vec2(uv)).r;
  col.g = texture(iChannel0, vec2(uv)).g;
  col.b = texture(iChannel0, vec2(uv)).b;

  fragColor = vec4(col, 1.0);
  if (length(fragCoord.xy - p1) < RADIUS) {
    fragColor += vec4(0.1, 0.0, 0.0, -0.2);
  }

  if (length(fragCoord.xy - p2) < RADIUS) {
    fragColor += vec4(0.1, 0.0, 0.0, -0.2);
  }

  vec2 p3 = fragCoord.xy;
  vec2 p12 = p2 - p1;
  vec2 p13 = p3 - p1;

  float d = dot(p12, p13) / length(p12);
  vec2 p4 = p1 + normalize(p12) * d;
  if (length(p4 - p3) <= THICCNESS * (sin(length(p4)/length(p12)*6.28) + 1)
        && length(p4 - p1) <= length(p12)
        && length(p4 - p2) <= length(p12)) {
    fragColor += vec4(0.0, .1, .1, -0.2);
  }
}
