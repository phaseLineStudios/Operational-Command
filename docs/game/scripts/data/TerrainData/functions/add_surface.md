# TerrainData::add_surface Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 207–213)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func add_surface(s: Dictionary) -> int
```

## Description

Add a new surface. Returns the assigned id.

## Source

```gdscript
func add_surface(s: Dictionary) -> int:
	var id := _ensure_id_on_item(s, "_next_surface_id")
	surfaces.append(s)
	_queue_emit(_pend_surfaces, "added", PackedInt32Array([id]), "surfaces_changed")
	return id
```
