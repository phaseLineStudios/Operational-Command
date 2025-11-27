# Settings::_build_audio_ui Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 76–107)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _build_audio_ui() -> void
```

## Description

Create rows for each audio bus.

## Source

```gdscript
func _build_audio_ui() -> void:
	for audio_name in audio_buses:
		var idx := AudioServer.get_bus_index(audio_name)
		if idx == -1:
			continue
		var lab := Label.new()
		lab.text = audio_name
		var sli := HSlider.new()
		sli.min_value = 0.0
		sli.max_value = 1.0
		sli.step = 0.01
		sli.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		sli.tick_count = 20
		sli.ticks_on_borders = true
		var val := Label.new()
		val.text = "0%"
		var mute := CheckBox.new()
		mute.text = "Mute"
		_buses_list.add_child(lab)
		_buses_list.add_child(sli)
		_buses_list.add_child(val)
		_buses_list.add_child(mute)
		_bus_rows[audio_name] = {"slider": sli, "label": val, "mute": mute}
		# Live preview
		sli.value_changed.connect(
			func(v: float):
				val.text = "%d%%" % int(round(v * 100.0))
				_set_bus_volume(audio_name, v)
		)
		mute.toggled.connect(func(on: bool): _set_bus_mute(audio_name, on))
```
