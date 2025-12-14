# Settings::_on_output_device_changed Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 144–148)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _on_output_device_changed(index: int) -> void
```

## Description

Called when output device is changed.

## Source

```gdscript
func _on_output_device_changed(index: int) -> void:
	var device_name := _output_device.get_item_text(index)
	AudioServer.set_output_device(device_name)
```
