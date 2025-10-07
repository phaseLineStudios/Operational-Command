# SlotConfigDialog::show_for Function Reference

*Defined at:* `scripts/editors/SlotConfigDialog.gd` (lines 26–38)</br>
*Belongs to:* [SlotConfigDialog](../../SlotConfigDialog.md)

**Signature**

```gdscript
func show_for(_editor: ScenarioEditor, index: int) -> void
```

## Description

Show dialog for a specific slot entry index in editor.ctx.data.unit_slots

## Source

```gdscript
func show_for(_editor: ScenarioEditor, index: int) -> void:
	editor = _editor
	slot_index = index
	var s: UnitSlotData = editor.ctx.data.unit_slots[slot_index]
	_before = s.duplicate(true)

	key_input.text = String(s.key)
	title_input.text = s.title
	_roles = s.allowed_roles
	_refresh_role_list()
	visible = true
```
