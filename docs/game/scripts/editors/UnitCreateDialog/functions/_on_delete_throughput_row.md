# UnitCreateDialog::_on_delete_throughput_row Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 492–496)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _on_delete_throughput_row(key: String, row: HBoxContainer) -> void
```

## Description

Delete throughput from list.

## Source

```gdscript
func _on_delete_throughput_row(key: String, row: HBoxContainer) -> void:
	_thru.erase(key)
	row.queue_free()
```
