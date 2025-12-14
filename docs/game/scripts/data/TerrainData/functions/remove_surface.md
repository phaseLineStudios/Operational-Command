# TerrainData::remove_surface Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 233–240)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func remove_surface(id: int) -> void
```

## Description

Remove surface by id.

## Source

```gdscript
func remove_surface(id: int) -> void:
	var i := _find_by_id(surfaces, id)
	if i < 0:
		return
	surfaces.remove_at(i)
	_queue_emit(_pend_surfaces, "removed", PackedInt32Array([id]), "surfaces_changed")
```
