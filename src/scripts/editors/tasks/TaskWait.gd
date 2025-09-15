extends UnitBaseTask
class_name UnitTask_Wait
## Wait/hold for a duration.

@export_range(0.0, 36000.0, 1.0) var duration_s: float = 60.0

func _init() -> void:
	type_id = &"wait"
	display_name = "Wait"
	color = Color.SLATE_GRAY
	icon = preload("res://assets/textures/ui/editors_task_wait.png")

func draw_glyph(canvas: Control, center: Vector2, hovered: bool, hover_scale: float, px: int, inner_px: int, _inst, _to_map: Callable, scale_icon: Callable) -> void:
	var r := px * 0.5 * (hover_scale if hovered else 1.0)
	canvas.draw_circle(center, r, color if hovered else Color(color, 0.5))
	canvas.draw_circle(center, r * 0.66, Color(0,0,0,0.0))

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
