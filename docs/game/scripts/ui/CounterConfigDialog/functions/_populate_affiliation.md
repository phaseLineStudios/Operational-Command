# CounterConfigDialog::_populate_affiliation Function Reference

*Defined at:* `scripts/ui/CounterConfigDialog.gd` (lines 36–42)</br>
*Belongs to:* [CounterConfigDialog](../../CounterConfigDialog.md)

**Signature**

```gdscript
func _populate_affiliation() -> void
```

## Source

```gdscript
func _populate_affiliation() -> void:
	affiliation.clear()
	for aff in MilSymbol.UnitAffiliation.keys():
		affiliation.add_item(aff)
	affiliation.selected = 0  # Default to FRIEND
```
