# DrawingController::_start_drawing Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 126–132)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func _start_drawing() -> void
```

## Source

```gdscript
func _start_drawing() -> void:
	_is_drawing = true
	_current_stroke.clear()
	_last_point = Vector3.ZERO
	drawing_started.emit()
```
