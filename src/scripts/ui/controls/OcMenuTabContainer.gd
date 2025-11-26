class_name OCMenuTabContainer
extends TabContainer

@export var hover_sound: AudioStream = preload("res://audio/ui/sfx_button_hover.wav")
@export var hover_disabled_sound: AudioStream
@export var click_sound: AudioStream = preload("res://audio/ui/sfx_button_click.wav")
@export var click_disabled_sound: AudioStream

var _last_hovered_tab: int = -1
var _tab_bar: TabBar


func _ready() -> void:
	# Get the internal TabBar
	_tab_bar = get_tab_bar()
	if _tab_bar:
		_tab_bar.gui_input.connect(_on_tab_bar_input)
		_tab_bar.mouse_exited.connect(_on_tab_bar_mouse_exited)

	# Listen for tab changes
	tab_changed.connect(_on_tab_changed)


func _on_tab_bar_input(event: InputEvent) -> void:
	if not _tab_bar:
		return

	if event is InputEventMouseMotion:
		_handle_hover(event.position)


func _handle_hover(mouse_pos: Vector2) -> void:
	if not _tab_bar:
		return

	# Find which tab is under the mouse
	var tab_index := -1
	var tab_count := get_tab_count()

	for i in range(tab_count):
		var tab_rect := _tab_bar.get_tab_rect(i)
		if tab_rect.has_point(mouse_pos):
			tab_index = i
			break

	# Only play sound if we've moved to a different tab
	if tab_index != _last_hovered_tab:
		if tab_index >= 0:
			_play_hover(tab_index)
		_last_hovered_tab = tab_index


func _on_tab_bar_mouse_exited() -> void:
	_last_hovered_tab = -1


func _on_tab_changed(tab_index: int) -> void:
	_play_click(tab_index)


func _play_hover(tab_index: int) -> void:
	if not is_tab_disabled(tab_index):
		if hover_sound:
			AudioManager.play_ui_sound(hover_sound)
	else:
		if hover_disabled_sound:
			AudioManager.play_ui_sound(hover_disabled_sound)


func _play_click(tab_index: int) -> void:
	if not is_tab_disabled(tab_index):
		if click_sound:
			AudioManager.play_ui_sound(click_sound)
	else:
		if click_disabled_sound:
			AudioManager.play_ui_sound(click_disabled_sound)
