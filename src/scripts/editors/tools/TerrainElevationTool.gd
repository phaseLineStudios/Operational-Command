extends TerrainToolBase
class_name TerrainElevationTool

## Elevation editing: raise/lower/smooth brush.

enum Mode { RAISE, LOWER, SMOOTH }

@export var meters_per_pixel := 1.0
@export var brush_radius_m := 100.0
@export var falloff_p := 0.5
@export var strength_m := 3.0

var mode: int = Mode.RAISE

var _is_drag := false

func _init():
	tool_icon = preload("res://assets/textures/ui/editors_elevation_tool.png")
	tool_hint = "Elevation Tool"

func build_preview(overlay_parent: Node) -> Control:
	var p := BrushPreviewCircle.new()
	p.meters_per_pixel = meters_per_pixel
	p.radius_m = brush_radius_m
	p.falloff = falloff_p
	p.strength_m = strength_m
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.pivot_offset = Vector2.ZERO
	p.z_index = 100
	overlay_parent.add_child(p)
	return p

func _place_preview(local_px: Vector2) -> void:
	if _preview is Control:
		var p := _preview as Control
		p.position = local_px
		if p is BrushPreviewCircle:
			(p as BrushPreviewCircle).radius_m = brush_radius_m
			(p as BrushPreviewCircle).falloff = falloff_p
			(p as BrushPreviewCircle).strength_m = strength_m
		p.visible = true
		p.queue_redraw()

func build_options_ui(p: Control) -> void:
	var vb := VBoxContainer.new()
	p.add_child(vb)
	var lb := OptionButton.new()
	lb.add_item("Raise", Mode.RAISE)
	lb.add_item("Lower", Mode.LOWER)
	lb.add_item("Smooth", Mode.SMOOTH)
	lb.selected = mode
	lb.item_selected.connect(func(i): mode = i)
	vb.add_child(_label("Mode"))
	vb.add_child(lb)


	var r := HSlider.new()
	r.min_value = 5
	r.max_value = 200
	r.step = 1
	r.value = brush_radius_m
	r.value_changed.connect(func(v): brush_radius_m = v)
	vb.add_child(_label("Radius (m)"))
	vb.add_child(r)

	var f := HSlider.new()
	f.min_value = 0.0
	f.max_value = 1.0
	f.step = 0.01
	f.value = falloff_p
	f.value_changed.connect(func(v): falloff_p = v)
	vb.add_child(_label("Falloff"))
	vb.add_child(f)

	var s := HSlider.new()
	s.min_value = 0.1
	s.max_value = 10
	s.step = 0.1
	s.value = strength_m
	s.value_changed.connect(func(v): strength_m = v)
	vb.add_child(_label("Strength (m)"))
	vb.add_child(s)

func build_info_ui(parent: Control) -> void:
	var l = Label.new()
	l.text = "Edit Terrain Elevation"
	parent.add_child(l)

func build_hint_ui(parent: Control) -> void:
	parent.add_child(_label("LMB - Draw"))

## Helper function to create a new label
func _label(t: String) -> Label:
	var l := Label.new()
	l.text = t
	return l

func handle_view_input(event: InputEvent) -> bool:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_is_drag = true
			_apply(event.position)
		else:
			_is_drag = false
		return true
	if _is_drag and event is InputEventMouseMotion:
		_apply(event.position)
		return true
	return false

## Draw elevation change
func _apply(screen_pos: Vector2) -> void:
	var img := data.elevation
	if img.is_empty(): 
		return
	
	var local_m := editor.screen_to_map(screen_pos, true)
	if not local_m.is_finite():
		return
	
	var local_terrain := editor.terrain_to_map(local_m)
	var px := data.world_to_elev_px(local_terrain)

	var r_px := int(round(brush_radius_m / data.elevation_resolution_m))
	var r_px_i := int(round(r_px))
	var r_hard: float = r_px * clamp(falloff_p, 0.0, 1.0)
	var soft_band: float = max(r_px - r_hard, 0.0001)
	for y in range(-r_px_i, r_px_i + 1):
		for x in range(-r_px_i, r_px_i + 1):
			if (x * x + y * y) > int(r_px * r_px):
				continue

			var p := Vector2i(px.x + x, px.y + y)
			if p.x < 0 or p.y < 0 or p.x >= img.get_width() or p.y >= img.get_height():
				continue

			var d := sqrt(float(x * x + y * y))
			var w := 1.0
			if d > r_hard:
				var t := (d - r_hard) / soft_band
				w = 1.0 - _smooth01(t)

			if w <= 0.0:
				continue

			var e := img.get_pixel(p.x, p.y).r

			match mode:
				Mode.RAISE:
					e += strength_m * w
				Mode.LOWER:
					e -= strength_m * w
				Mode.SMOOTH:
					var sum := 0.0
					var cnt := 0
					for yy in range(-1, 2):
						for xx in range(-1, 2):
							var q := Vector2i(p.x + xx, p.y + yy)
							if q.x < 0 or q.y < 0 or q.x >= img.get_width() or q.y >= img.get_height():
								continue
							sum += img.get_pixel(q.x, q.y).r
							cnt += 1
					if cnt > 0:
						var avg := sum / cnt
						var alpha: float = clamp(0.5 * w * strength_m, 0.0, 1.0)
						e = lerp(e, avg, alpha)

			data.set_elev_px(p, e)

## Helper for smooth fade
func _smooth01(x: float) -> float:
	var t: float = clamp(x, 0.0, 1.0)
	return t * t * (3.0 - 2.0 * t)

## Inner Class for a circle preview
class BrushPreviewCircle extends Control:
	var meters_per_pixel := 1.0
	var radius_m := 32.0
	var falloff := 0.5
	var strength_m := 1.0
	var antialias := true
	func _draw() -> void:
		var r_px := radius_m / meters_per_pixel
		var r_hard: float = r_px * clamp(falloff, 0.0, 1.0)
		var col_outer := Color(0.2, 0.6, 1.0, 0.8)
		var col_inner := Color(0.2, 0.6, 1.0, 0.4)
		var w_outer: float = clamp(r_px * 0.03, 1.0, 3.0)
		var w_inner: float = clamp(r_px * 0.02, 1.0, 2.0)
		draw_arc(Vector2.ZERO, r_px,   0.0, TAU, int(clamp(r_px * 0.8, 24.0, 128.0)), col_outer, w_outer, antialias)
		if r_hard > 0.5:
			draw_arc(Vector2.ZERO, r_hard, 0.0, TAU, int(clamp(r_px * 0.8, 24.0, 128.0)), col_inner, w_inner, antialias)
