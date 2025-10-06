# ScenarioEditor::_open_trigger_config Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 252–257)</br>
*Belongs to:* [ScenarioEditor](../ScenarioEditor.md)

**Signature**

```gdscript
func _open_trigger_config(index: int) -> void
```

## Description

Open trigger configuration dialog for a trigger index

## Source

```gdscript
func _open_trigger_config(index: int) -> void:
	if index < 0 or index >= ctx.data.triggers.size():
		return
	_trigger_cfg.show_for(self, index)
```
