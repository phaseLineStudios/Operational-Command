shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform bool vignette = true;
uniform float vignette_intensity : hint_range(0.0, 2.0) = 0.35;
uniform float vignette_softness  : hint_range(0.0, 1.0) = 0.5;
uniform bool chromatic_abberation = true;
uniform float ca_intensity       : hint_range(0.0, 5.0) = 1.25;
uniform bool sharpen = true;
uniform float sharpen_strength   : hint_range(0.0, 3.0) = 0.6;

varying vec2 pixel_pos;

void vertex() {
    pixel_pos = VERTEX;
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec3 src = texture(screen_texture, uv).rgb;

	// Chromatic aberration (radial, subtle)
	vec3 ca_col;
	vec2 center = vec2(0.5);
	vec2 to_center = uv - center;
	float r = length(to_center);
	float ca = ca_intensity * r * r;
	
	if (chromatic_abberation) {
		ca_col.r = textureLod(screen_texture, uv - to_center * ca * 0.003, 0.0).r;
		ca_col.g = src.g;
		ca_col.b = textureLod(screen_texture, uv + to_center * ca * 0.003, 0.0).b;
	}

	// Sharpen (simple unsharp mask)
	vec3 col;
	if (sharpen) {
		vec2 px = 1.0 / (pixel_pos / UV);
		vec3 blur = (
			textureLod(screen_texture, uv + vec2(px.x, 0.0), 0.0).rgb +
			textureLod(screen_texture, uv - vec2(px.x, 0.0), 0.0).rgb +
			textureLod(screen_texture, uv + vec2(0.0, px.y), 0.0).rgb +
			textureLod(screen_texture, uv - vec2(0.0, px.y), 0.0).rgb
		) * 0.25;
		col = mix(ca_col, ca_col * 2.0 - blur, clamp(sharpen_strength, 0.0, 1.0));
	}

	// Vignette
	if (vignette) {
		float vig = smoothstep(1.0, 1.0 - vignette_softness, r);
		col *= mix(1.0, 1.0 - vignette_intensity, vig);
	}

	COLOR = vec4(col, 1.0);
}
