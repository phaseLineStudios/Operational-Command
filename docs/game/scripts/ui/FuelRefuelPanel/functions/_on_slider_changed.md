# FuelRefuelPanel::_on_slider_changed Function Reference

*Defined at:* `scripts/ui/FuelRefuelPanel.gd` (lines 140–150)</br>
*Belongs to:* [FuelRefuelPanel](../../FuelRefuelPanel.md)

**Signature**

```gdscript
func _on_slider_changed(_v: float, uid: String) -> void
```

## Source

```gdscript
func _on_slider_changed(_v: float, uid: String) -> void:
	var sl: HSlider = _sliders[uid]
	var cur: float = float(sl.value)
	_value_labels[uid].text = "%.1f" % cur
	var remainder: float = _depot - _planned_total_except(uid)
	if remainder < 0.0:
		var trimmed: float = max(0.0, cur + remainder)
		sl.value = trimmed
		_value_labels[uid].text = "%.1f" % trimmed
```
