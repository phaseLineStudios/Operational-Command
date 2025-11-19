@tool
class_name UnitData
extends Resource

## Emitted when icons were (re)generated successfully.
signal icons_ready

## Equipment categories
enum EquipCategory { VEHICLES, WEAPONS, RADIOS }

## Weapon Equipment Ammunition types
enum AmmoTypes {
	## Handheld weapons (5.56, 7.62, 9mm etc.)
	SMALL_ARMS,
	## Heavy crew-served or non-manportable weapons (.50)
	HEAVY_WEAPONS,
	## 20-40mm (IFVs, AAA Guns)
	AUTOCANNON,
	## 90-125mm MBT main gun ammo
	TANK_GUN,
	## HEAT weapons (M72, RPG-7, etc.)
	AT_ROCKET,
	## Guided Anti-Tank Missiles (TOW, MILAN, Konkurs, etc.)
	ATGM,
	## 60/81/120 mm mortar (Anti-Personnel)
	MORTAR_AP,
	## 60/81/120 mm mortar (Smoke)
	MORTAR_SMOKE,
	## 60/81/120 mm mortar (Flare)
	MORTAR_ILLUM,
	## 105/122/152/155 mm tube artillery (Anti-Personnel)
	ARTILLERY_AP,
	## 105/122/152/155 mm tube artillery (Smoke)
	ARTILLERY_SMOKE,
	## 105/122/152/155 mm tube artillery (Flare)
	ARTILLERY_ILLUM,
	## Engineer Munitions: Mines
	ENGINEER_MINE,
	## Engineer Munitions: Demolition charges
	ENGINEER_DEMO,
	## Engineer Munitions: Bridge
	ENGINEER_BRIDGE
}

const _BASE_PERSONNEL_DAMAGE_PER_SOLDIER := 0.08
const _DEFAULT_AMMO_DAMAGE := {
	"SMALL_ARMS": 0.8,
	"HEAVY_WEAPONS": 2.2,
	"AUTOCANNON": 3.5,
	"TANK_GUN": 6.0,
	"AT_ROCKET": 4.5,
	"ATGM": 7.0,
	"MORTAR_AP": 3.2,
	"MORTAR_SMOKE": 0.2,
	"MORTAR_ILLUM": 0.1,
	"ARTILLERY_AP": 8.0,
	"ARTILLERY_SMOKE": 0.3,
	"ARTILLERY_ILLUM": 0.2,
	"ENGINEER_MINE": 4.0,
	"ENGINEER_DEMO": 4.5,
	"ENGINEER_BRIDGE": 0.0
}
const _ANTI_VEHICLE_AMMO_TYPES := [
	AmmoTypes.TANK_GUN,
	AmmoTypes.AT_ROCKET,
	AmmoTypes.ATGM,
	AmmoTypes.AUTOCANNON,
	AmmoTypes.ENGINEER_MINE,
	AmmoTypes.ENGINEER_DEMO
]

## Unique identifier for the unit
@export var id: String
## Human-readable title of the unit
@export var title: String
## Unit icon texture
@export var icon: Texture2D = null
## Enemy unit icon texture
@export var enemy_icon: Texture2D = null
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
@export var size: MilSymbol.UnitSize = MilSymbol.UnitSize.PLATOON:
	set(value):
		if size == value:
			return
		size = value
		_queue_icon_update()
	get:
		return size
## Organizational size of the unit
@export var type: MilSymbol.UnitType = MilSymbol.UnitType.INFANTRY:
	set(value):
		if type == value:
			return
		type = value
		_queue_icon_update()
	get:
		return type
## Number of personnel in the unit at full strength
@export var strength: int = 36
## Is unit an engineer unit (can repair).
@export var is_engineer: bool = false
## Is unit a medical unit (can medic injured).
@export var is_medical: bool = false
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
## Per-unit understrength threshold (0.0-1.0)
@export var understrength_threshold: float = 0.8

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

var _icon_rev: int = 0


func _init() -> void:
	call_deferred("_queue_icon_update")


