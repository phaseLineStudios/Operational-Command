@tool
class_name EnvironmentController
extends WorldEnvironment
## Controlls environmental factors

@export_category("Sky Control")
## Current time (in seconds)
@export_range(0.0, 86400.0, 1.0) var time_of_day: float = 43200.0
## Environment scene
@export var environment_scene: PackedScene = preload("res://scenes/environments/env_forest.tscn"):
	set(val):
		environment_scene = val
		_update_environment()
## Scenario
@export var scenario: ScenarioData:
	set(val):
		scenario = val
		if env_scene:
			env_scene.scenario = scenario
			env_scene.get_sound_controller().init_env_sounds(val)

@export_group("Nodes")
## Parent of the sun and moon nodes
@export var sun_moon_parent: Node3D
@export var sun_root: MeshInstance3D
@export var moon_root: MeshInstance3D
@export var sun: DirectionalLight3D
@export var moon: DirectionalLight3D
@export var env_anchor: Node3D
@export var weather: Node3D
@export var rain_node: GPUParticles3D

@export_group("Sun & Moon")
## Enable sun shadows
@export var sun_shadow: bool = true
## Enable moon shadows
@export var moon_shadow: bool = true

@export_group("Sky")
## Sky settings
@export var sky_preset: SkyPreset
## Sky rotation
@export_range(0, 36.0, 0.1) var sky_rotation: float = 0.0
## Overcast (base value, rain will increase this)
@export_range(0, 1, 0.001) var cloud_coverage: float = 0.5:
	set(val):
		cloud_coverage = cloud_coverage
		_set_cloud_coverage = cloud_coverage
## Animate clouds
@export var animate_clouds: bool = true
## Animate stars
@export var animate_star_map: bool = true

@export_category("Weather")
## Rainfall intensity in millimeters per hour
@export_range(0.0, 50.0, 0.5) var rain_intensity: float = 0.0:
	set(val):
		rain_intensity = clamp(val, 0.0, 50.0)
		_update_rain_particles()
		_update_weather_cloud_coverage()
		_update_fog()  # Rain contributes to fog
## Fog visibility distance in meters (lower = denser fog)
@export_range(0.0, 10000.0, 10.0) var fog_visibility: float = 8000.0:
	set(val):
		fog_visibility = clamp(val, 0.0, 10000.0)
		_update_fog()
## Wind speed in meters per second
@export_range(0.0, 110.0, 0.5) var wind_speed: float = 0.0:
	set(val):
		wind_speed = clamp(val, 0.0, 110.0)
		_update_wind_effects()
## Wind direction in degrees (0° = North, 90° = East, 180° = South, 270° = West)
@export_range(0.0, 360.0, 1.0) var wind_direction: float = 0.0:
	set(val):
		wind_direction = fmod(val, 360.0)
		_update_wind_effects()

@export_group("Fog Curve")
## Fog density curve: X-axis = visibility (0-10000m), Y-axis = fog density (0.0-0.30)
## If null, uses default piecewise curve based on meteorological severity table
@export var fog_visibility_curve: Curve = null:
	set(val):
		if fog_visibility_curve != null and fog_visibility_curve.changed.is_connected(_update_fog):
			fog_visibility_curve.changed.disconnect(_update_fog)

		fog_visibility_curve = val

		if fog_visibility_curve != null:
			if not fog_visibility_curve.changed.is_connected(_update_fog):
				fog_visibility_curve.changed.connect(_update_fog)

		_update_fog()

var env_scene: SceneEnvironment
var sun_position: float = 0.0
var _set_cloud_coverage: float = 0.
var _cloud_brightness_modifier: float = 1.0
var _light_power_modifier: float = 1.0
var _sky_brightness_modifier: float = 1.0


## Check if simulating day/night cycle, determine rate of time, and increase time
func _update_time(dt: float) -> void:
	time_of_day += dt
	if time_of_day > 86400.0:
		time_of_day = 0.0

	if env_scene:
		env_scene.get_sound_controller().update_time(int(time_of_day))


