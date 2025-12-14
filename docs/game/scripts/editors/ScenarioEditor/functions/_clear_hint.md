# ScenarioEditor::_clear_hint Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 311–315)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _clear_hint() -> void
```

## Description

Remove all hint widgets from the hint bar

## Source

```gdscript
func _clear_hint() -> void:
	for n in tool_hint.get_children():
		n.queue_free()
```
