# TerrainLineTool::build_hint_ui Function Reference

*Defined at:* `scripts/editors/tools/TerrainLineTool.gd` (lines 141–150)</br>
*Belongs to:* [TerrainLineTool](../../TerrainLineTool.md)

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
