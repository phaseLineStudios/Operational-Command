# SubtitleEditor Class Reference

*File:* `scripts/ui/SubtitleEditor.gd`
*Class name:* `SubtitleEditor`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name SubtitleEditor
extends Control
```

## Public Member Functions

- [`func _ready() -> void`](SubtitleEditor/functions/_ready.md)
- [`func _process(_delta: float) -> void`](SubtitleEditor/functions/_process.md)
- [`func _setup_connections() -> void`](SubtitleEditor/functions/_setup_connections.md)
- [`func _setup_dialogs() -> void`](SubtitleEditor/functions/_setup_dialogs.md)
- [`func _new_track() -> void`](SubtitleEditor/functions/_new_track.md)
- [`func _update_time_display() -> void`](SubtitleEditor/functions/_update_time_display.md)
- [`func _update_seek_slider() -> void`](SubtitleEditor/functions/_update_seek_slider.md)
- [`func _update_subtitle_preview() -> void`](SubtitleEditor/functions/_update_subtitle_preview.md)
- [`func _format_time(seconds: float) -> String`](SubtitleEditor/functions/_format_time.md)
- [`func _refresh_subtitle_list() -> void`](SubtitleEditor/functions/_refresh_subtitle_list.md)
- [`func _clear_editor() -> void`](SubtitleEditor/functions/_clear_editor.md)
- [`func _update_ui_state() -> void`](SubtitleEditor/functions/_update_ui_state.md)
- [`func _on_play_pressed() -> void`](SubtitleEditor/functions/_on_play_pressed.md)
- [`func _on_seek_changed(value: float) -> void`](SubtitleEditor/functions/_on_seek_changed.md)
- [`func _on_add_pressed() -> void`](SubtitleEditor/functions/_on_add_pressed.md)
- [`func _on_update_pressed() -> void`](SubtitleEditor/functions/_on_update_pressed.md)
- [`func _on_delete_pressed() -> void`](SubtitleEditor/functions/_on_delete_pressed.md)
- [`func _on_set_start_pressed() -> void`](SubtitleEditor/functions/_on_set_start_pressed.md)
- [`func _on_set_end_pressed() -> void`](SubtitleEditor/functions/_on_set_end_pressed.md)
- [`func _on_subtitle_selected(index: int) -> void`](SubtitleEditor/functions/_on_subtitle_selected.md)
- [`func _on_list_empty_clicked(_at_position: Vector2, _mouse_button_index: int) -> void`](SubtitleEditor/functions/_on_list_empty_clicked.md)
- [`func _on_load_video_pressed() -> void`](SubtitleEditor/functions/_on_load_video_pressed.md)
- [`func _on_load_track_pressed() -> void`](SubtitleEditor/functions/_on_load_track_pressed.md)
- [`func _on_save_track_pressed() -> void`](SubtitleEditor/functions/_on_save_track_pressed.md)
- [`func _on_new_track_pressed() -> void`](SubtitleEditor/functions/_on_new_track_pressed.md)
- [`func _on_video_file_selected(path: String) -> void`](SubtitleEditor/functions/_on_video_file_selected.md)
- [`func _on_track_file_selected(path: String) -> void`](SubtitleEditor/functions/_on_track_file_selected.md)
- [`func _on_save_track_file_selected(path: String) -> void`](SubtitleEditor/functions/_on_save_track_file_selected.md)

## Public Attributes

- `SubtitleTrack _subtitle_track` — Subtitle editor for creating and editing SubtitleTrack resources
- `String _current_video_path`
- `int _selected_index`
- `VideoStreamPlayer video_player`
- `Button play_btn`
- `Label time_label`
- `HSlider seek_slider`
- `ItemList subtitle_list`
- `TextEdit subtitle_text`
- `SpinBox start_time_spin`
- `SpinBox end_time_spin`
- `Button add_btn`
- `Button update_btn`
- `Button delete_btn`
- `Button set_start_btn`
- `Button set_end_btn`
- `Button load_video_btn`
- `Button load_track_btn`
- `Button save_track_btn`
- `Button new_track_btn`
- `FileDialog video_dialog`
- `FileDialog load_track_dialog`
- `FileDialog save_track_dialog`
- `Label subtitle_preview`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _process

```gdscript
func _process(_delta: float) -> void
```

### _setup_connections

```gdscript
func _setup_connections() -> void
```

### _setup_dialogs

```gdscript
func _setup_dialogs() -> void
```

### _new_track

```gdscript
func _new_track() -> void
```

### _update_time_display

```gdscript
func _update_time_display() -> void
```

### _update_seek_slider

```gdscript
func _update_seek_slider() -> void
```

### _update_subtitle_preview

```gdscript
func _update_subtitle_preview() -> void
```

### _format_time

```gdscript
func _format_time(seconds: float) -> String
```

### _refresh_subtitle_list

```gdscript
func _refresh_subtitle_list() -> void
```

### _clear_editor

```gdscript
func _clear_editor() -> void
```

### _update_ui_state

```gdscript
func _update_ui_state() -> void
```

### _on_play_pressed

```gdscript
func _on_play_pressed() -> void
```

### _on_seek_changed

```gdscript
func _on_seek_changed(value: float) -> void
```

### _on_add_pressed

```gdscript
func _on_add_pressed() -> void
```

### _on_update_pressed

```gdscript
func _on_update_pressed() -> void
```

### _on_delete_pressed

```gdscript
func _on_delete_pressed() -> void
```

### _on_set_start_pressed

```gdscript
func _on_set_start_pressed() -> void
```

### _on_set_end_pressed

```gdscript
func _on_set_end_pressed() -> void
```

### _on_subtitle_selected

```gdscript
func _on_subtitle_selected(index: int) -> void
```

### _on_list_empty_clicked

```gdscript
func _on_list_empty_clicked(_at_position: Vector2, _mouse_button_index: int) -> void
```

### _on_load_video_pressed

```gdscript
func _on_load_video_pressed() -> void
```

### _on_load_track_pressed

```gdscript
func _on_load_track_pressed() -> void
```

### _on_save_track_pressed

```gdscript
func _on_save_track_pressed() -> void
```

### _on_new_track_pressed

```gdscript
func _on_new_track_pressed() -> void
```

### _on_video_file_selected

```gdscript
func _on_video_file_selected(path: String) -> void
```

### _on_track_file_selected

```gdscript
func _on_track_file_selected(path: String) -> void
```

### _on_save_track_file_selected

```gdscript
func _on_save_track_file_selected(path: String) -> void
```

## Member Data Documentation

### _subtitle_track

```gdscript
var _subtitle_track: SubtitleTrack
```

Subtitle editor for creating and editing SubtitleTrack resources

### _current_video_path

```gdscript
var _current_video_path: String
```

### _selected_index

```gdscript
var _selected_index: int
```

### video_player

```gdscript
var video_player: VideoStreamPlayer
```

### play_btn

```gdscript
var play_btn: Button
```

### time_label

```gdscript
var time_label: Label
```

### seek_slider

```gdscript
var seek_slider: HSlider
```

### subtitle_list

```gdscript
var subtitle_list: ItemList
```

### subtitle_text

```gdscript
var subtitle_text: TextEdit
```

### start_time_spin

```gdscript
var start_time_spin: SpinBox
```

### end_time_spin

```gdscript
var end_time_spin: SpinBox
```

### add_btn

```gdscript
var add_btn: Button
```

### update_btn

```gdscript
var update_btn: Button
```

### delete_btn

```gdscript
var delete_btn: Button
```

### set_start_btn

```gdscript
var set_start_btn: Button
```

### set_end_btn

```gdscript
var set_end_btn: Button
```

### load_video_btn

```gdscript
var load_video_btn: Button
```

### load_track_btn

```gdscript
var load_track_btn: Button
```

### save_track_btn

```gdscript
var save_track_btn: Button
```

### new_track_btn

```gdscript
var new_track_btn: Button
```

### video_dialog

```gdscript
var video_dialog: FileDialog
```

### load_track_dialog

```gdscript
var load_track_dialog: FileDialog
```

### save_track_dialog

```gdscript
var save_track_dialog: FileDialog
```

### subtitle_preview

```gdscript
var subtitle_preview: Label
```
