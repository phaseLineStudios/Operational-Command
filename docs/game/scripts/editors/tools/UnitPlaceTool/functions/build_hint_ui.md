# UnitPlaceTool::build_hint_ui Function Reference

*Defined at:* `scripts/editors/tools/ScenarioUnitTool.gd` (lines 42–50)</br>
*Belongs to:* [UnitPlaceTool](../UnitPlaceTool.md)

**Signature**

```gdscript
func build_hint_ui(parent: Control) -> void
```

## Source

```gdscript
func build_hint_ui(parent: Control) -> void:
	_clear(parent)
	parent.add_child(_label("LMB - Place"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("RMB/ESC - Cancel"))
	parent.add_child(VSeparator.new())
	parent.add_child(_label("Shift - Grid Snap"))
```
