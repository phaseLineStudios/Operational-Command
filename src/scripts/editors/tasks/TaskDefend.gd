@icon("res://assets/textures/ui/editors_task_defend.png")
extends UnitBaseTask
class_name UnitTask_Defend
## Defend an area around the position.

## Radius of the defended area (meters)
@export var radius_m: float = 100.0
## Optional time to hold (seconds)
@export var hold_time_s: float = 0.0

func _init() -> void:
	type_id = &"defend"
	display_name = "Defend"
	color = Color.ORANGE
	icon = preload("res://assets/textures/ui/editors_task_defend.png")

func draw_glyph(canvas: Control, center: Vector2, hovered: bool, hover_scale: float, px: int, inner_px: int, inst, to_map: Callable, scale_icon: Callable) -> void:
	var r := px * 0.5 * (hover_scale if hovered else 1.0)
	canvas.draw_circle(center, r, color.darkened(0.1))

	var rad_m := float(inst.params.get("radius_m", radius_m))
	if rad_m > 0.0 and to_map.is_valid():
		var a: Vector2 = to_map.call(inst.position_m + Vector2(rad_m, 0))
		var screen_rad := a.distance_to(center)
		canvas.draw_circle(center, screen_rad, Color(color, 0.25))

	if icon:
		var key := "TASK:%s:%s:%d" % [String(type_id), String(resource_path), inner_px]
		var itex: Texture2D = scale_icon.call(icon, key, inner_px)
		if itex:
			var half := itex.get_size() * 0.5
			if hovered:
				canvas.draw_set_transform(center, 0.0, Vector2.ONE * hover_scale)
				canvas.draw_texture(itex, -half)
				canvas.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			else:
				canvas.draw_texture(itex, center - half)
