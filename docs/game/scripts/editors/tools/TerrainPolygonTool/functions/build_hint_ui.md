# TerrainPolygonTool::build_hint_ui Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 77–86)</br>
*Belongs to:* [TerrainPolygonTool](../../TerrainPolygonTool.md)

**Signature**

```gdscript
func build_hint_ui(parent: Control) -> void
```

## Source

```gdscript
func build_hint_ui(parent: Control) -> void:
	parent.add_child(_label("LMB - New point"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("Backspace - Delete Point"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("ESC - Cancel"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("Enter - Save"))
```
