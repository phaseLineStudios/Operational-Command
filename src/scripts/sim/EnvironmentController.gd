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
var moon_position: float = 0.0
var sun_pos_alpha: float = 0.0

# Procedural placeholder textures
var _scattering_lut: GradientTexture2D = null
var _cloud_texture: NoiseTexture2D = null
var _cloud_texture_2: NoiseTexture2D = null
var _star_texture: NoiseTexture2D = null
var _star_noise: NoiseTexture2D = null

@onready var sky: WorldEnvironment = self


## Initialize procedural placeholder textures
func _init_placeholder_textures() -> void:
	# Scattering LUT - atmospheric scattering gradient
	_scattering_lut = GradientTexture2D.new()
	var gradient = Gradient.new()
	gradient.set_color(0, Color(0.6, 0.7, 0.9, 1.0))  # Horizon - light blue
	gradient.set_color(1, Color(0.2, 0.4, 0.9, 1.0))  # Zenith - deep blue
	_scattering_lut.gradient = gradient
	_scattering_lut.fill = GradientTexture2D.FILL_LINEAR
	_scattering_lut.fill_from = Vector2(0, 0)
	_scattering_lut.fill_to = Vector2(1, 1)
	_scattering_lut.width = 256
	_scattering_lut.height = 256

	# Cloud texture - main cloud shapes
	_cloud_texture = NoiseTexture2D.new()
	var cloud_noise = FastNoiseLite.new()
	cloud_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	cloud_noise.frequency = 0.01
	cloud_noise.fractal_octaves = 4
	_cloud_texture.noise = cloud_noise
	_cloud_texture.width = 512
	_cloud_texture.height = 512
	_cloud_texture.seamless = true  # Enable seamless tiling
	_cloud_texture.seamless_blend_skirt = 0.1

	# Cloud texture 2 - cloud detail
	_cloud_texture_2 = NoiseTexture2D.new()
	var cloud_noise_2 = FastNoiseLite.new()
	cloud_noise_2.noise_type = FastNoiseLite.TYPE_PERLIN
	cloud_noise_2.frequency = 0.02
	cloud_noise_2.fractal_octaves = 3
	cloud_noise_2.seed = 42
	_cloud_texture_2.noise = cloud_noise_2
	_cloud_texture_2.width = 512
	_cloud_texture_2.height = 512
	_cloud_texture_2.seamless = true  # Enable seamless tiling
	_cloud_texture_2.seamless_blend_skirt = 0.1

	# Star texture - starfield (use cellular noise for star points)
	_star_texture = NoiseTexture2D.new()
	var star_noise_gen = FastNoiseLite.new()
	star_noise_gen.noise_type = FastNoiseLite.TYPE_CELLULAR
	star_noise_gen.frequency = 0.1  # Density of stars
	star_noise_gen.cellular_distance_function = FastNoiseLite.DISTANCE_EUCLIDEAN
	star_noise_gen.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE  # Cell value for stars
	star_noise_gen.cellular_jitter = 1.0  # Randomize star positions
	_star_texture.noise = star_noise_gen
	_star_texture.width = 2048  # Higher resolution for sharper stars
	_star_texture.height = 2048
	_star_texture.seamless = true  # Enable seamless tiling
	_star_texture.seamless_blend_skirt = 0.1

	# Star noise - twinkling
	_star_noise = NoiseTexture2D.new()
	var twinkle_noise = FastNoiseLite.new()
	twinkle_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	twinkle_noise.frequency = 0.1
	_star_noise.noise = twinkle_noise
	_star_noise.width = 256
	_star_noise.height = 256
	_star_noise.seamless = true  # Enable seamless tiling
	_star_noise.seamless_blend_skirt = 0.1


## Check if simulating day/night cycle, determine rate of time, and increase time
func _update_time(dt: float) -> void:
	time_of_day += dt
	if time_of_day > 86400.0:
		time_of_day = 0.0


