# Settings::_populate_audio_devices Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 117–142)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _populate_audio_devices() -> void
```

## Description

Populate audio device dropdowns.

## Source

```gdscript
func _populate_audio_devices() -> void:
	# Output devices (speakers)
	_output_device.clear()
	var output_devices := AudioServer.get_output_device_list()
	var current_output := AudioServer.get_output_device()
	for i in range(output_devices.size()):
		var device_name: String = output_devices[i]
		_output_device.add_item(device_name)
		if device_name == current_output:
			_output_device.select(i)

	# Input devices (microphones)
	_input_device.clear()
	var input_devices := AudioServer.get_input_device_list()
	var current_input := AudioServer.get_input_device()
	for i in range(input_devices.size()):
		var device_name: String = input_devices[i]
		_input_device.add_item(device_name)
		if device_name == current_input:
			_input_device.select(i)

	# Connect change signals
	_output_device.item_selected.connect(_on_output_device_changed)
	_input_device.item_selected.connect(_on_input_device_changed)
```
