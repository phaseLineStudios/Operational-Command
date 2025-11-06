# UnitCreateDialog::_add_slot_row Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 424–445)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _add_slot_row(s: String) -> void
```

## Description

Append new slot row to list.

## Source

```gdscript
func _add_slot_row(s: String) -> void:
	var row := HBoxContainer.new()
	row.custom_minimum_size.y = 26
	row.set_meta("slot", s)

	var lbl := Label.new()
	lbl.text = s
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var del := Button.new()
	del.text = "Delete"
	del.pressed.connect(
		func():
			_slots.erase(row.get_meta("slot"))
			row.queue_free()
	)

	row.add_child(lbl)
	row.add_child(del)
	_slots_list.add_child(row)
```
