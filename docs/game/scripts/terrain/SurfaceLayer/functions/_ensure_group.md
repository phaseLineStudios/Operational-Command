# SurfaceLayer::_ensure_group Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 311–325)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _ensure_group(key: String, brush: TerrainBrush) -> void
```

## Description

Ensures a group record exists for the given brush key

## Source

```gdscript
func _ensure_group(key: String, brush: TerrainBrush) -> void:
	if _groups.has(key):
		return
	var rec := brush.get_draw_recipe()
	_groups[key] = {
		"brush": brush,
		"z": int(brush.z_index),
		"rec": rec,
		"polys": {},
		"bboxes": {},
		"merged": [],
		"dirty": true
	}
```
