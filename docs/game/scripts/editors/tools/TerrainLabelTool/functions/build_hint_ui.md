# TerrainLabelTool::build_hint_ui Function Reference

*Defined at:* `scripts/editors/tools/TerrainLabelTool.gd` (lines 98–107)</br>
*Belongs to:* [TerrainLabelTool](../../TerrainLabelTool.md)

**Signature**

```gdscript
func build_hint_ui(parent: Control) -> void
```

## Source

```gdscript
func build_hint_ui(parent: Control) -> void:
	parent.add_child(_label("LMB - Place"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("Drag - Move"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("Backspace - Delete hovered"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("Esc - Cancel Drag"))
```
