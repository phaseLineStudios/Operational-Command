# UnitAutoResponses::_get_grid_from_position Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 627–633)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _get_grid_from_position(pos_m: Vector2) -> String
```

- **pos_m**: Position in terrain meters.
- **Return Value**: Grid string (e.g., "A5").

## Description

Get grid coordinate from terrain position.

## Source

```gdscript
func _get_grid_from_position(pos_m: Vector2) -> String:
	if not _terrain_render:
		return "unknown"

	return _terrain_render.pos_to_grid(pos_m)
```
