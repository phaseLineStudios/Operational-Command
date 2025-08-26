extends Control

@onready var back: Button = %Back
@onready var select_units: Button = %SelectUnits

const SCENE_MISSION_SELECT = "res://scenes/mission_select.tscn"

const SCENE_UNIT_SELECT = "res://scenes/unit_select.tscn"

func _ready():
	back.connect("pressed", _on_back_pressed)
	select_units.connect("pressed", _on_select_units_pressed)

func _on_back_pressed():
	Game.goto_scene(SCENE_MISSION_SELECT)
	
func _on_select_units_pressed():
	Game.goto_scene(SCENE_UNIT_SELECT)
