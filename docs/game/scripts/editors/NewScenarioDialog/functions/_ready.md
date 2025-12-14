# NewScenarioDialog::_ready Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 61–78)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _ready()
```

## Source

```gdscript
func _ready():
	create_btn.pressed.connect(_on_primary_pressed)
	close_btn.pressed.connect(func(): show_dialog(false))
	close_requested.connect(func(): show_dialog(false))
	terrain_btn.pressed.connect(_on_terrain_select)
	thumb_btn.pressed.connect(_on_thumbnail_select)
	thumb_clear.pressed.connect(_on_thumbnail_clear)
	video_btn.pressed.connect(_on_video_select)
	video_clear.pressed.connect(_on_video_clear)
	subtitles_btn.pressed.connect(_on_subtitles_select)
	subtitles_clear.pressed.connect(_on_subtitles_clear)

	unit_add.pressed.connect(_on_unit_add_pressed)
	unit_remove.pressed.connect(_on_unit_remove_pressed)
	_load_units_pool()
	_refresh_unit_lists()
```
