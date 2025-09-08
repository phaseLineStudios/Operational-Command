@tool
extends Resource
class_name UnitData

## Enumeration of unit sizes
enum unitSize { Team, Squad, Platoon, Company, Battalion }

## Unique identifier for the unit
@export var id: String
## Human-readable title of the unit
@export var title: String
## Unit icon texture
@export var icon: Texture2D = preload("res://assets/textures/units/nato_unknown_platoon.png")
## role for this unit
@export var role: String = "INF"
## Allowed slot codes where this unit can be deployed
@export var allowed_slots: Array[String] = ["INF"]
## Deployment cost in points
@export var cost: int = 50

@export_category("Meta")
## Organizational size of the unit
@export var size: unitSize = unitSize.Platoon
## Number of personnel in the unit at full strength
@export var strength: int = 36
## Dictionary of equipment definitions
@export var equipment: Dictionary
## Average experience level
@export var experience: float = 0.0

@export_category("Stats")
## Offensive rating of the unit
@export var attack: float = 25
## Defensive rating of the unit
@export var defense: float = 15
## Spotting range in meters
@export var spot_m: float = 800
## Effective weapon range in meters
@export var range_m: float = 500
## Morale level (0 = broken, 1 = max)
@export_range(0.0, 1.0, 0.05) var morale: float = 0.9
## Movement speed in kilometers per hour
@export var speed_kph: float = 50

@export_category("state")
## Current strength
@export var state_strength: float
## Current injured
@export var state_injured: float
## Current remaining equipment
@export var state_equipment: float
## Current cohesion level (0.0–1.0).
@export_range(0.0, 1.0, 0.01) var cohesion: float

@export_category("Supply")
## Supply throughput { "supply_type": (int)amount }
@export var throughput: Dictionary = {}
## Equipment tag codes associated with this unit [ "AMMO_PALLET" ]
@export var equipment_tags: Array[String]

@export_category("AI")
## Doctrine code used by the AI for this unit.
@export var doctrine: String = "nato_inf_1983"

## Serialzie this unit to JSON
func serialize() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"icon_path": (icon.resource_path as Variant if icon and icon.resource_path != "" else null as Variant),
		"role": role,
		"allowed_slots": allowed_slots.duplicate(),
		"cost": cost,

		"size": int(size),
		"strength": strength,
		"equipment": equipment.duplicate(),
		"experience": experience,

		"stats": {
			"attack": attack,
			"defense": defense,
			"spot_m": spot_m,
			"range_m": range_m,
			"morale": morale,
			"speed_kph": speed_kph
		},

		"state": {
			"state_strength": state_strength,
			"state_injured": state_injured,
			"state_equipment": state_equipment,
			"cohesion": cohesion
		},

		"throughput": throughput.duplicate(),
		"equipment_tags": equipment_tags.duplicate(),
		"doctrine": doctrine
	}

## Deserialize Unit JSON
static func deserialize(data: Variant) -> UnitData:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var u := UnitData.new()

	u.id = data.get("id", u.id)
	u.title = data.get("title", u.title)
	u.role = data.get("role", u.role)
	u.cost = int(data.get("cost", u.cost))
	var slots = data.get("allowed_slots", null)
	if typeof(slots) == TYPE_ARRAY:
		var tmp_slots: Array[String] = []
		for s in slots:
			tmp_slots.append(str(s))
		u.allowed_slots = tmp_slots

	var icon_path = data.get("icon_path", null)
	if icon_path != null and typeof(icon_path) == TYPE_STRING and icon_path != "":
		var tex := load(icon_path)
		if tex is Texture2D:
			u.icon = tex

	u.size = int(data.get("size", u.size)) as unitSize
	u.strength = int(data.get("strength", u.strength))
	u.equipment = data.get("equipment", u.equipment)
	u.experience = float(data.get("experience", u.experience))

	var stats: Dictionary = data.get("stats", {})
	if typeof(stats) == TYPE_DICTIONARY:
		u.attack = float(stats.get("attack", u.attack))
		u.defense = float(stats.get("defense", u.defense))
		u.spot_m = float(stats.get("spot_m", u.spot_m))
		u.range_m = float(stats.get("range_m", u.range_m))
		u.morale = float(stats.get("morale", u.morale))
		u.speed_kph = float(stats.get("speed_kph", u.speed_kph))

	var state: Dictionary = data.get("state", {})
	if typeof(state) == TYPE_DICTIONARY:
		u.state_strength = float(state.get("state_strength", u.state_strength))
		u.state_injured = float(state.get("state_injured", u.state_injured))
		u.state_equipment = float(state.get("state_equipment", u.state_equipment))
		u.cohesion = float(state.get("cohesion", u.cohesion))

	u.throughput = data.get("throughput", u.throughput)
	u.doctrine = data.get("doctrine", u.doctrine)
	var equipment_t = data.get("equipment_tags", null)
	if typeof(slots) == TYPE_ARRAY:
		var tmp_slots: Array[String] = []
		for e in equipment_t:
			tmp_slots.append(str(e))
		u.equipment_tags = tmp_slots

	return u
