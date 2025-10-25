# MissionSelect::_prepare_card_for_float Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 299–307)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _prepare_card_for_float() -> void
```

## Description

Prepare the card position.

## Source

```gdscript
func _prepare_card_for_float() -> void:
	_card.set_anchors_preset(Control.PRESET_TOP_LEFT, false)
	_card.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	_card.grow_vertical = Control.GROW_DIRECTION_BEGIN
	_card.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	_card.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	_card.pivot_offset = Vector2.ZERO
```
