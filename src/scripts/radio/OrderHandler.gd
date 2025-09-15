extends Node
## catches when an invalid command is emmited from parsed order and plays ana audio to inform the player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OrdersParser.parse_error.connect(_on_parseError)


func _on_parseError(error: String) -> void:
	print("parsing failed and cought")
	var error_sound = get_node("errorSound") as AudioStreamPlayer
	error_sound.play()
	
	