## Update sun and moon based on current time of day
func _update_lights() -> void:
	sun_position = sun_root.global_position.y + 0.5
	sun.light_color = sky_preset.sun_light_color.gradient.sample(sun_position)
	sun.shadow_enabled = sun_shadow

	moon.light_color = sky_preset.moon_light_color.gradient.sample(sun_position)
	moon.shadow_enabled = moon_shadow

	var base_sun_energy: float = clamp(
		sky_preset.sun_light_intensity.sample(sun_position), 0.0, 1.0
	)
	var base_moon_energy: float = clamp(
		sky_preset.moon_light_intensity.sample(sun_position), 0.0, 1.0
	)

	sun.light_energy = base_sun_energy * _light_power_modifier
	moon.light_energy = base_moon_energy * _light_power_modifier


## Update rotation of sun and moon
func _update_rotation() -> void:
	var hour_mapped := remap(time_of_day, 0.0, 86400.0, 0.0, 1.0)
	sun_moon_parent.rotation_degrees.y = sky_rotation
	sun_moon_parent.rotation_degrees.x = hour_mapped * 360.0


## Update colors based on current time of day
func _update_sky() -> void:
	sun_position = sun_root.global_position.y / 2.0 + 0.5

	var sky_material = self.environment.sky.get_material()
	var cloud_color = lerp(
		sky_preset.base_cloud_color.gradient.sample(sun_position),
		sky_preset.overcast_cloud_color.gradient.sample(sun_position),
		_set_cloud_coverage
	)

	sky_material.set_shader_parameter("b_anim_stars", animate_star_map)
	sky_material.set_shader_parameter("b_anim_clouds", animate_clouds)

	var base_sky_color: Color = sky_preset.base_sky_color.gradient.sample(sun_position)
	var darkened_sky_color := base_sky_color * _sky_brightness_modifier

	if rain_intensity > 0.0:
		var grey_amount := remap(rain_intensity, 0.0, 50.0, 0.0, 0.6)
		var luminance := (
			darkened_sky_color.r * 0.299
			+ darkened_sky_color.g * 0.587
			+ darkened_sky_color.b * 0.114
		)
		var grey_color := Color(luminance, luminance, luminance, darkened_sky_color.a)
		darkened_sky_color = darkened_sky_color.lerp(grey_color, grey_amount)

	sky_material.set_shader_parameter("base_color", darkened_sky_color)
	sky_material.set_shader_parameter("base_cloud_color", cloud_color)
	sky_material.set_shader_parameter("horizon_size", sky_preset.horizon_size)
	sky_material.set_shader_parameter("horizon_alpha", sky_preset.horizon_alpha)

	var base_horizon_color: Color = sky_preset.horizon_fog_color.gradient.sample(sun_position)
	var darkened_horizon_color := base_horizon_color * _sky_brightness_modifier
	sky_material.set_shader_parameter("horizon_fog_color", darkened_horizon_color)

	sky_material.set_shader_parameter("cloud_type", 1)

	sky_material.set_shader_parameter("cloud_density", sky_preset.cloud_density)
	sky_material.set_shader_parameter("mg_size", sky_preset.cloud_glow)
	sky_material.set_shader_parameter("cloud_speed", sky_preset.cloud_speed)
	sky_material.set_shader_parameter("cloud_direction", sky_preset.cloud_direction)
	sky_material.set_shader_parameter("cloud_coverage", _set_cloud_coverage)
	sky_material.set_shader_parameter("absorption", sky_preset.cloud_light_absorbtion)
	sky_material.set_shader_parameter("henyey_greenstein_level", sky_preset.anisotropy)
	sky_material.set_shader_parameter("cloud_edge", sky_preset.cloud_edge)
	var adjusted_brightness := sky_preset.cloud_brightness * _cloud_brightness_modifier
	sky_material.set_shader_parameter("dynamic_cloud_brightness", adjusted_brightness)
	sky_material.set_shader_parameter("horizon_uv_curve", sky_preset.cloud_uv_curvature)

	sky_material.set_shader_parameter("sun_radius", sky_preset.sun_radius)
	sky_material.set_shader_parameter(
		"sun_disc_color", sky_preset.sun_disc_color.gradient.sample(sun_position)
	)
	sky_material.set_shader_parameter(
		"sun_glow_color", sky_preset.sun_glow.gradient.sample(sun_position)
	)
	sky_material.set_shader_parameter("sun_edge_blur", sky_preset.sun_edge_blur)
	sky_material.set_shader_parameter("sun_glow_intensity", sky_preset.sun_glow_intensity)
	sky_material.set_shader_parameter(
		"sunlight_color", sky_preset.sun_light_color.gradient.sample(sun_position)
	)

	sky_material.set_shader_parameter("moon_radius", sky_preset.moon_radius)
	sky_material.set_shader_parameter(
		"moon_glow_color", sky_preset.moon_glow_color.gradient.sample(sun_position)
	)
	sky_material.set_shader_parameter("moon_edge_blur", sky_preset.moon_edge_blur)
	sky_material.set_shader_parameter("moon_glow_intensity", sky_preset.moon_glow_intensity)
	sky_material.set_shader_parameter(
		"moon_light_color", sky_preset.moon_light_color.gradient.sample(sun_position)
	)

	sky_material.set_shader_parameter("star_color", sky_preset.star_color)
	sky_material.set_shader_parameter("star_brightness", sky_preset.star_brightness)
	sky_material.set_shader_parameter("twinkle_speed", sky_preset.twinkle_speed)
	sky_material.set_shader_parameter("twinkle_scale", sky_preset.twinkle_scale)
	sky_material.set_shader_parameter("star_resolution", sky_preset.star_resolution)
	sky_material.set_shader_parameter("star_speed", sky_preset.star_speed)


