@tool
class_name OCMenuButton
extends Button

@export_group("UI Sounds")
@export var hover_sounds: Array[AudioStream] = [
	preload("res://audio/ui/sfx_ui_button_hover_01.wav"),
	preload("res://audio/ui/sfx_ui_button_hover_02.wav")
]
@export var hover_disabled_sounds: Array[AudioStream] = []
@export var click_sounds: Array[AudioStream] = [
	preload("res://audio/ui/sfx_ui_button_click_01.wav"),
]
@export var click_disabled_sounds: Array[AudioStream] = []

@export_group("Noise Overlay")
## Enable/disable noise overlay
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable/Disable noise overlay")
var noise_enabled: bool = true:
	get:
		return _noise_enabled
	set(value):
		_noise_enabled = value
		if is_inside_tree():
			queue_redraw()

@export var noise_opacity: float = 0.02:
	get:
		return _noise_opacity
	set(value):
		_noise_opacity = clampf(value, 0.0, 1.0)
		if is_inside_tree():
			queue_redraw()

@export var noise_grain: float = 1.0:
	get:
		return _noise_grain
	set(value):
		_noise_grain = max(1.0, value)
		if is_inside_tree():
			queue_redraw()

@export var noise_seed: int = 0:
	get:
		return _noise_seed
	set(value):
		_noise_seed = value
		_rebuild_noise_tex()
		if is_inside_tree():
			queue_redraw()

var _noise_tex: ImageTexture
var _noise_enabled := true
var _noise_opacity := 0.02
var _noise_grain := 1.0
var _noise_seed := 0


func _ready() -> void:
	mouse_entered.connect(_play_hover)
	pressed.connect(_play_pressed)


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()


func _draw() -> void:
	_draw_noise_overlay()


func _play_hover() -> void:
	if not disabled:
		if hover_sounds.size() > 0:
			AudioManager.play_random_ui_sound(hover_sounds, Vector2(1.0, 1.0), Vector2(0.98, 1.02))
	else:
		if hover_disabled_sounds.size() > 0:
			AudioManager.play_random_ui_sound(
				hover_disabled_sounds, Vector2(1.0, 1.0), Vector2(0.98, 1.02)
			)


func _play_pressed() -> void:
	if not disabled:
		if click_sounds.size() > 0:
			AudioManager.play_random_ui_sound(click_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1))
	else:
		if click_disabled_sounds.size() > 0:
			AudioManager.play_random_ui_sound(
				click_disabled_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1)
			)


func _rebuild_noise_tex() -> void:
	if _noise_tex != null:
		return
	var w := 256
	var h := 256
	var img := Image.create(w, h, false, Image.FORMAT_L8)
	var rng := RandomNumberGenerator.new()
	rng.seed = int(_noise_seed)

	for y in h:
		for x in w:
			var v := rng.randi_range(0, 255)
			img.set_pixelv(Vector2i(x, y), Color8(v, 0, 0, 255))

	_noise_tex = ImageTexture.create_from_image(img)


func _draw_noise_overlay():
	if not noise_enabled:
		return

	_rebuild_noise_tex()

	var noise_scale: Variant = max(1.0, _noise_grain)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(noise_scale, noise_scale))
	draw_texture_rect(
		_noise_tex,
		Rect2(Vector2(0, 0), size / noise_scale),
		true,
		Color(1, 1, 1, clamp(_noise_opacity, 0.0, 1.0))
	)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
