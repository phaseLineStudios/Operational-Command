# UnitCreateDialog::_on_add_slot Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 442–452)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _on_add_slot() -> void
```

## Description

Add slot to list.

## Source

```gdscript
func _on_add_slot() -> void:
	var s := _slot_input.text.strip_edges().to_upper()
	if s == "":
		return
	if s in _slots:
		return
	_slots.append(s)
	_add_slot_row(s)
	_slot_input.clear()
```