func _update_environment() -> void:
	if env_anchor == null:
		return
	var env := environment_scene.instantiate() as SceneEnvironment
	env_scene = env
	env_anchor.add_child(env)


## Tick time
## [param dt] Delta time since last tick
func tick(dt: float) -> void:
	_update_time(dt)
	_update_rotation()
	_update_sky()
	_update_lights()


func _ready() -> void:
	set_process(Engine.is_editor_hint())
	_update_environment()


func _process(_dt: float) -> void:
	if sun_moon_parent == null:
		return
	if sun_root == null:
		return
	if sun == null:
		return
	if moon_root == null:
		return
	if moon == null:
		return
	_update_rotation()
	_update_sky()
	_update_lights()

	if not env_scene:
		_update_environment()


## Set rain intensity and update particle effects
## [param intensity_mm_h] Rainfall in millimeters per hour (0.0 - 50.0)
func set_rain_intensity(intensity_mm_h: float) -> void:
	rain_intensity = intensity_mm_h


## Set fog visibility distance
## [param visibility_m] Visibility distance in meters (0.0 - 10000.0)
## Lower values = denser fog
func set_fog_visibility(visibility_m: float) -> void:
	fog_visibility = visibility_m


## Set wind parameters
## [param speed_m_s] Wind speed in meters per second (0.0 - 110.0)
## [param direction_deg] Wind azimuth direction in degrees (0.0 - 360.0)
## 0° = North, 90° = East, 180° = South, 270° = West
func set_wind(speed_m_s: float, direction_deg: float) -> void:
	wind_speed = speed_m_s
	wind_direction = direction_deg


## Update all weather parameters at once
## [param rain_mm_h] Rainfall intensity in mm/h
## [param fog_visibility_m] Fog visibility in meters
## [param wind_speed_m_s] Wind speed in m/s
## [param wind_direction_deg] Wind azimuth in degrees
func set_weather(
	rain_mm_h: float, fog_visibility_m: float, wind_speed_m_s: float, wind_direction_deg: float
) -> void:
	rain_intensity = rain_mm_h
	fog_visibility = fog_visibility_m
	wind_speed = wind_speed_m_s
	wind_direction = wind_direction_deg


## Internal: Update rain particle system based on intensity
func _update_rain_particles() -> void:
	if rain_node == null:
		return

	if rain_intensity <= 0.0:
		rain_node.emitting = false
		return

	rain_node.emitting = true

	var amount := int(remap(rain_intensity, 0.0, 50.0, 100.0, 5000.0))
	rain_node.amount = amount

	var lifetime := remap(rain_intensity, 0.0, 50.0, 2.0, 0.8)
	rain_node.lifetime = lifetime

	var speed_scale := remap(rain_intensity, 0.0, 50.0, 0.8, 2.0)
	rain_node.speed_scale = speed_scale

	var process_mat := rain_node.process_material as ParticleProcessMaterial
	if process_mat:
		var gravity := remap(rain_intensity, 0.0, 50.0, -9.8, -20.0)
		process_mat.gravity = Vector3(0, gravity, 0)

		process_mat.initial_velocity_min = remap(rain_intensity, 0.0, 50.0, 5.0, 15.0)
		process_mat.initial_velocity_max = remap(rain_intensity, 0.0, 50.0, 8.0, 20.0)


