# FuelRefuelPanel::_planned_total_except Function Reference

*Defined at:* `scripts/ui/FuelRefuelPanel.gd` (lines 151–160)</br>
*Belongs to:* [FuelRefuelPanel](../../FuelRefuelPanel.md)

**Signature**

```gdscript
func _planned_total_except(skip_uid: String) -> float
```

## Source

```gdscript
func _planned_total_except(skip_uid: String) -> float:
	var sum: float = 0.0
	for key in _sliders.keys():
		var id: String = key as String
		if id == skip_uid:
			continue
		sum += float(_sliders[id].value)
	return sum
```
