@tool
class_name UnitData
extends Resource

## Enumeration of unit sizes
enum UnitSize { TEAM, SQUAD, PLATOON, COMPANY, BATTALION }

## Unique identifier for the unit
@export var id: String
## Human-readable title of the unit
@export var title: String
## Unit icon texture
@export var icon: Texture2D = preload("res://assets/textures/units/nato_unknown_platoon.png")
## Enemy unit icon texture
@export var enemy_icon: Texture2D = preload("res://assets/textures/units/enemy_unknown_platoon.png")
## role for this unit
@export var role: String = "INF"
## Allowed slot codes where this unit can be deployed
@export var allowed_slots: Array[String] = ["INF"]
## Deployment cost in points
@export var cost: int = 50
## Movement Profile for navigation
@export var movement_profile: TerrainBrush.MoveProfile = TerrainBrush.MoveProfile.FOOT

@export_category("Meta")
## Organizational size of the unit
@export var size: UnitSize = UnitSize.PLATOON
## Number of personnel in the unit at full strength
@export var strength: int = 36
## Dictionary of equipment definitions
@export var equipment: Dictionary = {}
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
@export var equipment_tags: Array[String] = []

@export_category("AI")
## Doctrine code used by the AI for this unit.
@export var doctrine: String = "nato_inf_1983"

@export_category("Editor meta")
@export var unit_category: UnitCategoryData

## Ammunition variables
@export_category("Ammunition")
## Ammo capacity per type, e.g. `{ "small_arms": 30, "he": 10 }`.
@export var ammunition: Dictionary = {}  # {type: cap}
## Current ammo per type for this unit, same keys as `ammunition`.
@export var state_ammunition: Dictionary = {}  # {type: current}
## Ratio (0..1): when `current/capacity <= ammunition_low_threshold` emit “Bingo ammo”.
@export_range(0.0, 1.0, 0.01) var ammunition_low_threshold: float = 0.25
## Ratio (0..1): when `current/capacity <= ammunition_critical_threshold` emit “Ammo critical”.
@export_range(0.0, 1.0, 0.01) var ammunition_critical_threshold: float = 0.1

## Logistics variables, is part of ammunition and we can add stuff here later, like fuel
@export_category("Logistics")
## Transfer rate (rounds per second) a logistics unit can push to a recipient in range.
@export var supply_transfer_rate: float = 10.0
## Transfer radius in meters within which resupply is possible.
@export var supply_transfer_radius_m: float = 30.0


## Serialize this unit to JSON
func serialize() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"icon_path":
		icon.resource_path as Variant if icon and icon.resource_path != "" else null as Variant,
		"enemy_icon_path":
		enemy_icon.resource_path as Variant if enemy_icon and enemy_icon.resource_path != "" \
			else null as Variant,
		"role": role,
		"allowed_slots": allowed_slots.duplicate(),
		"cost": cost,
		"size": int(size),
		"strength": strength,
		"equipment": equipment.duplicate(),
		"experience": experience,
		"stats":
		{
			"attack": attack,
			"defense": defense,
			"spot_m": spot_m,
			"range_m": range_m,
			"morale": morale,
			"speed_kph": speed_kph
		},
		"state":
		{
			"state_strength": state_strength,
			"state_injured": state_injured,
			"state_equipment": state_equipment,
			"cohesion": cohesion
		},
		"editor": {"unit_category": unit_category.id},
		"throughput": throughput.duplicate(),
		"equipment_tags": equipment_tags.duplicate(),
		"movement_profile": int(movement_profile),
		"doctrine": doctrine,
		# --- Ammo + Logistics persistence ---
		"ammunition": ammunition.duplicate(),
		"state_ammunition": state_ammunition.duplicate(),
		"ammunition_low_threshold": ammunition_low_threshold,
		"ammunition_critical_threshold": ammunition_critical_threshold,
		"supply_transfer_rate": supply_transfer_rate,
		"supply_transfer_radius_m": supply_transfer_radius_m,
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
			
	var enemy_icon_path = data.get("enemy_icon_path", null)
	if enemy_icon_path != null and typeof(enemy_icon_path) == TYPE_STRING and enemy_icon_path != "":
		var tex := load(enemy_icon_path)
		if tex is Texture2D:
			u.enemy_icon = tex

	u.size = int(data.get("size", u.size)) as UnitSize
	u.movement_profile = \
		int(data.get("movement_profile", u.movement_profile)) as TerrainBrush.MoveProfile
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

	var editor: Dictionary = data.get("editor", {})
	if typeof(editor) == TYPE_DICTIONARY:
		u.unit_category = ContentDB.get_unit_category(editor.get("unit_category", u.unit_category))

	u.throughput = data.get("throughput", u.throughput)
	u.doctrine = data.get("doctrine", u.doctrine)
	var equipment_t = data.get("equipment_tags", null)
	if typeof(equipment_t) == TYPE_ARRAY:
		var tmp_tags: Array[String] = []
		for e in equipment_t:
			tmp_tags.append(str(e))
		u.equipment_tags = tmp_tags

	# --- Ammo + Logistics fields ---
	var am_caps = data.get("ammunition", null)
	if typeof(am_caps) == TYPE_DICTIONARY:
		u.ammunition = am_caps

	var am_state = data.get("state_ammunition", null)
	if typeof(am_state) == TYPE_DICTIONARY:
		u.state_ammunition = am_state

	u.ammunition_low_threshold = float(
		data.get("ammunition_low_threshold", u.ammunition_low_threshold)
	)
	u.ammunition_critical_threshold = float(
		data.get("ammunition_critical_threshold", u.ammunition_critical_threshold)
	)
	u.supply_transfer_rate = float(data.get("supply_transfer_rate", u.supply_transfer_rate))
	u.supply_transfer_radius_m = float(
		data.get("supply_transfer_radius_m", u.supply_transfer_radius_m)
	)

	# Backfill ammo state if missing (for older saves)
	if u.state_ammunition.is_empty() and not u.ammunition.is_empty():
		for k in u.ammunition.keys():
			u.state_ammunition[k] = int(u.ammunition[k])

	return u
