# UnitSelect::_on_reset_pressed Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 386–391)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _on_reset_pressed() -> void
```

## Description

Reset all slots to empty

## Source

```gdscript
func _on_reset_pressed() -> void:
	var to_clear := _slot_data.keys()
	for sid in to_clear:
		_unassign_slot(sid)
```