## Schedule an async icon refresh (debounced to next idle message).
func _queue_icon_update() -> void:
	_icon_rev += 1
	var my_rev := _icon_rev
	call_deferred("_update_icons_async", my_rev)


## Build both friend/enemy icons asynchronously. Drops stale results.
## [param rev] Internal version token to ignore out-of-date completions.
func _update_icons_async(rev: int) -> void:
	# In editor, make sure a frame passes so resources/servers are ready.
	var tree := Engine.get_main_loop() as SceneTree
	if tree:
		await tree.process_frame

	var task_friend = await MilSymbol.create_symbol(
		MilSymbol.UnitAffiliation.FRIEND, type, MilSymbolConfig.Size.MEDIUM, size
	)
	var task_enemy = await MilSymbol.create_symbol(
		MilSymbol.UnitAffiliation.ENEMY, type, MilSymbolConfig.Size.MEDIUM, size
	)

	var friend_tex: ImageTexture = task_friend
	var enemy_tex: ImageTexture = task_enemy

	if rev != _icon_rev:
		return

	icon = friend_tex
	enemy_icon = enemy_tex

	# Notify editor/consumers.
	emit_changed()
	emit_signal("icons_ready")


## Serialize this unit to JSON
func serialize() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"role": role,
		"allowed_slots": allowed_slots.duplicate(),
		"cost": cost,
		"size": int(size),
		"type": int(type),
		"strength": strength,
		"is_engineer": is_engineer,
		"is_medical": is_medical,
		"equipment": equipment.duplicate(),
		"experience": experience,
		"stats":
		{
			"attack": attack,
			"defense": defense,
			"spot_m": spot_m,
			"range_m": range_m,
			"morale": morale,
			"speed_kph": speed_kph,
			"understrength_threshold": understrength_threshold
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

	u.size = int(data.get("size", u.size)) as MilSymbol.UnitSize
	u.type = int(data.get("type", u.type)) as MilSymbol.UnitType
	u.movement_profile = (
		int(data.get("movement_profile", u.movement_profile)) as TerrainBrush.MoveProfile
	)
	u.strength = int(data.get("strength", u.strength))
	u.is_engineer = bool(data.get("is_engineer", u.is_engineer))
	u.is_medical = bool(data.get("is_medical", u.is_medical))
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
		u.understrength_threshold = float(
			stats.get("understrength_threshold", u.understrength_threshold)
		)

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


## Calculates the attack rating using equipment, ammo profiles, and strength.
## [param ammo_damage_config] Optional ammo damage configuration.
## [param current_strength] Optional current strength override (defaults to full strength).
func compute_attack_power(
	ammo_damage_config: AmmoDamageConfig = null, current_strength: float = -1.0
) -> float:
	_ensure_ammunition_from_equipment()
	var weapons: Dictionary = _get_equipment_category("weapons")
	var total_weapon_power: float = 0.0
	for weapon_name in weapons.keys():
		var weapon_data: Variant = weapons[weapon_name]
		if typeof(weapon_data) != TYPE_DICTIONARY:
			continue
		var weapon_entry: Dictionary = weapon_data
		total_weapon_power += _compute_weapon_attack_value(weapon_entry, ammo_damage_config)

	var effective_strength: float = current_strength
	if effective_strength < 0.0:
		effective_strength = float(strength)
	effective_strength = max(effective_strength, 0.0)

	if float(strength) > 0.0:
		var ratio: float = clamp(effective_strength / float(strength), 0.0, 1.25)
		total_weapon_power *= ratio

	# Always give personnel a baseline small-arms contribution so support units aren't helpless.
	var manpower_component: float = effective_strength * _BASE_PERSONNEL_DAMAGE_PER_SOLDIER
	var computed: float = max(total_weapon_power + manpower_component, 0.0)
	attack = computed
	return computed


## Calculates the attack contribution for a single weapon entry.
func _compute_weapon_attack_value(
	weapon_entry: Dictionary, ammo_damage_config: AmmoDamageConfig = null
) -> float:
	if typeof(weapon_entry) != TYPE_DICTIONARY:
		return 0.0

	var ammo_idx := _resolve_ammo_index(weapon_entry.get("ammo", -1))
	var ammo_key := _ammo_index_to_key(ammo_idx)
	var base_damage := 0.0
	if ammo_damage_config != null and ammo_key != "":
		base_damage = ammo_damage_config.get_damage_for(ammo_key)
	if base_damage <= 0.0:
		base_damage = _default_ammo_damage(ammo_key)

	var qty: float = float(
		weapon_entry.get("type", weapon_entry.get("count", weapon_entry.get("quantity", 1.0)))
	)
	if qty <= 0.0:
		qty = 1.0

	var ammo_ratio: float = 1.0
	if ammo_key != "":
		var cap := _get_ammo_amount(ammunition, ammo_key)
		var cur := _get_ammo_amount(state_ammunition, ammo_key)
		if cur <= 0.0 and cap > 0.0 and not _has_ammo_key(state_ammunition, ammo_key):
			cur = cap
		if cap > 0.0:
			ammo_ratio = clamp(cur / cap, 0.0, 1.0)
		elif _has_ammo_key(ammunition, ammo_key):
			ammo_ratio = 0.0

	return base_damage * qty * ammo_ratio


## Returns the ammo types referenced by the unit's weapon equipment.
func get_weapon_ammo_types() -> Dictionary:
	var result: Dictionary = {}
	var weapons: Dictionary = _get_equipment_category("weapons")
	for weapon_name in weapons.keys():
		var weapon_data: Variant = weapons[weapon_name]
		if typeof(weapon_data) != TYPE_DICTIONARY:
			continue
		var weapon_entry: Dictionary = weapon_data
		var ammo_idx := _resolve_ammo_index(weapon_entry.get("ammo", -1))
		if ammo_idx < 0:
			continue
		var ammo_key := _ammo_index_to_key(ammo_idx)
		if ammo_key == "":
			continue
		var qty: int = int(
			weapon_entry.get("type", weapon_entry.get("count", weapon_entry.get("quantity", 1)))
		)
		if qty <= 0:
			qty = 1
		result[ammo_key] = int(result.get(ammo_key, 0)) + qty
	return result


## Returns true when the equipment loadout includes anti-vehicle weapons.
func has_anti_vehicle_weapons() -> bool:
	var weapons: Dictionary = _get_equipment_category("weapons")
	for weapon_name in weapons.keys():
		var weapon_data: Variant = weapons[weapon_name]
		if typeof(weapon_data) != TYPE_DICTIONARY:
			continue
		var weapon_entry: Dictionary = weapon_data
		if _is_anti_vehicle_ammo(_resolve_ammo_index(weapon_entry.get("ammo", -1))):
			return true
	return false


## Helper to classify a weapon ammo enum index as anti-vehicle capable.
func _is_anti_vehicle_ammo(ammo_type: int) -> bool:
	if ammo_type < 0:
		return false
	return _ANTI_VEHICLE_AMMO_TYPES.has(ammo_type)


## Returns true when the unit should be treated as a vehicle target in combat.
func is_vehicle_unit() -> bool:
	var vehicles: Dictionary = _get_equipment_category("vehicles")
	for vehicle_name in vehicles.keys():
		var vehicle_entry: Variant = vehicles[vehicle_name]
		match typeof(vehicle_entry):
			TYPE_DICTIONARY:
				if int(vehicle_entry.get("type", vehicle_entry.get("count", 0))) > 0:
					return true
			TYPE_INT, TYPE_FLOAT:
				if int(vehicle_entry) > 0:
					return true
			_:
				continue

	match movement_profile:
		TerrainBrush.MoveProfile.TRACKED, TerrainBrush.MoveProfile.WHEELED:
			return true
		_:
			pass

	if (
		type
		in [MilSymbol.UnitType.ARMOR, MilSymbol.UnitType.MECHANIZED, MilSymbol.UnitType.MOTORIZED]
	):
		return true

	for slot in allowed_slots:
		var slot_str := String(slot).to_upper()
		if slot_str.find("ARMOR") != -1 or slot_str.find("MECH") != -1:
			return true

	return false


## Builds ammunition dictionaries based on equipped weapons when values are missing.
func _ensure_ammunition_from_equipment() -> void:
	var weapons := _get_equipment_category("weapons")
	if weapons.is_empty():
		return

	var ammo_caps: Dictionary = {}
	for weapon_name in weapons.keys():
		var entry_variant: Variant = weapons[weapon_name]
		if typeof(entry_variant) != TYPE_DICTIONARY:
			continue
		var weapon_entry: Dictionary = entry_variant
		var ammo_idx := _resolve_ammo_index(weapon_entry.get("ammo", -1))
		if ammo_idx < 0:
			continue
		var ammo_key := _ammo_index_to_key(ammo_idx)
		if ammo_key == "":
			continue

		var qty: int = int(
			weapon_entry.get("type", weapon_entry.get("count", weapon_entry.get("quantity", 1)))
		)
		if qty <= 0:
			qty = 1
		ammo_caps[ammo_key] = int(ammo_caps.get(ammo_key, 0)) + qty

	if ammo_caps.is_empty():
		return

	if typeof(ammunition) != TYPE_DICTIONARY or ammunition == null:
		ammunition = {}
	if typeof(state_ammunition) != TYPE_DICTIONARY or state_ammunition == null:
		state_ammunition = {}

	for ammo_key in ammo_caps.keys():
		if not ammunition.has(ammo_key):
			ammunition[ammo_key] = ammo_caps[ammo_key]
		if not state_ammunition.has(ammo_key):
			state_ammunition[ammo_key] = ammo_caps[ammo_key]


## Lookup an equipment category while tolerating mixed-case keys.
func _get_equipment_category(category_name: String) -> Dictionary:
	if typeof(equipment) != TYPE_DICTIONARY or category_name == "":
		return {}
	var lookup := category_name.to_lower()
	if equipment.has(lookup) and typeof(equipment[lookup]) == TYPE_DICTIONARY:
		return equipment[lookup]
	for key in equipment.keys():
		if String(key).to_lower() == lookup and typeof(equipment[key]) == TYPE_DICTIONARY:
			return equipment[key]
	return {}


## Convert ammo enum index -> string key ("SMALL_ARMS").
static func _ammo_index_to_key(idx: int) -> String:
	if idx < 0:
		return ""
	var keys := AmmoTypes.keys()
	if idx >= 0 and idx < keys.size():
		return String(keys[idx])
	return ""


## Convert ammo key name to enum index.
static func _ammo_key_to_index(ammo_key: String) -> int:
	if ammo_key == "":
		return -1
	var key_upper := ammo_key.to_upper()
	var keys := AmmoTypes.keys()
	for i in range(keys.size()):
		if String(keys[i]).to_upper() == key_upper:
			return i
	return -1


## Safely fetch an ammo value from a dictionary that might use string or numeric keys.
static func _get_ammo_amount(source: Dictionary, ammo_key: String) -> float:
	if typeof(source) != TYPE_DICTIONARY or ammo_key == "":
		return 0.0
	if source.has(ammo_key):
		return float(source[ammo_key])
	var idx := _ammo_key_to_index(ammo_key)
	if idx >= 0 and source.has(idx):
		return float(source[idx])
	return 0.0


## Returns true if the dictionary contains the ammo key as string or enum index.
static func _has_ammo_key(source: Dictionary, ammo_key: String) -> bool:
	if typeof(source) != TYPE_DICTIONARY or ammo_key == "":
		return false
	if source.has(ammo_key):
		return true
	var idx := _ammo_key_to_index(ammo_key)
	return idx >= 0 and source.has(idx)


## Fallback damage when no config entry is available.
static func _default_ammo_damage(ammo_key: String) -> float:
	return float(_DEFAULT_AMMO_DAMAGE.get(ammo_key, 1.0))


## Normalize mixed ammo representations (string/int) to an enum index.
static func _resolve_ammo_index(value: Variant) -> int:
	match typeof(value):
		TYPE_STRING:
			return _ammo_key_to_index(String(value))
		TYPE_INT, TYPE_FLOAT:
			return int(value)
		_:
			return -1
