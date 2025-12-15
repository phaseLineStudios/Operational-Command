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

@export_group("Read Mode")
## Temporarily overrides post-processing/video settings to improve text readability.
@export var read_mode_enabled: bool = false:
	set(value):
		_read_mode_enabled = value
		if is_inside_tree():
			_apply_read_mode(_read_mode_enabled)
	get:
		return _read_mode_enabled
## Disable film grain while reading.
@export var read_mode_disable_film_grain: bool = true
## Disable chromatic aberration while reading.
@export var read_mode_disable_chromatic_aberration: bool = true
## Disable vignette while reading.
@export var read_mode_disable_vignette: bool = true
## Disable glow/bloom while reading.
@export var read_mode_disable_glow: bool = true
## Sharpen strength override while reading (<= 0 keeps current).
@export_range(0.0, 3.0) var read_mode_sharpen_strength: float = 0.9
## If true, temporarily force full-resolution rendering while reading.
@export var read_mode_force_full_res: bool = true

var film_grain_shader: ShaderMaterial
var general_shader: ShaderMaterial
var environment: Environment

var _read_mode_cached: bool = false
var _saved_settings: Dictionary = {}
var _saved_video: Dictionary = {}
var _read_mode_enabled: bool = false

@onready var general_rect: ColorRect = $GeneralPP
@onready var film_grain_rect: ColorRect = $FilmGrain
@onready var world_environment: WorldEnvironment = %EnvironmentController


func _ready() -> void:
	film_grain_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	general_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	environment = world_environment.environment
	film_grain_shader = _get_shader(film_grain_rect)
	general_shader = _get_shader(general_rect)
	_apply_settings()
	_apply_read_mode(read_mode_enabled)


## apply parameters.
func _apply_settings() -> void:
	environment.tonemap_mode = Environment.TONE_MAPPER_ACES
	environment.adjustment_enabled = adjustments
	environment.adjustment_brightness = adjustment_brightness
	environment.adjustment_contrast = adjustment_contrast
	environment.adjustment_saturation = adjustment_saturation
	environment.adjustment_color_correction = lut_texture

	environment.ssao_enabled = ssao
	environment.ssr_enabled = ssr

	environment.glow_enabled = glow
	environment.glow_intensity = glow_intensity
	environment.glow_bloom = glow_bloom
	if film_grain_rect:
		film_grain_rect.visible = film_grain
	if film_grain_shader:
		film_grain_shader.set_shader_parameter("grain_amount", grain_amount)
		film_grain_shader.set_shader_parameter("grain_size", grain_size)

	if general_shader:
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


func _apply_read_mode(enabled: bool) -> void:
	if enabled == _read_mode_cached:
		return
	_read_mode_cached = enabled

	if enabled:
		_saved_settings = {
			"film_grain": film_grain,
			"grain_amount": grain_amount,
			"grain_size": grain_size,
			"vignette": vignette,
			"vignette_intensity": vignette_intensity,
			"vignette_softness": vignette_softness,
			"glow": glow,
			"glow_intensity": glow_intensity,
			"glow_bloom": glow_bloom,
			"ca": ca,
			"ca_intensity": ca_intensity,
			"sharpen": sharpen,
			"sharpen_strength": sharpen_strength,
		}

		if read_mode_disable_film_grain:
			film_grain = false
			grain_amount = 0.0
		if read_mode_disable_vignette:
			vignette = false
			vignette_intensity = 0.0
		if read_mode_disable_glow:
			glow = false
			glow_intensity = 0.0
			glow_bloom = 0.0
		if read_mode_disable_chromatic_aberration:
			ca = false
			ca_intensity = 0.0
		if read_mode_sharpen_strength > 0.0:
			sharpen = true
			sharpen_strength = read_mode_sharpen_strength

		if read_mode_force_full_res:
			_save_video_state()
			_apply_video_full_res()
	else:
		if not _saved_settings.is_empty():
			film_grain = bool(_saved_settings.get("film_grain", film_grain))
			grain_amount = float(_saved_settings.get("grain_amount", grain_amount))
			grain_size = float(_saved_settings.get("grain_size", grain_size))
			vignette = bool(_saved_settings.get("vignette", vignette))
			vignette_intensity = float(
				_saved_settings.get("vignette_intensity", vignette_intensity)
			)
			vignette_softness = float(_saved_settings.get("vignette_softness", vignette_softness))
			glow = bool(_saved_settings.get("glow", glow))
			glow_intensity = float(_saved_settings.get("glow_intensity", glow_intensity))
			glow_bloom = float(_saved_settings.get("glow_bloom", glow_bloom))
			ca = bool(_saved_settings.get("ca", ca))
			ca_intensity = float(_saved_settings.get("ca_intensity", ca_intensity))
			sharpen = bool(_saved_settings.get("sharpen", sharpen))
			sharpen_strength = float(_saved_settings.get("sharpen_strength", sharpen_strength))
			_saved_settings.clear()

		_restore_video_state()

	_apply_settings()


func _save_video_state() -> void:
	_saved_video.clear()
	var window: Window = get_window()
	if window:
		_saved_video["content_scale_mode"] = int(window.content_scale_mode)
		_saved_video["content_scale_aspect"] = int(window.content_scale_aspect)
		_saved_video["content_scale_size"] = window.content_scale_size
	var root_vp := get_tree().root
	if root_vp:
		_saved_video["scaling_3d_mode"] = int(root_vp.scaling_3d_mode)
		_saved_video["scaling_3d_scale"] = float(root_vp.scaling_3d_scale)


func _apply_video_full_res() -> void:
	var window: Window = get_window()
	var root_vp := get_tree().root
	if window == null or root_vp == null:
		return

	# Keep the same scale mode but render at native window resolution for readability.
	if window.size.x > 0 and window.size.y > 0:
		window.content_scale_size = window.size

	root_vp.scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
	root_vp.scaling_3d_scale = 1.0


func _restore_video_state() -> void:
	if _saved_video.is_empty():
		return
	var window: Window = get_window()
	if window:
		window.content_scale_mode = (
			int(_saved_video.get("content_scale_mode", window.content_scale_mode))
			as Window.ContentScaleMode
		)
		window.content_scale_aspect = (
			int(_saved_video.get("content_scale_aspect", window.content_scale_aspect))
			as Window.ContentScaleAspect
		)
		window.content_scale_size = _saved_video.get(
			"content_scale_size", window.content_scale_size
		)
	var root_vp := get_tree().root
	if root_vp:
		root_vp.scaling_3d_mode = (
			int(_saved_video.get("scaling_3d_mode", root_vp.scaling_3d_mode))
			as Viewport.Scaling3DMode
		)
		root_vp.scaling_3d_scale = float(
			_saved_video.get("scaling_3d_scale", root_vp.scaling_3d_scale)
		)
	_saved_video.clear()
