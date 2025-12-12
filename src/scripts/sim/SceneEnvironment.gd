class_name SceneEnvironment
extends Node3D

## Emitted when scenario changes.
signal scenario_changed(scenario: ScenarioData)

## Currently loaded scenario
@export var scenario: ScenarioData : 
	set(val):
		scenario = val
		emit_signal("scenario_changed", val)

var sound_controller: EnvSoundController


func _ready() -> void:
	sound_controller = %EnvSoundController
	hide_helpers()


func get_sound_controller() -> EnvSoundController:
	return sound_controller


func get_scenario() -> ScenarioData:
	return scenario


func hide_helpers() -> void:
	%Helpers.visible = false
