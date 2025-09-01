@tool
extends RefCounted
class_name TerrainToolBase

## Base class for terrain editor tools.

signal on_options_changed()
signal on_need_info()

var editor: TerrainEditor
var render: TerrainRender
var data: TerrainData
var brushes: Array[TerrainBrush] = []
var features: Array[Variant] = []

## Metadata for UI
var tool_icon: Texture2D
var tool_hint: String = ""

## Assign Metadata
func _init():
	#tool_icon = preload("")
	tool_hint = "Base Tool"

## Handle viewport input. Return true if consumed.
func handle_view_input(_event: InputEvent) -> bool:
	return false

## Populate options UI.
func build_options_ui(_parent: Control) -> void:
	pass

## Populate info UI.
func build_info_ui(_parent: Control) -> void:
	pass

## Undo/Redo hooks.
func undo() -> void: pass
func redo() -> void: pass
