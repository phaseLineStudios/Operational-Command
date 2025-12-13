# Settings::_save_config Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 309–332)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _save_config() -> void
```

## Description

Save config file.

## Source

```gdscript
func _save_config() -> void:
	_cfg.set_value("video", "mode", _mode.get_selected_id())
	_cfg.set_value("video", "res_index", _res.get_selected())
	_cfg.set_value("video", "vsync", _vsync.button_pressed)
	_cfg.set_value("video", "scale_pct", _scale.value)
	_cfg.set_value("video", "fps_cap", _fps.value)

	for bus_name in _bus_rows.keys():
		var row: Dictionary = _bus_rows[bus_name]
		_cfg.set_value("audio", "%s_vol" % bus_name, (row["slider"] as HSlider).value)
		_cfg.set_value("audio", "%s_mute" % bus_name, (row["mute"] as CheckBox).button_pressed)

	# Save audio device selections
	var output_idx := _output_device.get_selected()
	if output_idx >= 0:
		_cfg.set_value("audio", "output_device", _output_device.get_item_text(output_idx))

	var input_idx := _input_device.get_selected()
	if input_idx >= 0:
		_cfg.set_value("audio", "input_device", _input_device.get_item_text(input_idx))

	_cfg.save(CONFIG_PATH)
```
