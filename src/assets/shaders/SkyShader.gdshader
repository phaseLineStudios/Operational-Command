shader_type sky;
render_mode use_half_res_pass, use_quarter_res_pass;

uniform vec4 base_color : source_color = vec4(0.052192, 0.101373, 0.192708, 1.0);
uniform sampler2D scattering_lut;
uniform vec3 scatter_color : source_color = vec3(1.0);
uniform vec3 scatter_color_2 : source_color = vec3(1.0);

// Bools
uniform bool b_anim_clouds = true;
uniform bool b_anim_stars = true;

// Sun
uniform float sun_radius;
uniform float sun_edge_blur;
uniform vec3 sun_disc_color : source_color;
uniform vec4 sun_glow_color : source_color;
uniform vec3 sunlight_color : source_color;
uniform float sun_glow_intensity;

// Moon
uniform float moon_radius;
uniform float moon_edge_blur;
uniform vec4 moon_glow_color : source_color;
uniform float moon_glow_intensity;

// 2D Clouds
uniform vec3 base_cloud_color : source_color = vec3(1.0);
uniform float cloud_density : hint_range(5.0, 10.0, 0.05) = 7.0;
uniform sampler2D cloud_texture;
uniform sampler2D cloud_texture_2;
uniform float mg_size : hint_range(0.5, 0.99, 0.01) = 0.92;
uniform float cloud_alpha : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float cloud_speed = 0.001;

// Horizon
uniform vec4 horizon_fog_color : source_color;
uniform float horizon_alpha : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float horizon_size : hint_range(1.0, 7.0, 0.1);

// Stars
uniform sampler2D star_texture;
uniform sampler2D star_noise;
uniform vec3 star_color : source_color;
uniform float star_brightness : hint_range(0.0, 0.5, 0.01) = 0.2;
uniform float twinkle_speed : hint_range(0.0, 0.05, 0.001) = 0.025;
uniform float twinkle_scale : hint_range(0.5, 5.0, 0.1) = 4.0;
uniform float star_resolution : hint_range(-1.0, 3.0, 1.0) = 2.0;
uniform float star_speed = 0.002;

const vec3 cam_pos = vec3(0.0, 1.0, 0.0);

float remap(float v, float min_old, float max_old, float min_new, float max_new) {
	return min_new + (v - min_old) * (max_new - min_new) / (max_old - min_old);
}

// Create sun and moon discs based on the directional lights
vec3 create_sun_moon_disc(vec3 dir, vec3 sun_dir, vec3 color, float r, float edge_blur) {
	float disc = 0.0;
	float disc_size_check = (1.0 - (r * 2.0));
	if (dot(dir, sun_dir) > disc_size_check) {
		disc = pow((dot(dir, sun_dir) - disc_size_check) * edge_blur, 5.0);
	}
	vec3 disc_colored;
	disc_colored = clamp(vec3(disc) * color, 0.0, 1.0);
	return disc_colored;
}

vec3 create_sun_glow(vec3 dir, vec3 sun_dir, float r) {
	float sun_glow = 0.0;
	float glow_size = (1.0 - ((0.0003 * 800.0) * 2.0));
	if (dot(dir, sun_dir) > glow_size) {
		sun_glow = mix(0.0, (dot(dir, sun_dir) - glow_size * 1.05) * (1.0 - dir.y), sun_glow_intensity);
	}
	vec3 sun_glow_final = clamp((pow(sun_glow - 0.1, 1.0) * sun_glow_color.rgb), 0.0, 1.0) * sun_glow_color.a;
	return sun_glow_final;
}

vec3 create_moon_glow(vec3 dir, vec3 moon_dir, float r) {
	float moon_glow = 0.0;
	float glow_size = (1.0 - ((0.0003 * 400.0) * 2.0));
	if (dot(dir, moon_dir) > glow_size) {
		moon_glow = mix(0.0, (dot(dir, moon_dir) - glow_size), moon_glow_intensity);
	}
	vec3 moon_glow_final = pow(vec3(moon_glow), vec3(3.0)) * moon_glow_color.rgb * moon_glow_color.a;
	return moon_glow_final;
}

float create_horizon_fog(vec3 vertex_color) {
	float clamped_vertex_color = 0.0;
	if (vertex_color.y < 0.0) {
		clamped_vertex_color = 1.0;
	}
	else {
		clamped_vertex_color = vertex_color.y;
	}
	float fog_alpha = clamp(pow((1.0 - clamped_vertex_color), horizon_size) - (1.0 - horizon_alpha), 0.0, 1.0) * horizon_fog_color.a;
	return fog_alpha;
}

