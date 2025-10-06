# UnitSelect::_refresh_filters Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 203–208)</br>
*Belongs to:* [UnitSelect](../UnitSelect.md)

**Signature**

```gdscript
func _refresh_filters() -> void
```

## Description

Reset all role filter buttons

## Source

```gdscript
func _refresh_filters() -> void:
	_filter_all.set_pressed_no_signal(true)
	for b in [_filter_armor, _filter_inf, _filter_mech, _filter_motor, _filter_support]:
		b.set_pressed_no_signal(false)
```
