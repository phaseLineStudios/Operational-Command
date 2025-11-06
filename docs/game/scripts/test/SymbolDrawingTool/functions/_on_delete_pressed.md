# SymbolDrawingTool::_on_delete_pressed Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 304–310)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _on_delete_pressed() -> void
```

## Description

Delete selected shape

## Source

```gdscript
func _on_delete_pressed() -> void:
	if _selected_shape:
		_shapes.erase(_selected_shape)
		_selected_shape = null
		canvas.queue_redraw()
```