## Update sun and moon based on current time of day
func _update_lights() -> void:
	sun_position = sun_root.global_position.y + 0.5
	moon_position = moon_root.global_position.y + 0.5
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
	var cloud_color = lerp(sky_preset.base_cloud_color.gradient.sample(sun_position),sky_preset.overcast_cloud_color.gradient.sample(sun_position), cloud_coverage)
	
	sky_material.set_shader_parameter("bAnimStars", animate_star_map)
	sky_material.set_shader_parameter("bAnimClouds", animate_clouds)
	#sky_material.set_shader_parameter("bStaticClouds",staticClouds) *DEPRECATED*
	
	sky_material.set_shader_parameter("baseColor", sky_preset.base_sky_color.gradient.sample(sun_position))
	sky_material.set_shader_parameter("baseCloudColor", cloud_color)
	sky_material.set_shader_parameter("horizonSize",sky_preset.horizon_size)
	sky_material.set_shader_parameter("horizonAlpha",sky_preset.horizon_alpha)
	sky_material.set_shader_parameter("horizonFogColor", sky_preset.horizon_fog_color.gradient.sample(sun_position))

	sky_material.set_shader_parameter("cloudType",1)
	self.environment.volumetric_fog_density = remap(cloud_coverage,0.5,1.0,0.0,0.024)
	
	sky_material.set_shader_parameter("cloudDensity",sky_preset.cloud_density)
	sky_material.set_shader_parameter("mgSize",sky_preset.cloud_glow)
	sky_material.set_shader_parameter("cloudSpeed",sky_preset.cloud_speed)
	sky_material.set_shader_parameter("cloudDirection",sky_preset.cloud_direction)
	sky_material.set_shader_parameter("cloudCoverage",cloud_coverage)
	sky_material.set_shader_parameter("absorption",sky_preset.cloud_light_absorbtion)
	sky_material.set_shader_parameter("henyeyGreensteinLevel",sky_preset.anisotropy)
	sky_material.set_shader_parameter("cloudEdge",sky_preset.cloud_edge)
	sky_material.set_shader_parameter("dynamicCloudBrightness",sky_preset.cloud_brightness)
	sky_material.set_shader_parameter("horizonUVCurve",sky_preset.cloud_uv_curvature)
	
	sky_material.set_shader_parameter("sunRadius",sky_preset.sun_radius)
	sky_material.set_shader_parameter("sunDiscColor", sky_preset.sun_disc_color.gradient.sample(sun_position))
	sky_material.set_shader_parameter("sunGlowColor",sky_preset.sun_glow)
	sky_material.set_shader_parameter("sunGlowColor", sky_preset.sun_glow.gradient.sample(sun_position))
	sky_material.set_shader_parameter("sunEdgeBlur",sky_preset.sun_edge_blur)
	sky_material.set_shader_parameter("sunGlowIntensity",sky_preset.sun_glow_intensity)
	sky_material.set_shader_parameter("sunlightColor", sky_preset.sun_light_color.gradient.sample(sun_position))
	
	sky_material.set_shader_parameter("moonRadius",sky_preset.moon_radius)
	sky_material.set_shader_parameter("moonGlowColor", sky_preset.moon_glow_color.gradient.sample(sun_position))
	sky_material.set_shader_parameter("moonEdgeBlur",sky_preset.moon_edge_blur)
	sky_material.set_shader_parameter("moonGlowIntensity",sky_preset.moon_glow_intensity)
	sky_material.set_shader_parameter("moonLightColor", sky_preset.moon_light_color.gradient.sample(sun_position))
	
	sky_material.set_shader_parameter("starColor",sky_preset.star_color)
	sky_material.set_shader_parameter("starBrightness",sky_preset.star_brightness)
	sky_material.set_shader_parameter("twinkleSpeed",sky_preset.twinkle_speed)
	sky_material.set_shader_parameter("twinkleScale",sky_preset.twinkle_scale)
	sky_material.set_shader_parameter("starResolution",sky_preset.star_resolution)
	sky_material.set_shader_parameter("starSpeed",sky_preset.star_speed)


func _update_environment() -> void:
	if env_anchor == null:
		return
	var env := environment_scene.instantiate() as SceneEnvironment
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
	_init_placeholder_textures()
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
