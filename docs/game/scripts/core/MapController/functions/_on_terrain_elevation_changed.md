# MapController::_on_terrain_elevation_changed Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 375–378)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _on_terrain_elevation_changed(_rect: Rect2i) -> void
```

## Source

```gdscript
func _on_terrain_elevation_changed(_rect: Rect2i) -> void:
	_request_map_refresh(true)
```
