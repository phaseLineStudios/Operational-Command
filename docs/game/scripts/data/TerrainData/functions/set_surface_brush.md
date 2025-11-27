# TerrainData::set_surface_brush Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 212–219)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func set_surface_brush(id: int, brush: Resource) -> void
```

## Description

Update surface brush or metadata by id.

## Source

```gdscript
func set_surface_brush(id: int, brush: Resource) -> void:
	var i := _find_by_id(surfaces, id)
	if i < 0:
		return
	surfaces[i].brush = brush
	_queue_emit(_pend_surfaces, "brush", PackedInt32Array([id]), "surfaces_changed")
```
