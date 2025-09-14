extends Window
class_name SlotConfigDialog

@onready var key_input: LineEdit = %Key
@onready var title_input: LineEdit = %Title
@onready var roles_input: LineEdit = %RoleInput
@onready var roles_add: Button = %RoleAdd
@onready var roles_list: VBoxContainer = %RoleVBox
@onready var save_btn: Button = %Save
@onready var close_btn: Button = %Close

var editor: ScenarioEditor
var slot_index := -1
var _roles: Array[String] = []

func _ready() -> void:
	save_btn.pressed.connect(_on_save)
	close_btn.pressed.connect(func(): show_dialog(false))
	close_requested.connect(func(): show_dialog(false))
	roles_add.pressed.connect(_on_role_add)

## Show dialog for a specific slot entry index in editor.data.unit_slots
func show_for(_editor: ScenarioEditor, index: int) -> void:
	editor = _editor
	slot_index = index
	var entry := editor.data.unit_slots[slot_index]
	var s: UnitSlotData = entry
	key_input.text = String(s.key)
	title_input.text = s.title
	_roles = s.allowed_roles
	_refresh_role_list()
	visible = true

## Save slot config
func _on_save() -> void:
	if editor == null or slot_index < 0: return
	var entry := editor.data.unit_slots[slot_index]
	var s: UnitSlotData = entry
	s.key = key_input.text
	s.title = title_input.text
	s.allowed_roles = _roles
	visible = false
	editor._request_overlay_redraw()
	editor._rebuild_scene_tree()

## Add role to role list
func _on_role_add():
	var role := roles_input.text
	if role in _roles:
		return
	_roles.append(role)
	roles_input.text = ""
	_refresh_role_list()

## Remove a role from role list
func _on_remove_role(role: String):
	var idx := _roles.find(role)
	_roles.remove_at(idx)
	_refresh_role_list()

## Refresh role list
func _refresh_role_list():
	editor._queue_free_children(roles_list)
	for role in _roles:
		var rwp := PanelContainer.new()
		var row := HBoxContainer.new()
		var lbl := Label.new()
		lbl.text = role
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(lbl)
		var btn := Button.new()
		btn.text = "Remove"
		btn.pressed.connect(func(): _on_remove_role(role))
		row.add_child(btn)
		rwp.add_child(row)
		roles_list.add_child(rwp)

## Show/hide dialog
func show_dialog(state: bool):
	visible = state
