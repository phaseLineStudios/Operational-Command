extends Control
## Brief1g controller
##
## Shows a whiteboard with pinned docs/photos; click to open a zoomable viewer.

## Types of briefing items.
enum ItemType { IMAGE, TEXT, OPORD, SKETCH }

## Whiteboard Texture
@export var default_whiteboard: Texture2D

@onready var _btn_back: Button      = $"Root/BottomBar/Row/Back"
@onready var _btn_next: Button      = $"Root/BottomBar/Row/Continue"
@onready var _title: Label          = $"Root/BottomBar/Row/Title"

@onready var _whiteboard: TextureRect = $"Root/Board/Whiteboard"

const SCENE_MISSION_SELECT = "res://scenes/mission_select.tscn"
const SCENE_UNIT_SELECT = "res://scenes/unit_select.tscn"

## Default thumb size.
const DEFAULT_THUMB_SIZE := Vector2i(128, 96) 

var _brief: BriefData
var _items: Array = []

## Init: load data, build board, wire UI.
func _ready() -> void:
	_btn_back.pressed.connect(func(): Game.goto_scene(SCENE_MISSION_SELECT))
	_btn_next.pressed.connect(func(): Game.goto_scene(SCENE_UNIT_SELECT))

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
	var tex: Texture2D = _brief.board_texture
	_whiteboard.texture = tex
	
# TODO Create logic to display briefing items
# TODO Create logic to inspect briefing items
