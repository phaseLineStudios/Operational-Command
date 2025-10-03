class_name RadioFeedback
extends Node
## Catches when an invalid command is emitted from parsed order and plays
## an audio to inform the player

@onready var error_player: AudioStreamPlayer2D = %ErrorSound


func _ready() -> void:
	OrdersParser.parse_error.connect(_on_parse_error)


func _on_parse_error(error: String) -> void:
	LogService.error("error: %s, playing audio..." % error, "RadioFeedback.gd:11")
	if error_player:
		error_player.play()
