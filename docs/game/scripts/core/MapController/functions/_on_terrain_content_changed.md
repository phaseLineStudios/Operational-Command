# MapController::_on_terrain_content_changed Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 379–382)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _on_terrain_content_changed(_kind: String, _ids: PackedInt32Array) -> void
```

## Source

```gdscript
func _on_terrain_content_changed(_kind: String, _ids: PackedInt32Array) -> void:
	_request_map_refresh(true)
```
