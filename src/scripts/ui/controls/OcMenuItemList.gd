class_name OCMenuItemList
extends ItemList

@export var hover_sounds: Array[AudioStream] = [
	preload("res://audio/ui/sfx_ui_button_hover_01.wav"),
	preload("res://audio/ui/sfx_ui_button_hover_02.wav")
]
@export var hover_disabled_sounds: Array[AudioStream] = []
@export var click_sounds: Array[AudioStream] = [
	preload("res://audio/ui/sfx_ui_button_click_01.wav"),
]
@export var click_disabled_sounds: Array[AudioStream] = []

var _last_hovered_item: int = -1


func _ready() -> void:
	item_clicked.connect(_on_item_clicked)
	mouse_exited.connect(_on_mouse_exited)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_handle_hover(event.position)


func _handle_hover(mouse_pos: Vector2) -> void:
	var item_index := get_item_at_position(mouse_pos, true)

	if item_index != _last_hovered_item:
		if item_index >= 0:
			_play_hover(item_index)
		_last_hovered_item = item_index


func _on_mouse_exited() -> void:
	_last_hovered_item = -1


func _on_item_clicked(_idx: int, _pos: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		_play_click(_idx)


func _play_hover(item_index: int) -> void:
	if not is_item_disabled(item_index):
		if hover_sounds.size() > 0:
			AudioManager.play_random_ui_sound(hover_sounds, Vector2(1.0, 1.0), Vector2(0.98, 1.02))
	else:
		if hover_disabled_sounds.size() > 0:
			AudioManager.play_random_ui_sound(
				hover_disabled_sounds, Vector2(1.0, 1.0), Vector2(0.98, 1.02)
			)


func _play_click(item_index: int) -> void:
	if not is_item_disabled(item_index):
		if click_sounds.size() > 0:
			AudioManager.play_random_ui_sound(click_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1))
	else:
		if click_disabled_sounds.size() > 0:
			AudioManager.play_random_ui_sound(
				click_disabled_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1)
			)
