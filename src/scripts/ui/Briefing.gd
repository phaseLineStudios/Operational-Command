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

var _mission_id: StringName
var _brief: Dictionary = {}
var _items: Array = []

## Init: load data, build board, wire UI.
func _ready() -> void:
	_btn_back.pressed.connect(func(): Game.goto_scene(SCENE_MISSION_SELECT))
	_btn_next.pressed.connect(func(): Game.goto_scene(SCENE_UNIT_SELECT))

	_mission_id = Game.current_mission_id
	_load_brief()
	_build_board()

## Load the new-structure brief (your schema).
func _load_brief() -> void:
	# Prefer a separate brief record, fallback to mission blob if you store inline.
	_brief = ContentDB.get_briefing(_mission_id)
	if _brief.is_empty():
		_brief = ContentDB.get_mission(_mission_id)
	# Title shown in the top bar.
	_title.text = String(_brief.get("title", "Briefing"))
	# Normalize board + items.
	var board: Dictionary = _brief.get("board", {}) as Dictionary
	_items = board.get("items", []) as Array

## Put the whiteboard background.
func _build_board() -> void:
	var bg_path: String = String((_brief.get("board", {}) as Dictionary).get("background", ""))
	var tex: Texture2D = (load(bg_path) as Texture2D) if bg_path != "" else default_whiteboard
	_whiteboard.texture = tex
	
# TODO Create logic to display briefing items
# TODO Create logic to inspect briefing items
