# SimWorld::get_unit_debug_path Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 317–323)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func get_unit_debug_path(uid: String) -> PackedVector2Array
```

## Description

Planned path for a unit (for debug).
[param uid] Unit id.
[return] PackedVector2Array of path points (meters).

## Source

```gdscript
func get_unit_debug_path(uid: String) -> PackedVector2Array:
	var su: ScenarioUnit = _units_by_id.get(uid)
	if su == null:
		return []
	return su.move_path
```
