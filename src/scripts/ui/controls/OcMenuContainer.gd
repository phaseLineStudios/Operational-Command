@tool
class_name OCMenuContainer
extends PanelContainer

## Draws a padded container for menues that continues the general style.

## Content margins in pixels (starting from left going clockwise).
@export var padding: Vector4i = Vector4(25, 25, 25, 25)
## Inner content margins (inside border) (starting from left going clockwise).
@export var inner_padding: Vector4i = Vector4(5, 5, 5, 5)

@export_group("Border")
## Border width in pixels (starting from left going clockwise).
@export var border_width: Vector4i = Vector4(2, 2, 2, 2)
## Border Color.
@export var border_color: Color = Color(0.224, 0.255, 0.271, 1.0)

@export_group("Grid")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable/Disable Grid") var grid_enabled: bool = true
## Amount of cells to display (columns, rows)
@export var cell_size: Vector2 = Vector2(60, 60)
## Grid line color
@export var line_color: Color = Color(0.106, 0.122, 0.137, 0.55)
## Grid line width
@export var width_color: int = 1

@export_group("Noise Overlay")
## Enable/disable noise overlay
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable/Disable noise overlay") var noise_enabled: bool:
	get:
		return _noise_enabled
	set(value):
		_noise_enabled = value
		if is_inside_tree():
			queue_redraw()

@export var noise_opacity: float:
	get:
		return _noise_opacity
	set(value):
		_noise_opacity = clampf(value, 0.0, 1.0)
		if is_inside_tree():
			queue_redraw()

@export var noise_grain: float:
	get:
		return _noise_grain
	set(value):
		_noise_grain = max(1.0, value)
		if is_inside_tree():
			queue_redraw()

@export var noise_seed: int:
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


func _ready():
	_setup()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()


func _draw():
	_draw_grid()
	_draw_border()
	_draw_noise_overlay()


func _setup():
	var sb := get_theme_stylebox("panel")
	sb.bg_color = Color(0.067, 0.082, 0.098)
	sb.content_margin_left = padding.x + inner_padding.x
	sb.content_margin_top = padding.y + inner_padding.y
	sb.content_margin_right = padding.z + inner_padding.z
	sb.content_margin_bottom = padding.w + inner_padding.w
	add_theme_stylebox_override("panel", sb)


func _draw_grid() -> void:
	if not grid_enabled:
		return
	var grid_size: Vector2 = size - Vector2(padding.x + padding.z, padding.y + padding.w)
	var grid_tl: Vector2 = Vector2(padding.x, padding.y)

	var cols: int = int(ceil(grid_size.x / cell_size.x))
	var rows: int = int(ceil(grid_size.y / cell_size.y))

	for i in range(cols + 1):
		var x := grid_tl.x + i * cell_size.x
		draw_line(Vector2(x, grid_tl.y), Vector2(x, grid_tl.y + grid_size.y), line_color)

	for j in range(rows + 1):
		var y := grid_tl.y + j * cell_size.y
		draw_line(Vector2(grid_tl.x, y), Vector2(grid_tl.x + grid_size.x, y), line_color)


func _draw_border():
	var grid_size: Vector2 = size - Vector2(padding.x + padding.z, padding.y + padding.w)
	var top_left := Vector2(padding.x, padding.y)
	var top_right := top_left + Vector2(grid_size.x, 0)
	var bottom_left := top_left + Vector2(0, grid_size.y)
	var bottom_right := bottom_left + Vector2(grid_size.x, 0)

	draw_line(top_left, bottom_left, border_color, border_width.x)
	draw_line(top_left, top_right, border_color, border_width.y)
	draw_line(top_right, bottom_right, border_color, border_width.z)
	draw_line(bottom_left, bottom_right, border_color, border_width.w)


func _rebuild_noise_tex():
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
