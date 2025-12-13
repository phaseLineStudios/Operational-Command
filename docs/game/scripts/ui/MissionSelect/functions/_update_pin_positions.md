# MissionSelect::_update_pin_positions Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 157–189)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _update_pin_positions() -> void
```

## Description

Reposition pins with letterbox awareness.

## Source

```gdscript
func _update_pin_positions() -> void:
	var tex := _map_rect.texture
	if tex == null:
		return
	var tex_size: Vector2 = tex.get_size()
	if tex_size == Vector2.ZERO:
		return

	var rect_size: Vector2 = _map_rect.size
	var pin_scale: float = min(rect_size.x / tex_size.x, rect_size.y / tex_size.y)
	var drawn_size: Vector2 = tex_size * pin_scale
	var offset: Vector2 = (rect_size - drawn_size) * 0.5

	_pin_centers_by_id.clear()

	for node in _pins_layer.get_children():
		if not (node is Control) or not node.has_meta("pos_norm"):
			continue

		var p: Vector2 = node.get_meta("pos_norm", Vector2.ZERO)
		var center: Vector2 = offset + Vector2(p.x * drawn_size.x, p.y * drawn_size.y)
		var px: Vector2 = center - Vector2(pin_size.x, pin_size.y * 1.6) * 0.5
		var ctrl := node as Control
		ctrl.position = px

		if node.has_meta("scenario_id"):
			var mission_id: String = node.get_meta("scenario_id", "")
			if typeof(mission_id) == TYPE_STRING and mission_id != "":
				_pin_centers_by_id[mission_id] = center

	_pins_layer.queue_redraw()
```
