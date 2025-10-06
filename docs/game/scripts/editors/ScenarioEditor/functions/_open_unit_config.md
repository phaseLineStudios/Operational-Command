# ScenarioEditor::_open_unit_config Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 237–242)</br>
*Belongs to:* [ScenarioEditor](../ScenarioEditor.md)

**Signature**

```gdscript
func _open_unit_config(index: int) -> void
```

## Description

Open unit configuration dialog for a unit index

## Source

```gdscript
func _open_unit_config(index: int) -> void:
	if not ctx.data or not ctx.data.units:
		return
	_unit_cfg.show_for(self, index)
```
