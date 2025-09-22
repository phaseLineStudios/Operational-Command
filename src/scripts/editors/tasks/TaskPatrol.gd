extends UnitBaseTask
class_name UnitTask_Patrol
## Patrol within a radius around the point.

@export_range(10.0, 5000.0, 1.0) var radius_m: float = 150.0
@export_range(0.0, 36000.0, 1.0) var dwell_s: float = 0.0

func _init() -> void:
	type_id = &"patrol"
	display_name = "Patrol"
	color = Color.MEDIUM_SEA_GREEN
	icon = preload("res://assets/textures/ui/editors_task_patrol.png")

func draw_glyph(canvas: Control, center: Vector2, hovered: bool, hover_scale: float, px: int, inner_px: int, inst, to_map: Callable, scale_icon: Callable) -> void:
	var r := px * 0.5 * (hover_scale if hovered else 1.0)
	canvas.draw_circle(center, r, color.darkened(0.08) if hovered else Color(color.darkened(0.08), 0.5))
	var rad_m := float(inst.params.get("radius_m", radius_m))
	if rad_m > 0.0 and to_map.is_valid():
		var edge: Vector2 = to_map.call(inst.position_m + Vector2(rad_m, 0))
		var screen_r := edge.distance_to(center)
		var segs := 24
		for i in segs:
			if i % 2 == 0:
				var a1 := TAU * float(i) / segs
				var a2 := TAU * float(i+1) / segs
				var p1 := center + Vector2(cos(a1), sin(a1)) * screen_r
				var p2 := center + Vector2(cos(a2), sin(a2)) * screen_r
				canvas.draw_line(p1, p2, Color(color, 0.4), 2.0, true)

	if icon:
		var key := "TASK:%s:%s:%d" % [String(type_id), String(resource_path), inner_px]
		var itex: Texture2D = scale_icon.call(icon, key, inner_px)
		if itex:
			var half := itex.get_size() * 0.5
			if hovered:
				canvas.draw_set_transform(center, 0.0, Vector2.ONE * hover_scale)
				canvas.draw_texture(itex, -half, Color.WHITE if hovered else Color(1,1,1,0.5))
				canvas.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			else:
				canvas.draw_texture(itex, center - half)