// Setup base light scattering with day and night
vec3 scatter_light(vec3 vertex_color, vec2 sky_uv) {

	// Clamp lower hemisphere vertex normal Y (creates solid lower hemisphere color)
	float clamped_vertex_color = 0.0;
	if (vertex_color.y < 0.0) { clamped_vertex_color = 0.0001; }
	else { clamped_vertex_color = vertex_color.y; }

	float vertex_slope = pow((1.0 - vertex_color.y), 2.0);

	// Calculate SUN X and Y position on scattering LUT texture UV
	// Sun
	float uv_x = mix(vertex_slope, 1.0, 0.5);
	float uv_y = clamp(LIGHT0_DIRECTION.y / -2.0, -0.495, 0.495) + 0.5;

	// Moon
	float uv_x2 = mix(vertex_slope, 1.0, 0.1);
	float uv_y2 = clamp(LIGHT1_DIRECTION.y / 2.0, -0.495, 0.495) + 0.5;

	// Sample scattering LUT lexture and apply scattercolor adjustment
	vec3 sun_light_scattered = texture(scattering_lut, vec2(uv_x, uv_y)).rgb * scatter_color;
	vec3 moon_light_scattered = texture(scattering_lut, vec2(uv_x2, uv_y2)).rgb * scatter_color_2 + 0.15;
	vec3 light_scattered = sun_light_scattered + moon_light_scattered;
	light_scattered = light_scattered * base_color.rgb;

	vec3 base_sky_color = light_scattered;

	float a1 = 0.0;
	if (b_anim_stars == true) {
		a1 = (TIME * star_speed);
	}
	else {
		a1 = 0.0;
	}
	vec3 star_map = textureLod(star_texture, vec2(sky_uv.x + a1, sky_uv.y), star_resolution).rgb;
	vec3 star_map_2 = textureLod(star_texture, vec2(sky_uv.x + a1, sky_uv.y), star_resolution + 1.0).rgb;

	vec2 anim_uv = vec2(vertex_color.x, vertex_color.z) * twinkle_scale + (TIME * twinkle_speed);

	star_map = min(star_map, star_map_2 * 0.3) + ((clamp(star_map - (star_map_2 * 1.3), 0.0, 1.0)) * (texture(star_noise, anim_uv / 4.0).r * 10.0));

	base_sky_color += star_map * star_color * star_brightness; // Add stars

	return base_sky_color;
}

vec3 generate_static_clouds(vec3 dir, vec3 pos, vec2 sky_uv, vec3 sun_dir, vec3 moon_dir) {
	vec4 xy_mask = vec4(0.0);
	float z_mask = 0.0;

	float s_r = clamp(sun_dir.x * -1.0, 0.0, 1.0);
	float s_g = clamp(sun_dir.x, 0.0, 1.0);
	float s_b = clamp(sun_dir.z, 0.0, 1.0);
	float s_a = clamp(sun_dir.z * -1.0, 0.0, 1.0);
	float s_z = clamp(sun_dir.y * -1.0, 0.0, 1.0);

	float m_r = clamp(moon_dir.x * -1.0, 0.0, 1.0);
	float m_g = clamp(moon_dir.x, 0.0, 1.0);
	float m_b = clamp(moon_dir.z, 0.0, 1.0);
	float m_a = clamp(moon_dir.z * -1.0, 0.0, 1.0);
	float m_z = clamp(moon_dir.y * -1.0, 0.0, 1.0);

	xy_mask = mix(vec4(s_r, s_g, s_b, s_a), vec4(m_r, m_g, m_b, m_a), clamp(sun_dir.y * 6.0, 0.0, 1.0)) * 0.7;
	z_mask = mix(s_z, m_z, clamp(sun_dir.y * 6.0, 0.0, 1.0)) * 0.7;

	float a1 = 0.0;
	if (b_anim_clouds == true) {
		a1 = (TIME * cloud_speed);
	}
	else {
		a1 = 0.0;
	}

	float clouds_alpha = textureLod(cloud_texture, vec2(sky_uv.x + a1, sky_uv.y), -1.0).r;
	float cloud_alpha_2 = textureLod(cloud_texture, vec2(sky_uv.x + a1, sky_uv.y), -1.0).g * z_mask;
	vec4 cloud_shading = xy_mask * textureLod(cloud_texture_2, vec2(sky_uv.x + a1, sky_uv.y), -1.0);
	float cloud_shading_2 = (cloud_shading.r + cloud_shading.g) + (cloud_shading.b + cloud_shading.a);
	float cloud_main_shading_mask = pow(cloud_alpha_2 + cloud_shading_2, 1.2);

	float cloud_shine = ((1.0 - clouds_alpha) + pow(cloud_alpha_2 + cloud_shading_2, 2.5)) * 17.0 * create_sun_glow(dir, sun_dir, 0.5).r;

	vec3 clouds = vec3(cloud_main_shading_mask, cloud_shine, clouds_alpha);

	return clouds;
}

