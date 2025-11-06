class_name PostProcessController
extends CanvasLayer

## Controlls Post Process filters.

@export_group("SSAO")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable SSAO") var ssao := true

@export_group("SSR")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable SSR") var ssr := true

@export_group("Glow")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable Glow") var glow := true
## Intensity of glow.
@export var glow_intensity: float = 0.6
## Intensity of bloom.
@export var glow_bloom: float = 0.04

@export_group("Adjustments")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable Ajdustments") var adjustments := true
## Scene Brightness.
@export var adjustment_brightness: float = 1.0
## Scene Contrast.
@export var adjustment_contrast: float = 1.05
## Scene Saturation.
@export var adjustment_saturation: float = 0.9
## Optional LUT.
@export var lut_texture: Texture

@export_group("Vignette")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable Vignette") var vignette := true
## Intensity of the vignette.
@export_range(0.0, 2.0) var vignette_intensity: float = 0.35
## Softness of the vignette.
@export_range(0.0, 1.0) var vignette_softness: float = 0.5

@export_group("Film Grain")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable Film Grain") var film_grain := true
## Amount of grains in Film Grain PPEffect.
@export_range(0.0, 1.0) var grain_amount: float = 0.05
## Size of grains in Film Grain PPEffect.
@export_range(0.1, 10.0) var grain_size: float = 1.0

@export_group("Chromatic Abberation")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable Chromatic Abberation") var ca := true
## Intensity of Chromatic Abboration.
@export_range(0.0, 5.0) var ca_intensity: float = 1.25

@export_group("Sharpen")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable Sharpen") var sharpen := true
## Strength of Sharpen/unsharpen mask.
@export_range(0.0, 3.0) var sharpen_strength: float = 0.6

var film_grain_shader: ShaderMaterial
var general_shader: ShaderMaterial
var environment: Environment

@onready var film_grain_rect: ColorRect = $GeneralPP
@onready var general_rect: ColorRect = $FilmGrain
@onready var world_environment: WorldEnvironment = %EnvironmentController


func _ready() -> void:
	film_grain_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	general_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	environment = world_environment.environment
	film_grain_shader = _get_shader(film_grain_rect)
	general_shader = _get_shader(general_rect)
	_apply_settings()


## apply parameters.
func _apply_settings() -> void:
	environment.tonemap_mode = Environment.TONE_MAPPER_ACES
	environment.adjustment_enabled = true
	environment.adjustment_brightness = adjustment_brightness
	environment.adjustment_contrast = adjustment_contrast
	environment.adjustment_saturation = adjustment_saturation
	environment.adjustment_color_correction = lut_texture

	environment.ssao_enabled = ssao
	environment.ssr_enabled = ssr

	environment.glow_enabled = glow
	environment.glow_intensity = glow_intensity
	environment.glow_bloom = glow_bloom

	film_grain_shader.set_shader_parameter("grain_amount", grain_amount)
	film_grain_shader.set_shader_parameter("grain_size", grain_size)

	general_shader.set_shader_parameter("vignette", vignette)
	general_shader.set_shader_parameter("vignette_intensity", vignette_intensity)
	general_shader.set_shader_parameter("vignette_softness", vignette_softness)
	general_shader.set_shader_parameter("chromatic_abberation", ca)
	general_shader.set_shader_parameter("ca_intensity", ca_intensity)
	general_shader.set_shader_parameter("sharpen", sharpen)
	general_shader.set_shader_parameter("sharpen_strength", sharpen_strength)


## Get shader material from CanvasItem.
func _get_shader(rect: CanvasItem) -> ShaderMaterial:
	return rect.material as ShaderMaterial
