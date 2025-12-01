class_name MissionVideo
extends Control

## Path to unit select scene
const SCENE_BRIEFING := "res://scenes/briefing.tscn"

## Duration to hold space to skip (seconds)
const HOLD_TO_SKIP_DURATION := 1.0

## Duration of mouse inactivity before hiding UI (seconds)
const MOUSE_HIDE_DELAY := 2.0

var _hide_timer := 0.0  ## Timer for hiding UI elements
var _space_hold_time := 0.0  ## Tracks if space is being held
var _last_mouse_pos := Vector2.ZERO  ## Last mouse position to detect movement
var _ui_hidden := false  ## Whether UI is currently hidden
var _subtitle_track: SubtitleTrack = null  ## Loaded subtitle track
var _video_started := false  ## Tracks if video has actually started playing

@onready var player: VideoStreamPlayer = %Player
@onready var subtitles_lbl: Label = %Subtitles
@onready var hold_progress: ProgressBar = %HoldProgress
@onready var hold_label: Label = %HoldLabel


func _ready() -> void:
	player.stream = Game.current_scenario.video
	player.play()
	player.finished.connect(_on_skip_pressed)

	# Load subtitle track if available
	_load_subtitles()

	hold_progress.min_value = 0.0
	hold_progress.max_value = HOLD_TO_SKIP_DURATION
	hold_progress.value = 0.0
	hold_progress.visible = false

	_last_mouse_pos = get_viewport().get_mouse_position()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process(delta: float) -> void:
	_handle_space_hold(delta)
	_handle_mouse_hide(delta)
	_update_subtitles()


func _handle_space_hold(delta: float) -> void:
	if Input.is_action_pressed("ptt"):
		_space_hold_time += delta
		hold_progress.value = _space_hold_time
		hold_progress.visible = true

		if _space_hold_time >= HOLD_TO_SKIP_DURATION:
			_on_skip_pressed()
	else:
		_space_hold_time = 0.0
		hold_progress.value = 0.0
		hold_progress.visible = false


func _handle_mouse_hide(delta: float) -> void:
	if not get_viewport():
		return
	var current_mouse_pos := get_viewport().get_mouse_position()

	if current_mouse_pos != _last_mouse_pos:
		_last_mouse_pos = current_mouse_pos
		_hide_timer = 0.0
		_show_ui()
	else:
		_hide_timer += delta
		if _hide_timer >= MOUSE_HIDE_DELAY and not _ui_hidden:
			_hide_ui()


func _show_ui() -> void:
	if _ui_hidden:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		hold_label.visible = true
		_ui_hidden = false


func _hide_ui() -> void:
	if not _ui_hidden:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		hold_label.visible = false
		if _space_hold_time == 0.0:
			hold_progress.visible = false
		_ui_hidden = true


func _on_skip_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Game.goto_scene(SCENE_BRIEFING)


func _load_subtitles() -> void:
	if Game.current_scenario.video_subtitles:
		_subtitle_track = Game.current_scenario.video_subtitles


func _update_subtitles() -> void:
	if _subtitle_track == null:
		subtitles_lbl.text = ""
		return

	# Wait for video to actually start before syncing subtitles
	if not _video_started:
		if player.is_playing() and player.stream_position > 0.0:
			_video_started = true
		else:
			subtitles_lbl.text = ""
			return

	if not player.is_playing():
		subtitles_lbl.text = ""
		return

	var current_time := player.stream_position
	var subtitle_text := _subtitle_track.get_subtitle_at_time(current_time)
	subtitles_lbl.text = subtitle_text
