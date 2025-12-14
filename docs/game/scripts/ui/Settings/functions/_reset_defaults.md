# Settings::_reset_defaults Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 244–260)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _reset_defaults() -> void
```

## Description

Reset to defaults.

## Source

```gdscript
func _reset_defaults() -> void:
	# Video defaults
	_mode.select(WindowMode.WINDOWED)
	_res.select(0)
	_vsync.button_pressed = true
	_scale.value = 100.0
	_fps.value = 0
	# Audio defaults
	for bus_name in _bus_rows.keys():
		var row: Dictionary = _bus_rows[bus_name]
		(row["slider"] as HSlider).value = 1.0
		(row["mute"] as CheckBox).button_pressed = false
		_set_bus_volume(bus_name, 1.0)
		_set_bus_mute(bus_name, false)
	_apply_and_save()
```
