# SimWorld::get_unit_snapshots Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 394–400)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func get_unit_snapshots() -> Array[Dictionary]
```

- **Return Value**: Array of snapshot dictionaries.

## Description

Snapshots of all units.

## Source

```gdscript
func get_unit_snapshots() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	for su in _friendlies + _enemies:
		out.append(_snapshot_unit(su))
	return out
```
