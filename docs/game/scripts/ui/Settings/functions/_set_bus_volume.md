# Settings::_set_bus_volume Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 334–340)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _set_bus_volume(bus_name: String, v: float) -> void
```

## Description

Set bus volume (linear 0..1).

## Source

```gdscript
func _set_bus_volume(bus_name: String, v: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		return
	AudioServer.set_bus_volume_db(idx, linear_to_db(clampf(v, 0.0, 1.0)))
```
