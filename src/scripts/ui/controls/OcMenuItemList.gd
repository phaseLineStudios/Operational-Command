class_name OCMenuItemList
extends ItemList

@export var hover_sound: AudioStream = preload("res://audio/ui/sfx_button_hover.wav")
@export var hover_disabled_sound: AudioStream
@export var click_sound: AudioStream = preload("res://audio/ui/sfx_button_click.wav")
@export var click_disabled_sound: AudioStream

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
		if hover_sound:
			AudioManager.play_ui_sound(hover_sound)
	else:
		if hover_disabled_sound:
			AudioManager.play_ui_sound(hover_disabled_sound)


func _play_click(item_index: int) -> void:
	if not is_item_disabled(item_index):
		if click_sound:
			AudioManager.play_ui_sound(click_sound)
	else:
		if click_disabled_sound:
			AudioManager.play_ui_sound(click_disabled_sound)
