# MissionSelect::_point_over_any_pin Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 189–195)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _point_over_any_pin(view_pt: Vector2) -> bool
```

## Description

True if the viewport point lies over any mission pin.

## Source

```gdscript
func _point_over_any_pin(view_pt: Vector2) -> bool:
	for node in _pins_layer.get_children():
		if node is Control and (node as Control).get_global_rect().has_point(view_pt):
			return true
	return false
```
