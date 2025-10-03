class_name UnitCard
extends PanelContainer
## Recruitable unit card.

## Emitted when user clicks the card.
signal unit_selected(unit: Dictionary)

## Fallback icon if unit["icon"] is missing/empty.
@export var fallback_default_icon: Texture2D
## Hover style
@export var hover_style: StyleBox
## Selected Style
@export var selected_style: StyleBox

var unit: UnitData
var unit_id: String
var default_icon: Texture2D
var _base_style: StyleBox

var _is_hovered := false
var _is_selected := false
var _cached_size := Vector2.ZERO

@onready var _row: HBoxContainer = $"Row"
@onready var _icon: TextureRect = $"Row/Icon"
@onready var _name: Label = $"Row/Text/Name"
@onready var _role: Label = $"Row/Text/Role"
@onready var _cost: Label = $"Row/Cost"


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	var sb := get_theme_stylebox("panel")
	if sb:
		_base_style = sb.duplicate()


## Initialize card visual with a unit dictionary.
func setup(u: UnitData) -> void:
	unit = u
	mouse_filter = Control.MOUSE_FILTER_STOP
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	custom_minimum_size = Vector2(0, 64)

	# Children should not swallow input (so drag starts from the card)
	_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_name.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_role.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Text
	_name.text = String(u.title)
	_name.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_role.text = String(u.role)
	_cost.text = "Cost: %d" % int(u.cost if u.cost else 0)
	tooltip_text = "%s (%s) • Cost: %d" % [_name.text, _role.text, int(u.cost if u.cost else 0)]

	# Icon
	var tex: Texture2D = null
	if u.icon:
		tex = u.icon
	if tex == null and default_icon:
		tex = default_icon
	if tex == null and fallback_default_icon:
		tex = fallback_default_icon
	_icon.texture = tex

	_update_style()


## Mark card as selected by the controller.
func set_selected(v: bool) -> void:
	_is_selected = v
	_update_style()


## Apply hover/selected panel styling.
func _update_style() -> void:
	if _is_selected and selected_style:
		add_theme_stylebox_override("panel", selected_style)
	elif _is_hovered and hover_style:
		add_theme_stylebox_override("panel", hover_style)
	elif _base_style:
		add_theme_stylebox_override("panel", _base_style)
	else:
		remove_theme_stylebox_override("panel")


## Click to inspect the unit.
func _gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		emit_signal("unit_selected", unit)


## Cache laid-out size for drag preview.
func _notification(what: int) -> void:
	if what == NOTIFICATION_READY:
		_cached_size = size
	elif what == NOTIFICATION_RESIZED:
		_cached_size = size


## Hover-in visual feedback.
func _on_mouse_entered() -> void:
	_is_hovered = true
	_update_style()


## Hover-out visual feedback.
func _on_mouse_exited() -> void:
	_is_hovered = false
	_update_style()


## Provide drag payload.
func _get_drag_data(_pos: Vector2) -> Variant:
	var preview := _make_drag_preview()
	set_drag_preview(preview)
	return {"type": "unit", "unit": unit, "unit_id": unit_id}


## Build a fixed-size preview that matches the pool layout.
func _make_drag_preview() -> Control:
	var s := size if (_cached_size == Vector2.ZERO) else _cached_size

	var p := PanelContainer.new()
	p.set_anchors_preset(Control.PRESET_TOP_LEFT)
	p.custom_minimum_size = s
	p.size = s
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var sb := get_theme_stylebox("panel")
	if sb:
		p.add_theme_stylebox_override("panel", sb.duplicate())

	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 8)
	hb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(hb)

	var icon := TextureRect.new()
	icon.texture = _icon.texture
	icon.custom_minimum_size = _icon.custom_minimum_size
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_child(icon)

	var vb := VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_child(vb)

	var name_label := Label.new()
	name_label.text = _name.text
	name_label.clip_text = true
	name_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(name_label)

	var role := Label.new()
	role.text = _role.text
	role.clip_text = true
	role.autowrap_mode = TextServer.AUTOWRAP_OFF
	role.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	role.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(role)

	return p
