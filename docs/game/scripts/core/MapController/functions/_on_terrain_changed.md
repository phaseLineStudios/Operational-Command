# MapController::_on_terrain_changed Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 210–216)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _on_terrain_changed() -> void
```

## Description

Terrain data changed callback: update mipmaps when terrain changes

## Source

```gdscript
func _on_terrain_changed() -> void:
	# Use call_deferred to batch multiple changes
	if not is_inside_tree():
		return
	call_deferred("_update_mipmap_texture")
```
