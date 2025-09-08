@tool
extends Node

enum unitSize { Team, Squad, Platoon, Company, Battalion }

@export var id: String
@export var title: String
@export var icon: Texture2D
@export var role: String = "INF"
@export var allowed_slots: Array[String] = ["INF"]
@export var cost: int = 50

@export_category("Meta")
@export var size: unitSize = unitSize.Platoon
@export var strength: int = 36
@export var equipment: Dictionary
@export var experience: float = 0.0

@export_category("Stats")
@export var attack: float = 25
@export var defense: float = 15
@export var spot_m: float = 800
@export var range_m: float = 500
@export_range(0.0, 1.0, 0.05) var morale: float = 0.9
@export var speed_kph: float = 50

@export_category("state")
@export var state_strength: float
@export var state_injured: float
@export var state_equipment: float
@export var cohesion: float

@export_category("Supply")
@export var throughput: Dictionary = {}
@export var equipment_tags: Array[String]

@export_category("AI")
@export var doctrine: String = "nato_inf_1983"

# Load default unit icon
func _init():
	var res := Image.new()
	var err := res.load("res://assets/textures/units/nato_unknown_platoon.png")
	if err:
		push_error("Default unit icon missing or moved")
		return
	icon = ImageTexture.create_from_image(res)
