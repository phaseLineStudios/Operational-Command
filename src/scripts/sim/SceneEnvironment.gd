class_name SceneEnvironment
extends Node3D

@export var scenario: ScenarioData

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
