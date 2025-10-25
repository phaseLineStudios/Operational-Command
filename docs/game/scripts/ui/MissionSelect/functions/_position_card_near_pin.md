# MissionSelect::_position_card_near_pin Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 272–297)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _position_card_near_pin(pin_btn: BaseButton) -> void
```

## Description

Place the card near a pin and keep it on-screen.

## Source

```gdscript
func _position_card_near_pin(pin_btn: BaseButton) -> void:
	_card.set_anchors_preset(Control.PRESET_TOP_LEFT, false)

	var pin_center_global := pin_btn.global_position + pin_btn.size * 0.5
	var container_inv := _container.get_global_transform_with_canvas().affine_inverse()
	var anchor: Vector2 = container_inv * pin_center_global

	var gap := 12.0
	var card_size := _card.size
	if card_size == Vector2.ZERO:
		card_size = _card.get_combined_minimum_size()
	var bg_size := _container.size

	var pos := anchor + Vector2(gap, gap)

	if pos.x + card_size.x > bg_size.x:
		pos.x = anchor.x - gap - card_size.x
	if pos.y + card_size.y > bg_size.y:
		pos.y = anchor.y - gap - card_size.y

	pos.x = clampf(pos.x, 0.0, max(0.0, bg_size.x - card_size.x))
	pos.y = clampf(pos.y, 0.0, max(0.0, bg_size.y - card_size.y))

	_card.position = pos
```
