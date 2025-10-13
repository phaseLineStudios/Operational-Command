# MissionSelect::_update_pin_positions Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 187–210)</br>
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

	for node in _pins_layer.get_children():
		if not (node is Control) or not node.has_meta("pos_norm"):
			continue
		var p: Vector2 = node.get_meta("pos_norm", Vector2.ZERO)
		var px := offset + Vector2(p.x * drawn_size.x, p.y * drawn_size.y) - Vector2(pin_size) * 0.5
		(node as Control).position = px

	if _card.visible and is_instance_valid(_card_pin_button):
		_position_card_near_pin(_card_pin_button)
```
