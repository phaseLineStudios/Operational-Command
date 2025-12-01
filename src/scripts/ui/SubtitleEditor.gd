class_name SubtitleEditor
extends Control

## Subtitle editor for creating and editing SubtitleTrack resources

var _subtitle_track: SubtitleTrack = null
var _current_video_path: String = ""
var _selected_index: int = -1
var _is_playing := false
var _seeking := false

@onready var video_player: VideoStreamPlayer = %VideoPlayer
@onready var play_btn: Button = %PlayButton
@onready var time_label: Label = %TimeLabel
@onready var seek_slider: HSlider = %SeekSlider
@onready var subtitle_list: ItemList = %SubtitleList
@onready var subtitle_text: TextEdit = %SubtitleText
@onready var start_time_spin: SpinBox = %StartTimeSpin
@onready var end_time_spin: SpinBox = %EndTimeSpin
@onready var add_btn: Button = %AddButton
@onready var update_btn: Button = %UpdateButton
@onready var delete_btn: Button = %DeleteButton
@onready var set_start_btn: Button = %SetStartButton
@onready var set_end_btn: Button = %SetEndButton
@onready var load_video_btn: Button = %LoadVideoButton
@onready var load_track_btn: Button = %LoadTrackButton
@onready var save_track_btn: Button = %SaveTrackButton
@onready var new_track_btn: Button = %NewTrackButton
@onready var video_dialog: FileDialog = %VideoDialog
@onready var load_track_dialog: FileDialog = %LoadTrackDialog
@onready var save_track_dialog: FileDialog = %SaveTrackDialog
@onready var subtitle_preview: Label = %SubtitlePreview


func _ready() -> void:
	_setup_connections()
	_setup_dialogs()
	_new_track()
	_update_ui_state()


func _process(_delta: float) -> void:
	if video_player.stream and not _seeking:
		_update_time_display()
		_update_seek_slider()
		_update_subtitle_preview()


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


func _setup_dialogs() -> void:
	video_dialog.access = FileDialog.ACCESS_FILESYSTEM
	video_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	video_dialog.filters = ["*.ogv ; OGG Video"]

	load_track_dialog.access = FileDialog.ACCESS_FILESYSTEM
	load_track_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	load_track_dialog.filters = ["*.tres ; Subtitle Track Resource"]

	save_track_dialog.access = FileDialog.ACCESS_FILESYSTEM
	save_track_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	save_track_dialog.filters = ["*.tres ; Subtitle Track Resource"]


func _new_track() -> void:
	_subtitle_track = SubtitleTrack.new()
	_refresh_subtitle_list()
	_clear_editor()


func _update_time_display() -> void:
	if not video_player.stream:
		time_label.text = "00:00.000 / 00:00.000"
		return

	var current := video_player.stream_position
	var duration := video_player.get_stream_length()
	time_label.text = "%s / %s" % [_format_time(current), _format_time(duration)]


func _update_seek_slider() -> void:
	if not video_player.stream:
		seek_slider.max_value = 0.0
		seek_slider.value = 0.0
		return

	seek_slider.max_value = video_player.get_stream_length()
	seek_slider.value = video_player.stream_position


func _update_subtitle_preview() -> void:
	if not _subtitle_track or not video_player.is_playing():
		subtitle_preview.text = ""
		return

	var current_time := video_player.stream_position
	subtitle_preview.text = _subtitle_track.get_subtitle_at_time(current_time)


func _format_time(seconds: float) -> String:
	var mins := int(seconds) / 60
	var secs := int(seconds) % 60
	var millis := int((seconds - int(seconds)) * 1000)
	return "%02d:%02d.%03d" % [mins, secs, millis]


func _refresh_subtitle_list() -> void:
	subtitle_list.clear()
	if not _subtitle_track:
		return

	var subs := _subtitle_track.get_all_subtitles()
	for i in range(subs.size()):
		var sub: Subtitle = subs[i]
		var display := (
			"[%s - %s] %s"
			% [_format_time(sub.start_time), _format_time(sub.end_time), sub.text.substr(0, 50)]
		)
		subtitle_list.add_item(display)


