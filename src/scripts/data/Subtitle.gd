class_name Subtitle
extends Resource
## Inner class representing a single subtitle entry

## Start time in seconds
@export var start_time: float = 0.0

## End time in seconds
@export var end_time: float = 0.0

## Subtitle text content
@export var text: String = ""


func _init(p_start: float = 0.0, p_end: float = 0.0, p_text: String = "") -> void:
	start_time = p_start
	end_time = p_end
	text = p_text


## Serialize subtitle to dictionary
func serialize() -> Dictionary:
	return {"start_time": start_time, "end_time": end_time, "text": text}


## Deserialize subtitle from dictionary
static func deserialize(data: Dictionary) -> Subtitle:
	var subtitle := Subtitle.new()
	subtitle.start_time = data.get("start_time", 0.0)
	subtitle.end_time = data.get("end_time", 0.0)
	subtitle.text = data.get("text", "")
	return subtitle