vec3 generate_sky(vec3 dir, vec3 pos, vec2 sky_uv, vec3 sun_dir, float sun_energy, vec3 sun_color, vec3 moon_dir, vec3 moon_color, float moon_energy) {
	vec3 sky_color = vec3(0.0);
	vec3 cloud_colors = vec3(0.0);
	vec3 cloud_mask = vec3(0.0);

	float fog_a = create_horizon_fog(dir);
	vec3 atmos = scatter_light(dir, sky_uv);

	cloud_mask = generate_static_clouds(dir, pos, sky_uv, sun_dir, moon_dir);

	sky_color += atmos;
	sky_color += create_sun_moon_disc(dir, sun_dir, sun_color, sun_radius, sun_edge_blur) * (1.0 - cloud_mask.z * cloud_alpha);
	sky_color += create_sun_moon_disc(dir, moon_dir, moon_color, moon_radius, moon_edge_blur) * (1.0 - cloud_mask.z * cloud_alpha);

	float density = clamp((cloud_density) / 5.0, 0.0, 1.0);
	vec3 cloud_color = mix(atmos * mix(dir.y, 1.15, 0.5), vec3(0.0), density);
	vec3 cloud_light = sunlight_color * 1.4 * cloud_color;
	vec3 cloud_shading = pow((cloud_light + (cloud_light * cloud_mask.y)) * cloud_mask.x, vec3(1.2));
	vec3 cloud_final = mix(cloud_shading, base_cloud_color, 0.1);

	cloud_colors = base_cloud_color * cloud_mask.z * cloud_mask.x;
	if (dot(dir, sun_dir) > mg_size) {
		float cloud_glow = remap(dot(dir, sun_dir), mg_size, 1.0, 0.0, 1.0);
		vec3 cloud_glow_2 = mix(vec3(1.0), sunlight_color * 5.0, pow(cloud_glow, 3.0));
		cloud_colors = base_cloud_color * cloud_glow_2 * cloud_mask.z * cloud_mask.x;
	}
	if (dot(dir, moon_dir) > mg_size) {
		float cloud_glow = remap(dot(dir, moon_dir), mg_size, 1.0, 0.0, 1.0);
		vec3 cloud_glow_2 = mix(vec3(1.0), vec3(1.0) * 10.0, pow(cloud_glow, 4.0));
		cloud_colors = base_cloud_color * cloud_glow_2 * cloud_mask.z * cloud_mask.x;
	}

	sky_color *= clamp((1.0 - pow(cloud_mask.z, 3.0) * cloud_alpha), 0.0, 1.0);
	sky_color += (cloud_final * (pow(cloud_mask.z, 3.0) * (1.0 - clamp((1.0 - 1.25) * 2.0, 0.0, 1.0))) + cloud_colors) * cloud_alpha;

	sky_color = mix(sky_color, horizon_fog_color.rgb * horizon_fog_color.a, fog_a) + create_sun_moon_disc(dir, sun_dir, sun_color, sun_radius, sun_edge_blur) * (1.0 - cloud_mask.z * cloud_alpha) + create_sun_moon_disc(dir, moon_dir, moon_color, moon_radius, moon_edge_blur) * (1.0 - cloud_mask.z * cloud_alpha);
	if (dir.y < 0.0) {
		sky_color = horizon_fog_color.rgb;
	}
	sky_color += create_sun_glow(dir, sun_dir, sun_radius);
	sky_color += create_moon_glow(dir, moon_dir, moon_radius);

	return sky_color;
}

void sky() {
	vec3 ray_direction = EYEDIR;

	vec3 background = horizon_fog_color.rgb * horizon_fog_color.a;

	if (ray_direction.y > 0.0) {
		background = generate_sky(ray_direction, cam_pos, SKY_COORDS, LIGHT0_DIRECTION, LIGHT0_ENERGY, sun_disc_color, LIGHT1_DIRECTION, LIGHT1_COLOR, LIGHT1_ENERGY);
	}

	if (AT_QUARTER_RES_PASS && AT_CUBEMAP_PASS) {
		COLOR = background.rgb;
	} else if (AT_HALF_RES_PASS && !AT_CUBEMAP_PASS) {
		COLOR = background.rgb;
	} else if (AT_CUBEMAP_PASS) {
		COLOR = QUARTER_RES_COLOR.rgb;
	} else {
		COLOR = background.rgb;
	}
}
