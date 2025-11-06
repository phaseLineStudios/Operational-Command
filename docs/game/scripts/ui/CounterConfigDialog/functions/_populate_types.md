# CounterConfigDialog::_populate_types Function Reference

*Defined at:* `scripts/ui/CounterConfigDialog.gd` (lines 43–49)</br>
*Belongs to:* [CounterConfigDialog](../../CounterConfigDialog.md)

**Signature**

```gdscript
func _populate_types() -> void
```

## Source

```gdscript
func _populate_types() -> void:
	type.clear()
	for unit_type in MilSymbol.UnitType.keys():
		type.add_item(unit_type)
	type.selected = 0  # Default to INFANTRY
```
