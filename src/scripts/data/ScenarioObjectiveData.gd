class_name ScenarioObjectiveData
extends Resource

## Unique identifier for this objective
@export var id: String
## Human-readable title of the objective
@export var title: String
## Description of success conditions for this objective
@export var success: String
## Score awarded for completing this objective
@export var score: int = 100


## Serialize into JSON
func serialize() -> Dictionary:
	return {"id": id, "title": title, "success": success, "score": score}


## Deserialize from JSON
static func deserialize(data: Variant) -> ScenarioObjectiveData:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var o := ScenarioObjectiveData.new()
	o.id = data.get("id", o.id)
	o.title = data.get("title", o.title)
	o.success = data.get("success", o.success)
	o.score = int(data.get("score", o.score))

	return o
