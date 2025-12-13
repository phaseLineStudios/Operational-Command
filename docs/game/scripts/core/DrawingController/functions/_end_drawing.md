# DrawingController::_end_drawing Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 133–143)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func _end_drawing() -> void
```

## Source

```gdscript
func _end_drawing() -> void:
	if _is_drawing and not _current_stroke.is_empty():
		if _current_tool != Tool.ERASER:
			_strokes.append({"tool": _current_tool, "points": _current_stroke.duplicate()})

	_current_stroke.clear()
	_is_drawing = false
	_update_drawing_mesh()
	drawing_updated.emit()
```
