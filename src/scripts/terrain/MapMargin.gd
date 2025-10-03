extends PanelContainer
class_name MarginLayer

## Font size for map title
@export var title_size: int
## Color of outer margin
@export var margin_color: Color = Color(1.0, 1.0, 1.0)
## Size of outer margin top
@export var margin_top_px: int = 50
## Size of outer margin bottom
@export var margin_bottom_px: int = 50
## Size of outer margin left
@export var margin_left_px: int = 50
## Size of outer margin right
@export var margin_right_px: int = 50

## When to show a grid number (per meter)
@export var margin_label_every_m: int = 100
## Color of grid number
@export var label_color: Color = Color(0.05, 0.05, 0.05, 1.0)
## Font of grid number
@export var label_font: Font
## Font size of grid number
@export var label_size: int = 14

## Show grid numbers at top
@export var show_top: bool = true
## Show grid numbers at bottom
@export var show_bottom: bool = true
## Show grid numbers at left
@export var show_left: bool = true
## Show grid numbers at right
@export var show_right: bool = true

## width of map border
@export var base_border_px: float = 1.0
## grid number offset top
@export var offset_top_px: float = -1.0
## grid number offset bottom
@export var offset_bottom_px: float = 10
## grid number offset left
@export var offset_left_px: float = -10
## grid number offset right
@export var offset_right_px: float = 10

var data: TerrainData
var _dirty := false


## API to set terrain data
func set_data(d: TerrainData) -> void:
	data = d
	queue_redraw()


## Apply root style
func apply_style(from: Node) -> void:
	if from == null:
		return
	if "title_size" in from:
		title_size = from.title_size
	if "margin_color" in from:
		margin_color = from.margin_color
	if "margin_top_px" in from:
		margin_top_px = from.margin_top_px
	if "margin_bottom_px" in from:
		margin_bottom_px = from.margin_bottom_px
	if "margin_left_px" in from:
		margin_left_px = from.margin_left_px
	if "margin_right_px" in from:
		margin_right_px = from.margin_right_px
	if "margin_label_every_m" in from:
		margin_label_every_m = from.margin_label_every_m
	if "label_color" in from:
		label_color = from.label_color
	if "label_font" in from:
		label_font = from.label_font
	if "label_size" in from:
		label_size = from.label_size
	if "show_top" in from:
		show_top = from.show_top
	if "show_bottom" in from:
		show_bottom = from.show_bottom
	if "show_left" in from:
		show_left = from.show_left
	if "show_right" in from:
		show_right = from.show_right
	if "base_border_px" in from:
		base_border_px = from.base_border_px
	if "offset_top_px" in from:
		offset_top_px = from.offset_top_px
	if "offset_bottom_px" in from:
		offset_bottom_px = from.offset_bottom_px
	if "offset_left_px" in from:
		offset_left_px = from.offset_left_px
	if "offset_right_px" in from:
		offset_right_px = from.offset_right_px


## Mark dirty for redraw
func mark_dirty():
	_dirty = true
	queue_redraw()


## Redraw margin on resize
func _notification(what):
	if what == NOTIFICATION_THEME_CHANGED or what == NOTIFICATION_RESIZED:
		queue_redraw()


func _draw() -> void:
	var margin_sb := StyleBoxFlat.new()
	margin_sb.bg_color = margin_color
	margin_sb.content_margin_top = margin_top_px
	margin_sb.content_margin_bottom = margin_bottom_px
	margin_sb.content_margin_left = margin_left_px
	margin_sb.content_margin_right = margin_right_px
	add_theme_stylebox_override("panel", margin_sb)

	if data == null or label_font == null:
		return

	var sb := get_theme_stylebox("panel")
	var l := 0.0
	var t := 0.0
	if sb:
		l = sb.get_content_margin(SIDE_LEFT)
		t = sb.get_content_margin(SIDE_TOP)

	var map_left := l + base_border_px
	var map_top := t + base_border_px
	var map_w := float(data.width_m) - base_border_px * 2.0
	var map_h := float(data.height_m) - base_border_px * 2.0
	var map_right := map_left + map_w
	var map_bottom := map_top + map_h

	var ascent: float
	var height: float
	if data.name != "":
		var center_x := 0.5 * (map_left + map_right)
		ascent = label_font.get_ascent(label_size)
		height = label_font.get_height(label_size)
		var y_mid := 0.5 + height
		var baseline_y := y_mid + (ascent - 0.5 * height)

		_draw_text_center(str(data.name), Vector2(center_x, baseline_y), title_size)

	var start_x := 0
	var start_y := 0
	if data.has_method("get"):
		if data.has_method("_get") or true:
			if "grid_start_x" in data:
				start_x = int(data.grid_start_x)
			if "grid_start_y" in data:
				start_y = int(data.grid_start_y)

	var every := float(max(1, margin_label_every_m))
	ascent = label_font.get_ascent(label_size)
	height = label_font.get_height(label_size)

	if every > 0.0 and (show_top or show_bottom):
		var i := 0
		while true:
			var m := i * every
			if m > map_w:
				break
			var screen_x := map_left + m
			var num := str(start_x + i)
			if show_top:
				_draw_text_center(num, Vector2(screen_x, map_top - ascent + offset_top_px))
			if show_bottom:
				_draw_text_center(num, Vector2(screen_x, map_bottom + ascent + offset_bottom_px))
			i += 1

	if every > 0.0 and (show_left or show_right):
		var j := 0
		while true:
			var m2 := j * every
			if m2 > map_h:
				break
			var screen_y := map_top + m2
			var num2 := str(start_y + j)
			if show_left:
				_draw_text_middle(num2, Vector2(map_left + offset_left_px, screen_y), true, ascent, height)
			if show_right:
				_draw_text_middle(num2, Vector2(map_right + offset_right_px, screen_y), false, ascent, height)
			j += 1


## Helper function to draw horizontally centered text
func _draw_text_center(text: String, pos: Vector2, font_size: int = label_size) -> void:
	var s := font_size
	var fm := label_font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, s)
	draw_string(label_font, pos - Vector2(fm.x * 0.5, 0), text, HORIZONTAL_ALIGNMENT_LEFT, -1, s, label_color)


## Helper function to draw vertically centered text
func _draw_text_middle(
	text: String, pos: Vector2, align_right: bool, ascent: float, height: float, font_size: int = label_size
) -> void:
	var s := font_size
	var fm := label_font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, s)
	var baseline_y := pos.y + (height - ascent)
	var draw_x := pos.x - fm.x if align_right else pos.x
	draw_string(label_font, Vector2(draw_x, baseline_y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, s, label_color)
