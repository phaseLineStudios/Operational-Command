shader_type spatial;

render_mode cull_disabled;

uniform sampler2D map_tex : source_color, filter_linear_mipmap_anisotropic, repeat_disable;
uniform float brightness : hint_range(0.0, 1.0) = 0.88;
uniform float contrast : hint_range(0.0, 2.0) = 1.06;
uniform float sharpen_strength : hint_range(0.0, 3.0) = 0.65;
uniform float unshaded : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec2 texel = 1.0 / vec2(textureSize(map_tex, 0));

	vec3 c = texture(map_tex, UV).rgb;
	vec3 b = (
		texture(map_tex, UV + vec2(texel.x, 0.0)).rgb
		+ texture(map_tex, UV - vec2(texel.x, 0.0)).rgb
		+ texture(map_tex, UV + vec2(0.0, texel.y)).rgb
		+ texture(map_tex, UV - vec2(0.0, texel.y)).rgb
	) * 0.25;

	vec3 col = c + (c - b) * sharpen_strength;
	col = (col - vec3(0.5)) * contrast + vec3(0.5);
	col = clamp(col * brightness, 0.0, 1.0);

	ALBEDO = col * (1.0 - unshaded);
	EMISSION = col * unshaded;

	ROUGHNESS = 1.0;
	METALLIC = 0.0;
	SPECULAR = 0.0;
}
