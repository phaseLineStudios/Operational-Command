class_name SceneEnvironment
extends Node3D


func _ready() -> void:
	hide_helpers()


func hide_helpers() -> void:
	%Helpers.visible = false
