# SurfaceLayer::_find_surface_by_id Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 558–566)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _find_surface_by_id(id: int) -> Variant
```

## Description

Finds a surface dictionary in TerrainData by id

## Source

```gdscript
func _find_surface_by_id(id: int) -> Variant:
	if data == null:
		return null
	for s in data.surfaces:
		if s is Dictionary and int(s.get("id", 0)) == id:
			return s
	return null
```
