# SymbolDrawingTool::_end_placement Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 137–149)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _end_placement() -> void
```

## Description

End shape placement

## Source

```gdscript
func _end_placement() -> void:
	if _is_placing and _current_shape:
		# Only add if shape has some size
		var bounds := _current_shape.get_bounds()
		if bounds.size.length() > 5.0:
			_shapes.append(_current_shape)
		_current_shape = null
		canvas.queue_redraw()

	_is_placing = false
	_is_dragging = false
```
