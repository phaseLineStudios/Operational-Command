class_name UnitSlotData
extends Resource

## A unique key identifying this slot.
@export var key: String
## A human-readable title for the slot.
@export var title: String
## Ingame Callsign
@export var callsign: String
## A list of allowed roles
@export var allowed_roles: Array[String]
## Unit starting position
@export var start_position: Vector2


## Serialize data to JSON
func serialize() -> Dictionary:
	return {
		"key": key,
		"title": title,
		"callsign": callsign,
		"allowed_roles": allowed_roles.duplicate(),
		"start_position": ContentDB.v2(start_position)
	}


## Deserialize data from JSON
static func deserialize(data: Variant) -> UnitSlotData:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var inst := UnitSlotData.new()
	inst.key = data.get("key", inst.key)
	inst.title = data.get("title", inst.title)
	inst.callsign = data.get("callsign", inst.callsign)
	inst.start_position = ContentDB.v2_from(data.get("start_position", inst.start_position))

	var roles = data.get("allowed_roles", inst.allowed_roles)
	if typeof(roles) == TYPE_ARRAY:
		var tmp: Array[String] = []
		for r in roles:
			tmp.append(str(r))
		inst.allowed_roles = tmp

	return inst
