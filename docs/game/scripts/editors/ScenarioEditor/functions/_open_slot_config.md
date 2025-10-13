# ScenarioEditor::_open_slot_config Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 230–235)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _open_slot_config(index: int) -> void
```

## Description

Open slot configuration dialog for a slot index

## Source

```gdscript
func _open_slot_config(index: int) -> void:
	if not ctx.data or not ctx.data.unit_slots:
		return
	_slot_cfg.show_for(self, index)
```
