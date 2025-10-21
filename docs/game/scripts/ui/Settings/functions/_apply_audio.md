# Settings::_apply_audio Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 239–245)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _apply_audio() -> void
```

## Description

Apply audio to buses.

## Source

```gdscript
func _apply_audio() -> void:
	for bus_name in _bus_rows.keys():
		var row: Dictionary = _bus_rows[bus_name]
		_set_bus_volume(bus_name, (row["slider"] as HSlider).value)
		_set_bus_mute(bus_name, (row["mute"] as CheckBox).button_pressed)
```
