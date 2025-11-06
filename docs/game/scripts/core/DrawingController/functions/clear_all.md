# DrawingController::clear_all Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 351–362)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func clear_all() -> void
```

## Description

Clear all drawings

## Source

```gdscript
func clear_all() -> void:
	_strokes.clear()
	_current_stroke.clear()
	_is_drawing = false

	# Clear scenario strokes
	_scenario_strokes.clear()

	_update_drawing_mesh()
	drawing_cleared.emit()
```
