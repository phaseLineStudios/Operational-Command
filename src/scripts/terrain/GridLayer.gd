## GridLayer.gd
extends Control
class_name GridLayer

@export var grid_100m_color: Color
@export var grid_1km_color: Color
@export var grid_line_px := 1.0
@export var grid_1km_line_px := 2.0

var data: TerrainData
var _grid_tex: ImageTexture
var _need_bake := true

func set_data(d: TerrainData) -> void:
	data = d
	_need_bake = true
	queue_redraw()

## Apply root style
func apply_style(from: Node) -> void:
	if from == null: 
		return
	if "grid_100m_color" in from: grid_100m_color = from.grid_100m_color
	if "grid_1km_color" in from: grid_1km_color = from.grid_1km_color
	if "grid_line_px" in from: grid_line_px = from.grid_line_px
	if "grid_1km_line_px" in from: grid_1km_line_px = from.grid_1km_line_px
	mark_dirty()

func mark_dirty() -> void:
	_need_bake = true
	queue_redraw()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_need_bake = true
		queue_redraw()

func _draw():
	if data == null:
		return
	if _need_bake:
		_bake_grid_texture()
	if _grid_tex:
		draw_texture_rect(_grid_tex, Rect2(Vector2.ZERO, size), false)

func _bake_grid_texture() -> void:
	_need_bake = false
	var w := int(max(1.0, size.x))
	var h := int(max(1.0, size.y))
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	img.fill(Color(0,0,0,0))

	var step := 100.0
	var thick_every := 1000.0
	var odd_align = func (lw: float) -> float: 
		return 0.5 if (int(round(lw)) % 2 != 0) else 0.0

	var x := 0.0
	while x < w:
		var thick := fmod((x + 0.0001), thick_every) < 0.2
		var col := (grid_1km_color if thick else grid_100m_color)
		var lw := (grid_1km_line_px if thick else grid_line_px)
		var off: float = odd_align.call(lw)
		_draw_v_line(img, int(x + off), lw, col)
		x += step

	var rx := w - 1.0
	var thick_r := fmod((rx + 0.0001), thick_every) < 0.2
	_draw_v_line(
		img, 
		int(rx + odd_align.call(grid_1km_line_px if thick_r else grid_line_px)), 
		(grid_1km_line_px if thick_r else grid_line_px), 
		(grid_1km_color if thick_r else grid_100m_color)
	)

	var y := 0.0
	while y < h:
		var thick_y := fmod((y + 0.0001), thick_every) < 0.2
		var col_y := (grid_1km_color if thick_y else grid_100m_color)
		var lw_y := (grid_1km_line_px if thick_y else grid_line_px)
		var off_y: float = odd_align.call(lw_y)
		_draw_h_line(img, int(y + off_y), lw_y, col_y)
		y += step

	var by := h - 1.0
	var thick_b := fmod((by + 0.0001), thick_every) < 0.2
	_draw_h_line(
		img, 
		int(by + odd_align.call(grid_1km_line_px if thick_b else grid_line_px)), 
		(grid_1km_line_px if thick_b else grid_line_px), 
		(grid_1km_color if thick_b else grid_100m_color)
	)

	_grid_tex = ImageTexture.create_from_image(img)

func _draw_v_line(img: Image, x: int, lw: float, c: Color) -> void:
	var w := img.get_width()
	var h := img.get_height()
	var half := int(floor(max(1.0, lw) * 0.5))
	for xx in range(max(0, x - half), min(w, x + half + 1)):
		for yy in h:
			img.set_pixel(xx, yy, c)

func _draw_h_line(img: Image, y: int, lw: float, c: Color) -> void:
	var w := img.get_width()
	var h := img.get_height()
	var half := int(floor(max(1.0, lw) * 0.5))
	for yy in range(max(0, y - half), min(h, y + half + 1)):
		for xx in w:
			img.set_pixel(xx, yy, c)
