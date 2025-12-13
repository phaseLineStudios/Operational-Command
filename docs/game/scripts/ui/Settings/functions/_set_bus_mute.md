# Settings::_set_bus_mute Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 342–348)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _set_bus_mute(bus_name: String, on: bool) -> void
```

## Description

Mute/unmute bus.

## Source

```gdscript
func _set_bus_mute(bus_name: String, on: bool) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		return
	AudioServer.set_bus_mute(idx, on)
```
