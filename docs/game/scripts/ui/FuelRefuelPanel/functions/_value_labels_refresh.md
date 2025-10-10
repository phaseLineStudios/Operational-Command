# FuelRefuelPanel::_value_labels_refresh Function Reference

*Defined at:* `scripts/ui/FuelRefuelPanel.gd` (lines 161–166)</br>
*Belongs to:* [FuelRefuelPanel](../../FuelRefuelPanel.md)

**Signature**

```gdscript
func _value_labels_refresh() -> void
```

## Source

```gdscript
func _value_labels_refresh() -> void:
	for key in _value_labels.keys():
		var id: String = key as String
		_value_labels[id].text = "%.1f" % float(_sliders[id].value)
```
