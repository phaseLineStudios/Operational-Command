# Settings::_build_video_ui Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 62–74)</br>
*Belongs to:* [Settings](../Settings.md)

**Signature**

```gdscript
func _build_video_ui() -> void
```

## Description

Populate video controls.

## Source

```gdscript
func _build_video_ui() -> void:
	_mode.clear()
	_mode.add_item("Windowed", WindowMode.WINDOWED)
	_mode.add_item("Fullscreen", WindowMode.FULLSCREEN)

	_res.clear()
	for r in resolutions:
		_res.add_item("%dx%d" % [r.x, r.y])
	_res.select(0)

	_scale_val.text = "%d%%" % int(_scale.value)
```
