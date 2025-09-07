extends Control
class_name GridLayer

@export var grid_100m_color: Color
@export var grid_1km_color: Color
@export var grid_line_px: float = 1.0
@export var grid_1km_line_px: float = 2.0
var data: TerrainData

func set_data(d: TerrainData) -> void:
	data = d
	queue_redraw()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()

func _draw() -> void:
	if data == null:
		return

	var w := size.x
	var h := size.y
	var step := 100.0
	var thick_every := 1000.0

	var align_offset = func (line_w: float) -> float:
		return 0.5 if (int(round(line_w)) % 2 != 0) else 0.0

	var x := 0.0
	while x < w:
		var is_thick := fmod((x + 0.0001), thick_every) < 0.2
		var col := grid_1km_color if is_thick else grid_100m_color
		var lw := grid_1km_line_px if is_thick else grid_line_px
		var off: float = align_offset.call(lw)
		draw_line(Vector2(x + off, 0.0), Vector2(x + off, h - 1.0), col, lw, true)
		x += step

	var rx := w - 1.0
	var rx_thick := fmod((rx + 0.0001), thick_every) < 0.2
	var rx_col := grid_1km_color if rx_thick else grid_100m_color
	var rx_lw := grid_1km_line_px if rx_thick else grid_line_px
	var rx_off: float = align_offset.call(rx_lw)
	draw_line(Vector2(rx + rx_off, 0.0), Vector2(rx + rx_off, h - 1.0), rx_col, rx_lw, true)

	var y := 0.0
	while y < h:
		var is_thick_y := fmod((y + 0.0001), thick_every) < 0.2
		var col_y := grid_1km_color if is_thick_y else grid_100m_color
		var lw_y := grid_1km_line_px if is_thick_y else grid_line_px
		var off_y: float = align_offset.call(lw_y)
		draw_line(Vector2(0.0, y + off_y), Vector2(w - 1.0, y + off_y), col_y, lw_y, true)
		y += step

	var by := h - 1.0
	var by_thick := fmod((by + 0.0001), thick_every) < 0.2
	var by_col := grid_1km_color if by_thick else grid_100m_color
	var by_lw := grid_1km_line_px if by_thick else grid_line_px
	var by_off: float = align_offset.call(by_lw)
	draw_line(Vector2(0.0, by + by_off), Vector2(w - 1.0, by + by_off), by_col, by_lw, true)
