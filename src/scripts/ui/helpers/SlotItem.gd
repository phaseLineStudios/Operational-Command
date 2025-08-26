extends PanelContainer
class_name SlotItem
## Unit slot panel. Accepts drops and shows current assignment.

## @experimental

signal request_assign_drop(slot_id: String, unit: Dictionary, source_slot_id: String)
signal request_inspect_unit(unit: Dictionary)

var slot_id: String
var title: String
var allowed_roles: Array = []
var index := 1
var max_count := 1

var _assigned_unit: Dictionary = {}

var _vb: VBoxContainer
var _title_lbl: Label
var _state_lbl: Label

func _ready() -> void:
	_ensure_ui()
	custom_minimum_size = Vector2(0, 48)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mouse_filter = Control.MOUSE_FILTER_STOP
	_update_style(false)

func _ensure_ui() -> void:
	if _vb: return
	_vb = VBoxContainer.new()
	_vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_vb)

	_title_lbl = Label.new()
	_title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_title_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_vb.add_child(_title_lbl)

	_state_lbl = Label.new()
	_state_lbl.modulate = Color(0.8, 0.85, 0.95)
	_state_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_vb.add_child(_state_lbl)

	# Hover + click
	mouse_entered.connect(func(): _update_style(true))
	mouse_exited.connect(func(): _update_style(false))

func configure(id: String, slot_title: String, roles: Array, i: int, m: int) -> void:
	slot_id = id
	title = slot_title
	allowed_roles = roles.duplicate()
	index = i
	max_count = m
	_ensure_ui()
	_update_labels()

func _update_labels() -> void:
	_ensure_ui()
	var roles_str := ", ".join(allowed_roles)
	_title_lbl.text = title
	var suffix := "Slot %d/%d  •  [%s]" % [index, max_count, roles_str]
	if _assigned_unit.is_empty():
		_state_lbl.text = "%s — (empty)" % suffix
	else:
		var unit_name := String(_assigned_unit.get("title", _assigned_unit.get("id", "")))
		_state_lbl.text = "%s — %s" % [suffix, unit_name]

func _update_style(hovered: bool) -> void:
	var sb := StyleBoxFlat.new()
	sb.corner_radius_top_left = 8
	sb.corner_radius_top_right = 8
	sb.corner_radius_bottom_left = 8
	sb.corner_radius_bottom_right = 8
	sb.set_border_width_all(1)
	sb.bg_color = Color(0.10, 0.12, 0.15)
	sb.border_color = Color(0.18, 0.22, 0.28)
	if hovered:
		sb.bg_color = sb.bg_color.lerp(Color(0.18, 0.22, 0.28), 0.5)
	if not _assigned_unit.is_empty():
		sb.border_color = Color(0.3, 0.55, 0.9)
	add_theme_stylebox_override("panel", sb)

func set_assignment(unit: Dictionary) -> void:
	_assigned_unit = unit.duplicate(true)
	_update_labels()
	_update_style(false)

func clear_assignment() -> void:
	_assigned_unit = {}
	_update_labels()
	_update_style(false)

func _gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		if not _assigned_unit.is_empty():
			emit_signal("request_inspect_unit", _assigned_unit)

func _can_drop_data(_pos: Vector2, data: Variant) -> bool:
	if typeof(data) != TYPE_DICTIONARY or not data.has("type"):
		return false
	var kind := String(data["type"])
	if kind != "unit" and kind != "assigned_unit":
		return false
	var unit: Dictionary = data.get("unit", {})
	var role := String(unit.get("role", ""))
	return allowed_roles.has(role)

func _drop_data(_pos: Vector2, data: Variant) -> void:
	if not _can_drop_data(_pos, data):
		modulate = Color(1, 0.6, 0.6); await get_tree().create_timer(0.15).timeout; modulate = Color(1,1,1)
		return
	var unit: Dictionary = data.get("unit", {})
	var source_slot_id := String(data.get("slot_id", ""))
	emit_signal("request_assign_drop", slot_id, unit, source_slot_id)

func _get_drag_data(_pos: Vector2) -> Variant:
	if _assigned_unit.is_empty():
		return null
	var p := Label.new()
	p.text = String(_assigned_unit.get("title", _assigned_unit.get("id", "")))
	set_drag_preview(p)
	return {"type":"assigned_unit","unit":_assigned_unit,"slot_id":slot_id}
