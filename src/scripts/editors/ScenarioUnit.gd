extends Resource
class_name ScenarioUnit

enum CombatMode { forced_hold_fire, do_not_fire_unless_fired_upon, open_fire }
enum Behaviour { careless, safe, aware, combat, stealth }
enum Affiliation { friend, enemy }

## Unique identifier
@export var id: String
## Callsign
@export var callsign: String
## Unit Data
@export var unit: UnitData
## Unit Position
@export var position_m: Vector2
## Unit Affiliation
@export var affiliation: Affiliation
## Unit Combat Mode
@export var combat_mode: CombatMode = CombatMode.open_fire
## Unit Behaviour
@export var behaviour: Behaviour = Behaviour.safe

func serialize() -> Dictionary:
	return {
		"id": id,
		"unit_id": unit.id,
		"callsign": callsign,
		"position": ContentDB.v2(position_m),
		"affiliation": int(affiliation),
		"combat_mode": int(combat_mode),
		"behaviour": int(behaviour)
	}

static func deserialize(d: Dictionary) -> ScenarioUnit:
	var u := ScenarioUnit.new()
	u.id = d.get("id")
	u.unit = ContentDB.get_unit(d.get("unit_id"))
	u.callsign = d.get("callsign", "unit")
	u.position_m = ContentDB.v2_from(d.get("position"))
	u.affiliation = int(d.get("affiliation")) as Affiliation
	u.combat_mode = int(d.get("combat_mode")) as CombatMode
	u.behaviour = int(d.get("behaviour")) as Behaviour
	return u
