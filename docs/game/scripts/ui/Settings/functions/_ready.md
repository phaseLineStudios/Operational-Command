# Settings::_ready Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 57–68)</br>
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
	_base_msaa_3d = get_tree().root.msaa_3d if get_tree() and get_tree().root else -1
	_build_video_ui()
	_build_audio_ui()
	_build_controls_ui()

	_load_config()
	_apply_ui_from_config()

	_connect_signals()
```
