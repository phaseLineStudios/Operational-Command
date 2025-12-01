class_name SlotItem
extends PanelContainer
## Unit slot. Accepts drops and shows current assigned unit.
##
## @experimental

## Emitted when a drop is accepted and controller should assign a unit to this slot
signal request_assign_drop(slot_id: String, unit: Dictionary, source_slot_id: String)
## Emitted when the user clicks a filled slot to inspect the assigned unit
signal request_inspect_unit(unit: Dictionary)

## Hover style when the slot is empty.
@export var hover_style_empty: StyleBox
## Style when the slot is filled
@export var filled_style: StyleBox
## Hover style when the slot is filled.
@export var hover_style_filled: StyleBox
## Style to show while hovering with an invalid payload (deny-hover).
@export var deny_hover_style: StyleBox
## Icon used when slot is empty or unit lacks icon.
@export var default_icon: Texture2D

@export_group("Slot Sounds")
## Sound to play when hovering over a slot
@export var hover_sounds: Array[AudioStream] = [
	preload("res://audio/ui/sfx_ui_button_hover_01.wav"),
	preload("res://audio/ui/sfx_ui_button_hover_02.wav")
]
## Sound to play when clicking a slot
@export var click_sounds: Array[AudioStream] = [
	preload("res://audio/ui/sfx_ui_button_click_01.wav"),
]

var slot_id: String = ""
var title: String = ""
var allowed_roles: Array = []
var index := 1
var max_count := 1
var _assigned_unit: UnitData

var _base_style: StyleBox
var _is_hovered := false
var _deny_hover := false

@onready var _row: HBoxContainer = $"Row"
@onready var _icon: TextureRect = $"Row/Icon"
@onready var _vb: VBoxContainer = $"Row/Column"
@onready var _lbl_title: Label = $"Row/Column/Title"
@onready var _lbl_slot: Label = $"Row/Column/Slot"


## Cache base style, wire hover, set mouse filters, and refresh visuals.
func _ready() -> void:
	var sb := get_theme_stylebox("panel")
	if sb:
		_base_style = sb.duplicate()

	_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_lbl_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_lbl_slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mouse_entered.connect(
		func():
			_is_hovered = true
			_apply_style()
			if hover_sounds.size() > 0 and _assigned_unit:
				AudioManager.play_random_ui_sound(
					hover_sounds, Vector2(1.0, 1.0), Vector2(0.98, 1.02)
				)
	)
	mouse_exited.connect(
		func():
			_is_hovered = false
			_deny_hover = false
			_apply_style()
	)
	_refresh_labels()
	_update_icon()
	_apply_style()


## Initialize slot metadata (id/title/roles/index/total) and update UI.
func configure(id: String, slot_title: String, roles: Array, i: int, m: int) -> void:
	slot_id = id
	title = slot_title
	allowed_roles = roles.duplicate()
	index = i
	max_count = m
	_refresh_labels()
	_update_icon()
	_apply_style()


## Assign a unit to this slot and refresh visuals.
func set_assignment(unit: UnitData) -> void:
	_assigned_unit = unit.duplicate(true)
	_refresh_labels()
	_update_icon()
	_apply_style()


## Clear the assigned unit and refresh visuals.
func clear_assignment() -> void:
	_assigned_unit = null
	_refresh_labels()
	_update_icon()
	_apply_style()


## Update Title, and Type.
func _refresh_labels() -> void:
	var roles_str := ", ".join(allowed_roles)
	if not _assigned_unit:
		_lbl_title.text = "[Empty] • %s" % title
		_lbl_slot.text = "Slot %d/%d • %s" % [index, max_count, roles_str]
	else:
		var unit_title: String = _assigned_unit.title
		_lbl_title.text = "%s • %s" % [unit_title, title]

		var unit_role: String = _assigned_unit.role
		_lbl_slot.text = "Slot %d/%d • %s" % [index, max_count, unit_role]


## Set icon to assigned unit's icon or fall back to exported default.
func _update_icon() -> void:
	var tex: Texture2D = null
	if _assigned_unit:
		if _assigned_unit.icon:
			tex = _assigned_unit.icon
	if tex == null:
		tex = await MilSymbol.create_frame_symbol(
			MilSymbol.UnitAffiliation.FRIEND,
			MilSymbol.UnitType.NONE,
			MilSymbolConfig.Size.MEDIUM,
			MilSymbol.UnitSize.NONE
		)
	_icon.texture = tex


## Apply style
func _apply_style() -> void:
	if _deny_hover and deny_hover_style:
		add_theme_stylebox_override("panel", deny_hover_style)
	elif _assigned_unit:
		if _is_hovered and hover_style_filled:
			add_theme_stylebox_override("panel", hover_style_filled)
		elif filled_style:
			add_theme_stylebox_override("panel", filled_style)
		elif _base_style:
			add_theme_stylebox_override("panel", _base_style)
	else:
		if _is_hovered and hover_style_empty:
			add_theme_stylebox_override("panel", hover_style_empty)
		elif _base_style:
			add_theme_stylebox_override("panel", _base_style)
		else:
			remove_theme_stylebox_override("panel")


## On click, emit inspect signal if a unit is assigned.
func _gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		if _assigned_unit != null:
			if click_sounds.size() > 0:
				AudioManager.play_random_ui_sound(
					click_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1)
				)
			emit_signal("request_inspect_unit", _assigned_unit)


## Validate payload type and role compatibility for dropping onto this slot.
func _can_drop_data(_pos: Vector2, data: Variant) -> bool:
	var ok: bool = typeof(data) == TYPE_DICTIONARY and data.has("type")
	if not ok:
		_deny_hover = false
		_apply_style()
		return false
	var t := String(data["type"])
	var is_valid_type := t == "unit" or t == "assigned_unit"
	if not is_valid_type:
		_deny_hover = false
		_apply_style()
		return false
	var unit: UnitData = data.get("unit", {})
	var can := allowed_roles.has(String(unit.role))
	_deny_hover = not can
	_apply_style()
	return can


## Emit assignment request for valid drops, else briefly flash deny.
func _drop_data(_pos: Vector2, data: Variant) -> void:
	if not _can_drop_data(_pos, data):
		return
	var unit: UnitData = data["unit"]
	var source_sid := String(data.get("slot_id", ""))
	emit_signal("request_assign_drop", slot_id, unit, source_sid)


## When filled, allow dragging the assigned unit out to pool or another slot.
func _get_drag_data(_pos: Vector2) -> Variant:
	if _assigned_unit == null:
		return null
	var p := Label.new()
	p.text = _assigned_unit.title
	set_drag_preview(p)
	return {"type": "assigned_unit", "unit": _assigned_unit, "slot_id": slot_id}


## Clear deny-hover at drag end to restore normal styling.
func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		_deny_hover = false
		_apply_style()