## Internal: Update fog density based on visibility distance
func _update_fog() -> void:
	if environment == null:
		return

	var visibility_fog_density := 0.0

	if fog_visibility_curve != null:
		var normalized_visibility: float = clamp(fog_visibility / 10000.0, 0.0, 1.0)
		visibility_fog_density = fog_visibility_curve.sample(normalized_visibility)
	else:
		if fog_visibility < 50.0:
			visibility_fog_density = remap(fog_visibility, 0.0, 50.0, 0.30, 0.20)
		elif fog_visibility < 200.0:
			visibility_fog_density = remap(fog_visibility, 50.0, 200.0, 0.20, 0.10)
		elif fog_visibility < 500.0:
			visibility_fog_density = remap(fog_visibility, 200.0, 500.0, 0.10, 0.05)
		elif fog_visibility < 1000.0:
			visibility_fog_density = remap(fog_visibility, 500.0, 1000.0, 0.05, 0.02)
		elif fog_visibility < 2000.0:
			visibility_fog_density = remap(fog_visibility, 1000.0, 2000.0, 0.02, 0.008)
		elif fog_visibility < 4000.0:
			visibility_fog_density = remap(fog_visibility, 2000.0, 4000.0, 0.008, 0.002)
		elif fog_visibility < 10000.0:
			visibility_fog_density = remap(fog_visibility, 4000.0, 10000.0, 0.002, 0.0)
		else:
			visibility_fog_density = 0.0

	var rain_fog_density := 0.0
	if rain_intensity > 0.0:
		rain_fog_density = remap(rain_intensity, 0.0, 50.0, 0.0, 0.15)

	var fog_density: float = max(visibility_fog_density, rain_fog_density)
	fog_density = clamp(fog_density, 0.0, 0.30)

	environment.volumetric_fog_enabled = fog_density > 0.0
	environment.volumetric_fog_density = fog_density

	environment.fog_enabled = false


## Internal: Update wind effects on particles and clouds
func _update_wind_effects() -> void:
	if rain_node != null:
		var process_mat := rain_node.process_material as ParticleProcessMaterial
		if process_mat:
			var wind_rad := deg_to_rad(wind_direction)
			var wind_x := -sin(wind_rad) * wind_speed * 0.1
			var wind_z := cos(wind_rad) * wind_speed * 0.1

			process_mat.direction = Vector3(wind_x, -1, wind_z).normalized()

	if sky_preset != null:
		var cloud_speed: float = wind_speed * 0.001
		sky_preset.cloud_speed = clamp(cloud_speed, 0.0, 10.0)

		var wind_rad := deg_to_rad(wind_direction)
		sky_preset.cloud_direction = Vector2(sin(wind_rad), -cos(wind_rad))


## Internal: Update cloud coverage based on weather conditions
func _update_weather_cloud_coverage() -> void:
	var rain_cloud_coverage: float = 1.0
	_set_cloud_coverage = max(cloud_coverage, rain_cloud_coverage)

	if rain_intensity > 0.0:
		_cloud_brightness_modifier = remap(rain_intensity, 0.0, 50.0, 1.0, 0.3)
		_sky_brightness_modifier = remap(rain_intensity, 0.0, 50.0, 1.0, 0.15)
		_light_power_modifier = remap(rain_intensity, 0.0, 50.0, 1.0, 0.35)
	else:
		_cloud_brightness_modifier = 1.0
		_sky_brightness_modifier = 1.0
		_light_power_modifier = 1.0


## Get current rain intensity
## [return] Current rainfall in mm/h
func get_rain_intensity() -> float:
	return rain_intensity


## Get current fog visibility
## [return] Current visibility distance in meters
func get_fog_visibility() -> float:
	return fog_visibility


## Get current wind speed
## [return] Current wind speed in m/s
func get_wind_speed() -> float:
	return wind_speed


## Get current wind direction
## [return] Current wind azimuth in degrees
func get_wind_direction() -> float:
	return wind_direction


## Get all current weather parameters
## [return] Dictionary with keys: rain_mm_h, fog_visibility_m, wind_speed_m_s, wind_direction_deg
func get_weather() -> Dictionary:
	return {
		"rain_mm_h": rain_intensity,
		"fog_visibility_m": fog_visibility,
		"wind_speed_m_s": wind_speed,
		"wind_direction_deg": wind_direction
	}
