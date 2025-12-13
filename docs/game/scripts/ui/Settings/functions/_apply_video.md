# Settings::_apply_video Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 269–294)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _apply_video() -> void
```

## Description

Apply video settings to the window/engine.

## Source

```gdscript
func _apply_video() -> void:
	var mode := _mode.get_selected_id()
	match mode:
		WindowMode.FULLSCREEN:
			get_window().mode = Window.MODE_FULLSCREEN
		_:
			get_window().mode = Window.MODE_WINDOWED
	var use_vsync := _vsync.button_pressed
	# Godot 4 vsync key may vary across templates; try both.
	if ProjectSettings.has_setting("display/window/vsync/vsync_mode"):
		ProjectSettings.set_setting("display/window/vsync/vsync_mode", 1 if use_vsync else 0)
	else:
		ProjectSettings.set_setting("display/window/vsync/use_vsync", use_vsync)
	ProjectSettings.save()

	var idx := _res.get_selected()
	if idx >= 0 and idx < resolutions.size():
		var res_size := resolutions[idx]
		if get_window().mode == Window.MODE_WINDOWED:
			get_window().size = res_size

	Engine.max_fps = int(_fps.value)
	# Store render scale only; actual scaling strategy can be implemented later.
	# (Keeps groundwork without forcing a scaling mode right now.)
```
