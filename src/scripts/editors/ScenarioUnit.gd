extends Resource
class_name ScenarioUnit

## Unit Data
@export var unit: UnitData
## Unit Position
@export var position_m: Vector2

func serialize() -> Dictionary:
	return {
		"unit_id": unit.id,
		"position": ContentDB.v2(position_m)
	}

static func deserialize(d: Dictionary) -> ScenarioUnit:
	var u := ScenarioUnit.new()
	u.unit = ContentDB.get_unit(d.get("unit_id"))
	u.position_m = ContentDB.v2_from(d.get("position"))
	return u
