# CounterConfigDialog::_populate_sizes Function Reference

*Defined at:* `scripts/ui/CounterConfigDialog.gd` (lines 50–56)</br>
*Belongs to:* [CounterConfigDialog](../../CounterConfigDialog.md)

**Signature**

```gdscript
func _populate_sizes() -> void
```

## Source

```gdscript
func _populate_sizes() -> void:
	unit_size.clear()
	for size_label in MilSymbol.UnitSize.keys():
		unit_size.add_item(size_label)
	unit_size.selected = 3
```
