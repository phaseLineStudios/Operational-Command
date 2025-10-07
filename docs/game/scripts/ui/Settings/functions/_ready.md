# Settings::_ready Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 50–60)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Build UI and load config.

## Source

```gdscript
func _ready() -> void:
	_build_video_ui()
	_build_audio_ui()
	_build_controls_ui()

	_load_config()
	_apply_ui_from_config()

	_connect_signals()
```
