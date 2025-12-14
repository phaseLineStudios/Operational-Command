# MapController::_on_terrain_changed Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 482–485)</br>
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
	_request_map_refresh(true)
```
