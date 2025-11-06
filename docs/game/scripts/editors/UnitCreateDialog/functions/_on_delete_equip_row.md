# UnitCreateDialog::_on_delete_equip_row Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 467–475)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _on_delete_equip_row(key: String, row: HBoxContainer) -> void
```

## Description

Delete equipment from list

## Source

```gdscript
func _on_delete_equip_row(key: String, row: HBoxContainer) -> void:
	var cat := String(row.get_meta("cat", ""))
	if cat != "" and _equip.has(cat):
		_equip[cat].erase(key)
	else:
		_equip.erase(key)
	row.queue_free()
```
