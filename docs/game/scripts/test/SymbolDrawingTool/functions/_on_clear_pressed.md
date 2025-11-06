# SymbolDrawingTool::_on_clear_pressed Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 294–302)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _on_clear_pressed() -> void
```

## Description

Clear all shapes

## Source

```gdscript
func _on_clear_pressed() -> void:
	_shapes.clear()
	_current_shape = null
	_selected_shape = null
	_is_placing = false
	canvas.queue_redraw()
	code_output.text = ""
```
