# ScenarioTriggerTool::build_hint_ui Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTriggerTool.gd` (lines 21–27)</br>
*Belongs to:* [ScenarioTriggerTool](../../ScenarioTriggerTool.md)

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
```
