# TerrainCamera::_ready Function Reference

*Defined at:* `scripts/editors/TerrainCamera.gd` (lines 17–23)</br>
*Belongs to:* [TerrainCamera](../TerrainCamera.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	# Avoid anything that might fight direct positioning
	position_smoothing_enabled = false
	set_drag_horizontal_enabled(false)
	set_drag_vertical_enabled(false)
```
