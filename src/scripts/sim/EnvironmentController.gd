@tool
class_name EnvironmentController
extends WorldEnvironment
## Controlls environmental factors

@export_category("Sky Control")
## Current time (in seconds)
@export_range(0.0, 86400.0, 1.0) var time_of_day: float = 43200.0
## Environment scene
@export var environment_scene: PackedScene = preload("res://scenes/environments/env_forest.tscn")

@export_group("Nodes")
## Parent of the sun and moon nodes
@export var sun_moon_parent: Node3D
@export var sun_root: MeshInstance3D
@export var moon_root: MeshInstance3D
@export var sun: DirectionalLight3D
@export var moon: DirectionalLight3D
@export var env_anchor: Node3D

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
## Overcast
@export_range(0, 1, 0.001) var cloud_coverage: float = 0.5
## Animate clouds
@export var animate_clouds: bool = true
## Animate stars
@export var animate_star_map: bool = true

var sun_position: float = 0.0


## Check if simulating day/night cycle, determine rate of time, and increase time
func _update_time(dt: float) -> void:
	time_of_day += dt
	if time_of_day > 86400.0:
		time_of_day = 0.0


## Update sun and moon based on current time of day
func _update_lights() -> void:
	sun_position = sun_root.global_position.y + 0.5
	sun.light_color = sky_preset.sun_light_color.gradient.sample(sun_position)
	sun.shadow_enabled = sun_shadow

	moon.light_color = sky_preset.moon_light_color.gradient.sample(sun_position)
	moon.shadow_enabled = moon_shadow

	sun.light_energy = clamp(sky_preset.sun_light_intensity.sample(sun_position), 0.0, 1.0)
	moon.light_energy = clamp(sky_preset.moon_light_intensity.sample(sun_position), 0.0, 1.0)


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
		cloud_coverage
	)

	sky_material.set_shader_parameter("b_anim_stars", animate_star_map)
	sky_material.set_shader_parameter("b_anim_clouds", animate_clouds)

	sky_material.set_shader_parameter(
		"base_color", sky_preset.base_sky_color.gradient.sample(sun_position)
	)
	sky_material.set_shader_parameter("base_cloud_color", cloud_color)
	sky_material.set_shader_parameter("horizon_size", sky_preset.horizon_size)
	sky_material.set_shader_parameter("horizon_alpha", sky_preset.horizon_alpha)
	sky_material.set_shader_parameter(
		"horizon_fog_color", sky_preset.horizon_fog_color.gradient.sample(sun_position)
	)

	sky_material.set_shader_parameter("cloud_type", 1)
	self.environment.volumetric_fog_density = remap(cloud_coverage, 0.5, 1.0, 0.0, 0.024)

	sky_material.set_shader_parameter("cloud_density", sky_preset.cloud_density)
	sky_material.set_shader_parameter("mg_size", sky_preset.cloud_glow)
	sky_material.set_shader_parameter("cloud_speed", sky_preset.cloud_speed)
	sky_material.set_shader_parameter("cloud_direction", sky_preset.cloud_direction)
	sky_material.set_shader_parameter("cloud_coverage", cloud_coverage)
	sky_material.set_shader_parameter("absorption", sky_preset.cloud_light_absorbtion)
	sky_material.set_shader_parameter("henyey_greenstein_level", sky_preset.anisotropy)
	sky_material.set_shader_parameter("cloud_edge", sky_preset.cloud_edge)
	sky_material.set_shader_parameter("dynamic_cloud_brightness", sky_preset.cloud_brightness)
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


## Tick time
## [param dt] Delta time since last tick
func tick(dt: float) -> void:
	_update_time(dt)
	_update_rotation()
	_update_sky()
	_update_lights()


func _ready() -> void:
	set_process(Engine.is_editor_hint())


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
