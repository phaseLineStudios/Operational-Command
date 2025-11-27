# ScenarioEditorOverlay::_slot_pos_m Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 631–640)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _slot_pos_m(entry) -> Vector2
```

## Description

Extract slot world position from either dict or resource

## Source

```gdscript
func _slot_pos_m(entry) -> Vector2:
	if typeof(entry) == TYPE_DICTIONARY:
		return entry.get("position_m", Vector2.ZERO)
	if "start_position" in entry:
		return entry.start_position
	if "position_m" in entry:
		return entry.position_m
	return Vector2.ZERO
```
