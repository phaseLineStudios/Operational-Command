# TerrainToolBase::on_mouse_inside Function Reference

*Defined at:* `scripts/editors/tools/TerrainToolBase.gd` (lines 65–70)</br>
*Belongs to:* [TerrainToolBase](../../TerrainToolBase.md)

**Signature**

```gdscript
func on_mouse_inside(inside: bool) -> void
```

## Description

Editor tells the tool the mouse entered/exited the viewport

## Source

```gdscript
func on_mouse_inside(inside: bool) -> void:
	_inside = inside
	if is_instance_valid(_preview):
		_preview.visible = inside
```
