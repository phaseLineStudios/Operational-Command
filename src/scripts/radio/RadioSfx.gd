class_name RadioResponsesSfx
extends Node

## Unit Voice Responses node.
@export var unit_responses_node: UnitVoiceResponses
## Sound to play at the start of the transmission
@export var transmission_start_sound: AudioStream
## Sound to play during the transmission
@export var transmission_noise_sound: AudioStream
## Sound to play at the end of the transmission
@export var transmission_end_sound: AudioStream

@onready var noise_player: AudioStreamPlayer3D = %Noise
@onready var trigger_player: AudioStreamPlayer3D = %Trigger

func _ready() -> void:
	if not unit_responses_node:
		LogService.warning("Failed to find unit responses node", "RadioResponsesSfx.gd")
		return
	
	if transmission_noise_sound:
		noise_player.stream = transmission_noise_sound
	
	unit_responses_node.transmission_start.connect(_on_transmission_start)
	unit_responses_node.transmission_end.connect(_on_transmission_end)

func _on_transmission_start(_callsign: String) -> void:
	if transmission_noise_sound:
		noise_player.play()
	
	if transmission_start_sound:
		trigger_player.stream = transmission_start_sound
		trigger_player.play()

func _on_transmission_end(_callsign: String) -> void:
	if transmission_noise_sound:
		noise_player.stop()
	
	if transmission_end_sound:
		trigger_player.stream = transmission_end_sound
		trigger_player.play()
