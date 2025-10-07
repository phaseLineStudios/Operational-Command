# PathGrid::_bind_terrain_signals Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 102–110)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _bind_terrain_signals() -> void
```

## Source

```gdscript
func _bind_terrain_signals() -> void:
	if data == null:
		return
	data.changed.connect(func(): _terrain_epoch += 1)
	data.elevation_changed.connect(func(_r: Rect2i): _elev_epoch += 1)
	data.surfaces_changed.connect(func(_k: String, _ids: PackedInt32Array): _surfaces_epoch += 1)
	data.lines_changed.connect(func(_k: String, _ids: PackedInt32Array): _lines_epoch += 1)
```
