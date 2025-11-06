# SymbolDrawingTool::_update_placement Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 131–135)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _update_placement(pos: Vector2) -> void
```

## Description

Update shape being placed

## Source

```gdscript
func _update_placement(pos: Vector2) -> void:
	if _current_shape:
		_current_shape.end = pos
```
