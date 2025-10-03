extends Resource
class_name UnitBaseTask
## Base task definition.
##
## A UnitTask describes a configurable behavior (e.g. Move, Defend).
## Instances are placed via TaskInstance and can override properties.

## Unique type id
@export var type_id: StringName
## Display name
@export var display_name: String = "Task"
## Optional color used for overlay/links
@export var color: Color = Color.CYAN
## Task Icon
@export var icon: Texture2D


## Return list of exported properties for dynamic config UIs.
func get_configurable_props() -> Array[Dictionary]:
	var list: Array[Dictionary] = []
	for p in get_property_list():
		if (p.usage & PROPERTY_USAGE_EDITOR) == 0:
			continue
		var name := String(p.name)
		if (
			name
			in [
				"resource_local_to_scene",
				"resource_path",
				"type_id",
				"display_name",
				"color",
				"icon",
				"script",
				"resource_name"
			]
		):
			continue
		list.append(p)
	return list


## Default parameter dictionary from exported properties.
func make_default_params() -> Dictionary:
	var d := {}
	for p in get_configurable_props():
		var n := String(p.name)
		d[n] = get(n)
	return d


## Draw the task glyph
func draw_glyph(
	canvas: Control,
	center: Vector2,
	hovered: bool,
	hover_scale: float,
	px: int,
	inner_px: int,
	_inst,
	_to_map: Callable,
	scale_icon: Callable
) -> void:
	var r := px * 0.5
	var s := r * (hover_scale if hovered else 1.0)
	var pts := PackedVector2Array(
		[center + Vector2(0, -s), center + Vector2(s, 0), center + Vector2(0, s), center + Vector2(-s, 0)]
	)
	canvas.draw_polygon(pts, [color if hovered else Color(color, 0.5)])

	if icon:
		var key := "TASK:%s:%s:%d" % [String(type_id), String(resource_path), inner_px]
		var itex: Texture2D = scale_icon.call(icon, key, inner_px)
		if itex:
			var half := itex.get_size() * 0.5
			if hovered:
				canvas.draw_set_transform(center, 0.0, Vector2.ONE * hover_scale)
				canvas.draw_texture(itex, -half, Color.WHITE if hovered else Color(1, 1, 1, 0.5))
				canvas.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			else:
				canvas.draw_texture(itex, center - half)
