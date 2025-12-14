# MapController::_on_map_read_overlay_closed Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 189–193)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _on_map_read_overlay_closed() -> void
```

## Source

```gdscript
func _on_map_read_overlay_closed() -> void:
	_map_read_overlay = null
	_set_read_mode(false)
```
