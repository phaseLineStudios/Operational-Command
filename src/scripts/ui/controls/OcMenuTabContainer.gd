class_name OCMenuTabContainer
extends TabContainer

@export var hover_sounds: Array[AudioStream] = [
	preload("res://audio/ui/sfx_ui_button_hover_01.wav"),
	preload("res://audio/ui/sfx_ui_button_hover_02.wav")
]
@export var hover_disabled_sounds: Array[AudioStream] = []
@export var click_sounds: Array[AudioStream] = [
	preload("res://audio/ui/sfx_ui_button_click_01.wav"),
]
@export var click_disabled_sounds: Array[AudioStream] = []

var _last_hovered_tab: int = -1
var _tab_bar: TabBar


func _ready() -> void:
	_tab_bar = get_tab_bar()
	if _tab_bar:
		_tab_bar.gui_input.connect(_on_tab_bar_input)
		_tab_bar.mouse_exited.connect(_on_tab_bar_mouse_exited)

	tab_changed.connect(_on_tab_changed)


func _on_tab_bar_input(event: InputEvent) -> void:
	if not _tab_bar:
		return

	if event is InputEventMouseMotion:
		_handle_hover(event.position)


func _handle_hover(mouse_pos: Vector2) -> void:
	if not _tab_bar:
		return

	var tab_index := -1
	var tab_count := get_tab_count()

	for i in range(tab_count):
		var tab_rect := _tab_bar.get_tab_rect(i)
		if tab_rect.has_point(mouse_pos):
			tab_index = i
			break

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
		if hover_sounds.size() > 0:
			AudioManager.play_random_ui_sound(hover_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1))
	else:
		if hover_disabled_sounds.size() > 0:
			AudioManager.play_random_ui_sound(
				hover_disabled_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1)
			)


func _play_click(tab_index: int) -> void:
	if not is_tab_disabled(tab_index):
		if click_sounds.size() > 0:
			AudioManager.play_random_ui_sound(click_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1))
	else:
		if click_disabled_sounds.size() > 0:
			AudioManager.play_random_ui_sound(
				click_disabled_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1)
			)