func _clear_editor() -> void:
	subtitle_text.text = ""
	start_time_spin.value = 0.0
	end_time_spin.value = 0.0
	_selected_index = -1
	_update_ui_state()


func _update_ui_state() -> void:
	var has_selection := _selected_index >= 0
	update_btn.disabled = not has_selection
	delete_btn.disabled = not has_selection


func _on_play_pressed() -> void:
	if not video_player.stream:
		return

	if _is_playing:
		video_player.paused = true
		play_btn.text = "Play"
		_is_playing = false
	else:
		video_player.paused = false
		if not video_player.is_playing():
			video_player.play()
		play_btn.text = "Pause"
		_is_playing = true


func _on_seek_changed(value: float) -> void:
	if video_player.stream and _seeking:
		video_player.stream_position = value


func _on_add_pressed() -> void:
	if not _subtitle_track:
		return

	var start := start_time_spin.value
	var end := end_time_spin.value
	var text := subtitle_text.text

	if text.is_empty():
		push_warning("Subtitle text cannot be empty")
		return

	if end <= start:
		push_warning("End time must be greater than start time")
		return

	_subtitle_track.add_subtitle(start, end, text)
	_refresh_subtitle_list()
	_clear_editor()


func _on_update_pressed() -> void:
	if not _subtitle_track or _selected_index < 0:
		return

	var subs := _subtitle_track.subtitles
	if _selected_index >= subs.size():
		return

	var start := start_time_spin.value
	var end := end_time_spin.value
	var text := subtitle_text.text

	if text.is_empty():
		push_warning("Subtitle text cannot be empty")
		return

	if end <= start:
		push_warning("End time must be greater than start time")
		return

	var sub: Subtitle = subs[_selected_index]
	sub.start_time = start
	sub.end_time = end
	sub.text = text

	_refresh_subtitle_list()
	_clear_editor()


func _on_delete_pressed() -> void:
	if not _subtitle_track or _selected_index < 0:
		return

	var subs := _subtitle_track.subtitles
	if _selected_index >= subs.size():
		return

	subs.remove_at(_selected_index)
	_refresh_subtitle_list()
	_clear_editor()


func _on_set_start_pressed() -> void:
	if video_player.stream:
		start_time_spin.value = video_player.stream_position


func _on_set_end_pressed() -> void:
	if video_player.stream:
		end_time_spin.value = video_player.stream_position


func _on_subtitle_selected(index: int) -> void:
	if not _subtitle_track:
		return

	var subs := _subtitle_track.subtitles
	if index >= subs.size():
		return

	_selected_index = index
	var sub: Subtitle = subs[index]

	subtitle_text.text = sub.text
	start_time_spin.value = sub.start_time
	end_time_spin.value = sub.end_time

	_update_ui_state()


func _on_list_empty_clicked(_at_position: Vector2, _mouse_button_index: int) -> void:
	_clear_editor()


func _on_load_video_pressed() -> void:
	video_dialog.popup_centered()


func _on_load_track_pressed() -> void:
	load_track_dialog.popup_centered()


func _on_save_track_pressed() -> void:
	if not _subtitle_track:
		return
	save_track_dialog.popup_centered()


func _on_new_track_pressed() -> void:
	_new_track()


func _on_video_file_selected(path: String) -> void:
	var video_stream := load(path)
	if video_stream is VideoStream:
		video_player.stream = video_stream
		_current_video_path = path
		video_player.play()
		_is_playing = true
		play_btn.text = "Pause"
	else:
		push_error("Failed to load video: %s" % path)


func _on_track_file_selected(path: String) -> void:
	var resource := load(path)
	if resource is SubtitleTrack:
		_subtitle_track = resource
		_refresh_subtitle_list()
		_clear_editor()
	else:
		push_error("Failed to load subtitle track: %s" % path)


func _on_save_track_file_selected(path: String) -> void:
	if not _subtitle_track:
		return

	var err := ResourceSaver.save(_subtitle_track, path)
	if err == OK:
		print("Subtitle track saved to: %s" % path)
	else:
		push_error("Failed to save subtitle track: %s" % path)
