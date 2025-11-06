# SymbolDrawingTool::_on_corner_radius_changed Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 84–88)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _on_corner_radius_changed(value: float) -> void
```

## Description

Handle corner radius slider

## Source

```gdscript
func _on_corner_radius_changed(value: float) -> void:
	_current_corner_radius = value
	corner_label.text = "Corner Radius: %.1f" % value
```
