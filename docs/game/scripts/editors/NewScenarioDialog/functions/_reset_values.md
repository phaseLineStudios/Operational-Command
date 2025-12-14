# NewScenarioDialog::_reset_values Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 217–234)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _reset_values() -> void
```

## Description

Reset values before popup (only when hiding)

## Source

```gdscript
func _reset_values() -> void:
	title_input.text = ""
	desc_input.text = ""
	terrain_path.text = ""
	thumb_path.text = ""
	thumb_preview.texture = null
	video_path.text = ""
	subtitles_path.text = "No Subtitles Selected"
	thumbnail = null
	terrain = null
	video_stream = null
	subtitle_track = null
	working = null
	dialog_mode = DialogMode.CREATE
	_title_button_from_mode()
	_reset_pool_values()
```
