# UnitSelect::_on_filter_changed Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 151–159)</br>
*Belongs to:* [UnitSelect](../UnitSelect.md)

**Signature**

```gdscript
func _on_filter_changed(button: Button) -> void
```

## Description

Handle filter button toggled

## Source

```gdscript
func _on_filter_changed(button: Button) -> void:
	for b in [
		_filter_all, _filter_armor, _filter_inf, _filter_mech, _filter_motor, _filter_support
	]:
		if b != button:
			b.set_pressed_no_signal(false)
	_refresh_pool_filter()
```
