class_name NotificationBanner
extends PanelContainer
## Notification banner for the scenario editor.
##
## Displays temporary notifications at the top of the viewport with different
## styles for success, failure, and general messages.

## Notification type
enum NotificationType { SUCCESS, FAILURE, NORMAL }

## Colors for different notification types
const COLOR_SUCCESS := Color(0.2, 0.6, 0.2, 0.75)
const COLOR_FAILURE := Color(0.8, 0.2, 0.2, 0.75)
const COLOR_NORMAL := Color(0.3, 0.3, 0.3, 0.75)

## Sound for success notification
const SOUND_SUCCESS := preload("res://audio/ui/sfx_ui_save.wav")
const SOUND_NORMAL := SOUND_SUCCESS
const SOUND_FAILURE := preload("res://audio/ui/sfx_ui_error.wav")

var _panel_style: StyleBoxFlat

@onready var _label: Label = $Label
@onready var _timer: Timer = $Timer
@onready var _audio: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	_timer.timeout.connect(_on_timer_timeout)

	var theme_style := get_theme_stylebox("panel")
	if theme_style and theme_style is StyleBoxFlat:
		_panel_style = (theme_style as StyleBoxFlat).duplicate()
		add_theme_stylebox_override("panel", _panel_style)
	else:
		_panel_style = StyleBoxFlat.new()
		_panel_style.bg_color = COLOR_NORMAL
		_panel_style.content_margin_left = 3.0
		_panel_style.content_margin_top = 3.0
		_panel_style.content_margin_right = 3.0
		_panel_style.content_margin_bottom = 3.0
		add_theme_stylebox_override("panel", _panel_style)


## Show a success notification with green background.
## [param text] Notification text to display.
## [param timeout] Duration in seconds before auto-hiding (default 2).
## [param sound] Whether to play success sound (default true).
func success_notification(text: String, timeout: int = 2, sound: bool = true) -> void:
	_show_notification(text, timeout, NotificationType.SUCCESS, sound)


## Show a failure notification with red background.
## [param text] Notification text to display.
## [param timeout] Duration in seconds before auto-hiding (default 2).
## [param sound] Whether to play failure sound (default true).
func failed_notification(text: String, timeout: int = 2, sound: bool = true) -> void:
	_show_notification(text, timeout, NotificationType.FAILURE, sound)


## Show a normal notification with gray background.
## [param text] Notification text to display.
## [param timeout] Duration in seconds before auto-hiding (default 2).
## [param sound] Whether to play notification sound (default true).
func generic_notification(text: String, timeout: int = 2, sound: bool = true) -> void:
	_show_notification(text, timeout, NotificationType.NORMAL, sound)


## Internal method to show notification with specified type.
func _show_notification(
	text: String, timeout: int, type: NotificationType, play_sound: bool
) -> void:
	_label.text = text

	match type:
		NotificationType.SUCCESS:
			_panel_style.bg_color = COLOR_SUCCESS
		NotificationType.FAILURE:
			_panel_style.bg_color = COLOR_FAILURE
		NotificationType.NORMAL:
			_panel_style.bg_color = COLOR_NORMAL

	if play_sound:
		match type:
			NotificationType.SUCCESS:
				_audio.stream = SOUND_SUCCESS
				_audio.play()
			NotificationType.FAILURE:
				_audio.stream = SOUND_FAILURE
				_audio.pitch_scale = 0.8
				_audio.play()
			NotificationType.NORMAL:
				_audio.stream = SOUND_NORMAL
				_audio.pitch_scale = 1.0
				_audio.play()

	visible = true
	if timeout > 0:
		_timer.start(timeout)


## Hide notification (called by timer or manually).
func hide_notification() -> void:
	visible = false
	_timer.stop()


## Handle timer timeout.
func _on_timer_timeout() -> void:
	hide_notification()
