class_name ScenarioDrawing
extends Resource
## Base class for scenario drawings (stroke or stamp).
## @experimental

enum Kind { STROKE, STAMP }

@export var id: String = ""
@export var visible: bool = true
@export var layer: int = 0
## Creation order for stable z-sort within a layer.
@export var order: int = 0


## Serialize to JSON-friendly Dictionary.
## [return] Dictionary with common fields.
func serialize_base() -> Dictionary:
	return {
		"id": id,
		"visible": visible,
		"layer": layer,
		"order": order,
	}


## Apply common fields from Dictionary.
## [param d] Source dictionary.
func deserialize_base(d: Dictionary) -> void:
	id = d.get("id", id)
	visible = d.get("visible", visible)
	layer = int(d.layer)
	order = int(d.order)


## Factory from Dictionary.
## [param d] Serialized object.
## [return] ScenarioDrawing or null.
static func deserialize(d: Dictionary) -> ScenarioDrawing:
	var t := String(d.get("type", ""))
	match t:
		"stroke":
			return ScenarioDrawingStroke.deserialize(d)
		"stamp":
			return ScenarioDrawingStamp.deserialize(d)
		_:
			return null
