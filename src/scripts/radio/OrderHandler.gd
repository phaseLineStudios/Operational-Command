extends Node
## Catches when an invalid command is emitted from parsed order and plays an audio to inform the player

var error_player: AudioStreamPlayer2D

func _ready() -> void:
	OrdersParser.parse_error.connect(_on_parseError)
	error_player = get_node("/root/HQTable/Radio/errorSound")

func _on_parseError(error: String) -> void:
	print("error: %s, playing audio..." % error)
	if error_player:
		error_player.play()
