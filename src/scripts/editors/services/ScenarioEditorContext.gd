extends RefCounted
class_name ScenarioEditorContext

signal overlay_redraw_requested
@warning_ignore("unused_signal")
signal selection_changed(pick: Dictionary)
signal scene_tree_rebuild_requested
signal toast_requested(text: String)

var data: ScenarioData
var history: ScenarioHistory

var terrain_render: TerrainRender
var terrain_overlay: ScenarioEditorOverlay
var scene_tree: Tree
var tool_hint: HBoxContainer
var mouse_position_label: Label

# UI panes
var unit_list: Tree
var unit_category_opt: OptionButton
var unit_search: LineEdit
var unit_faction_friend: Button
var unit_faction_enemy: Button

var task_list: ItemList
var trigger_list: ItemList

# State shared across services
var selected_pick: Dictionary = {}
var current_tool: ScenarioToolBase
var selected_unit_affiliation := ScenarioUnit.Affiliation.enemy


func request_overlay_redraw() -> void:
	overlay_redraw_requested.emit()


func request_scene_tree_rebuild() -> void:
	scene_tree_rebuild_requested.emit()


func toast(msg: String) -> void:
	toast_requested.emit(msg)
