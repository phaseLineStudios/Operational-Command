extends Control
## Briefing controller
##
## Shows a whiteboard with pinned docs/photos; click to open a zoomable viewer.

## Types of briefing items.
enum ItemType { IMAGE, TEXT, OPORD, SKETCH }

const SCENE_MISSION_SELECT = "res://scenes/mission_select.tscn"
const SCENE_UNIT_SELECT = "res://scenes/unit_select.tscn"

## Default thumb size.
const DEFAULT_THUMB_SIZE := Vector2i(128, 96)

## Whiteboard Texture
@export var default_whiteboard: Texture2D

var _brief: BriefData
var _items: Array = []

@onready var _btn_back: Button = %Back
@onready var _btn_next: Button = %Continue
@onready var _title: Label = %Title
@onready var _whiteboard: TextureRect = %Whiteboard


## Init: load data, build board, wire UI.
func _ready() -> void:
	_btn_back.pressed.connect(_on_back_pressed)
	_btn_next.pressed.connect(func(): Game.goto_scene(SCENE_UNIT_SELECT))

	# Update back button text based on play mode
	if Game.play_mode == Game.PlayMode.SOLO_PLAY_TEST:
		_btn_back.text = "Back to Editor"

	_load_brief()
	_build_board()


## Load the new-structure brief (your schema).
func _load_brief() -> void:
	_brief = Game.current_scenario.briefing
	if not _brief:
		return
	_title.text = String(_brief.title)
	_items = _brief.board_items


## Put the whiteboard background.
func _build_board() -> void:
	if not _brief:
		return
	if _brief.board_texture != null:
		var tex: Texture2D = _brief.board_texture
		_whiteboard.texture = tex


## Handle back button press
func _on_back_pressed() -> void:
	if Game.play_mode == Game.PlayMode.SOLO_PLAY_TEST:
		Game.end_playtest()
	else:
		Game.goto_scene(SCENE_MISSION_SELECT)


# TODO Create logic to display briefing items
# TODO Create logic to inspect briefing items
