extends Resource
class_name UnitSlotData

@export var key: String = "PLT_1"
@export var title: String = "1st Platoon"
@export var allowed_roles: Array[String] = ["INF", "MOTOR", "MECH"]

## Serialize data to JSON
func serialize() -> Dictionary:
	return {
		"key": key,
		"title": title,
		"allowed_roles": allowed_roles.duplicate()
	}

## Deserialize data from JSON
static func deserialize(data: Variant) -> UnitSlotData:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var inst := UnitSlotData.new()
	inst.key = data.get("key", inst.key)
	inst.title = data.get("title", inst.title)

	var roles = data.get("allowed_roles", inst.allowed_roles)
	if typeof(roles) == TYPE_ARRAY:
		var tmp: Array[String] = []
		for r in roles:
			tmp.append(str(r))
		inst.allowed_roles = tmp

	return inst
