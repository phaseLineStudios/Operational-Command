# SubtitleEditor::_setup_connections Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 49–73)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _setup_connections() -> void
```

## Source

```gdscript
func _setup_connections() -> void:
	play_btn.pressed.connect(_on_play_pressed)
	seek_slider.value_changed.connect(_on_seek_changed)
	seek_slider.drag_started.connect(func() -> void: _seeking = true)
	seek_slider.drag_ended.connect(func(_value_changed: bool) -> void: _seeking = false)

	add_btn.pressed.connect(_on_add_pressed)
	update_btn.pressed.connect(_on_update_pressed)
	delete_btn.pressed.connect(_on_delete_pressed)
	set_start_btn.pressed.connect(_on_set_start_pressed)
	set_end_btn.pressed.connect(_on_set_end_pressed)

	subtitle_list.item_selected.connect(_on_subtitle_selected)
	subtitle_list.empty_clicked.connect(_on_list_empty_clicked)

	load_video_btn.pressed.connect(_on_load_video_pressed)
	load_track_btn.pressed.connect(_on_load_track_pressed)
	save_track_btn.pressed.connect(_on_save_track_pressed)
	new_track_btn.pressed.connect(_on_new_track_pressed)

	video_dialog.file_selected.connect(_on_video_file_selected)
	load_track_dialog.file_selected.connect(_on_track_file_selected)
	save_track_dialog.file_selected.connect(_on_save_track_file_selected)
```
