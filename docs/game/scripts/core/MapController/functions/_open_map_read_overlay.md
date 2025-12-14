# MapController::_open_map_read_overlay Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 173–188)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _open_map_read_overlay() -> void
```

## Source

```gdscript
func _open_map_read_overlay() -> void:
	if terrain_viewport == null:
		return
	if _map_read_overlay != null and is_instance_valid(_map_read_overlay):
		return
	var inst := READ_OVERLAY_SCENE.instantiate() as ViewportReadOverlay
	if inst == null:
		return
	inst.consume_escape = true
	_map_read_overlay = inst
	_map_read_overlay.closed.connect(_on_map_read_overlay_closed, CONNECT_ONE_SHOT)
	get_tree().root.add_child(_map_read_overlay)
	_map_read_overlay.open_texture(terrain_viewport.get_texture(), "Map")
	_set_read_mode(true)
```
