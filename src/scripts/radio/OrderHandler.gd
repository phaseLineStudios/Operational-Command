extends Node
## catches when an invalid command is emmited from parsed order and plays ana audio to inform the player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OrdersParser.parse_error.connect(_on_parseError)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_parseError(error: String) -> void:
	print("parsing failed and cought")
	
