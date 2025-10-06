# Settings::_apply_ui_from_config Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 147–171)</br>
*Belongs to:* [Settings](../Settings.md)

**Signature**

```gdscript
func _apply_ui_from_config() -> void
```

## Description

Push saved values into UI.

## Source

```gdscript
func _apply_ui_from_config() -> void:
	# Video
	var video: Variant = _cfg.get_value("video", "mode", WindowMode.WINDOWED)
	_mode.select(int(video))
	var res_idx := int(_cfg.get_value("video", "res_index", 0))
	if res_idx >= 0 and res_idx < _res.item_count:
		_res.select(res_idx)
	_vsync.button_pressed = bool(_cfg.get_value("video", "vsync", true))
	_scale.value = float(_cfg.get_value("video", "scale_pct", 100))
	_scale_val.text = "%d%%" % int(_scale.value)
	_fps.value = float(_cfg.get_value("video", "fps_cap", 0))

	# Audio
	for audio_name in _bus_rows.keys():
		var row: Dictionary = _bus_rows[audio_name]
		var sli: HSlider = row["slider"]
		var mute: CheckBox = row["mute"]
		var vol := float(_cfg.get_value("audio", "%s_vol" % audio_name, 1.0))
		var m := bool(_cfg.get_value("audio", "%s_mute" % audio_name, false))
		sli.value = clampf(vol, 0.0, 1.0)
		mute.button_pressed = m
		_set_bus_volume(audio_name, sli.value)
		_set_bus_mute(audio_name, m)
```
