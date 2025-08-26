extends PanelContainer
class_name UnitCard
## Recruitable unit card.

signal unit_selected(unit: Dictionary)

var default_icon: Texture2D
var _cached_size: Vector2 = Vector2.ZERO

var unit: Dictionary
var unit_id: StringName

var _is_hovered := false
var _is_selected := false

var _name_label: Label
var _role_label: Label
var _icon: TextureRect

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_cached_size = size

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_cached_size = size

func setup(u: Dictionary) -> void:
	unit = u
	unit_id = StringName(u.get("id", ""))

	_clear_children()

	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	custom_minimum_size = Vector2(0, 64)
	_update_styleboxes()
	mouse_filter = Control.MOUSE_FILTER_STOP

	var hb := HBoxContainer.new()
	hb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.add_theme_constant_override("separation", 8)
	hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(hb)

	_icon = TextureRect.new()
	_icon.custom_minimum_size = Vector2(48, 48)
	_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE 
	hb.add_child(_icon)

	# Load icon
	var icon_path := String(u.get("icon", ""))
	if icon_path != "":
		var tex := load(icon_path)
		if tex:
			_icon.texture = tex
	elif default_icon:
		_icon.texture = default_icon

	var vb := VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE 
	hb.add_child(vb)

	_name_label = Label.new()
	_name_label.text = String(u.get("title", unit_id))
	_name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(_name_label)

	_role_label = Label.new()
	_role_label.text = String(u.get("role", ""))
	_role_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_role_label.modulate = Color(0.8, 0.85, 0.95)
	vb.add_child(_role_label)

	tooltip_text = "%s (%s)  •  Cost: %d" % [
		_name_label.text, _role_label.text, int(u.get("cost", 0))
	]

	mouse_entered.connect(func(): _is_hovered = true;  _update_styleboxes())
	mouse_exited.connect(func():  _is_hovered = false; _update_styleboxes())
	

func set_selected(v: bool) -> void:
	_is_selected = v
	_update_styleboxes()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("unit_selected", unit)

func _get_drag_data(_pos: Vector2) -> Variant:
	var preview := _make_drag_preview()
	set_drag_preview(preview)

	return {
		"type": "unit",
		"unit": unit,
		"unit_id": String(unit.get("id", ""))
	}

func _make_drag_preview() -> Control:
	var s := size if (_cached_size == Vector2.ZERO) else _cached_size

	var p := PanelContainer.new()
	p.set_anchors_preset(Control.PRESET_TOP_LEFT)
	p.custom_minimum_size = s
	p.size = s
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# copy panel look (optional)
	var sb := get_theme_stylebox("panel")
	if sb:
		p.add_theme_stylebox_override("panel", sb.duplicate())

	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 8)
	hb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.size_flags_vertical = 0
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
	vb.size_flags_vertical = 0
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_child(vb)

	var name := Label.new()
	name.text = _name_label.text
	name.clip_text = true
	name.autowrap_mode = TextServer.AUTOWRAP_OFF
	name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name.size_flags_vertical = 0
	name.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(name)

	var role := Label.new()
	role.text = _role_label.text
	role.clip_text = true
	role.autowrap_mode = TextServer.AUTOWRAP_OFF
	role.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	role.size_flags_vertical = 0
	role.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(role)

	return p

func _clear_children() -> void:
	for c in get_children():
		c.queue_free()

func _update_styleboxes() -> void:
	## Style: base, hover, selected.
	# Base
	var base := StyleBoxFlat.new()
	base.bg_color = Color(0.10, 0.12, 0.15)
	base.corner_radius_top_left = 8
	base.corner_radius_top_right = 8
	base.corner_radius_bottom_left = 8
	base.corner_radius_bottom_right = 8
	base.set_border_width_all(1)
	base.border_color = Color(0.18, 0.22, 0.28)

	# Hover overlay
	if _is_hovered:
		base.bg_color = base.bg_color.lerp(Color(0.18, 0.22, 0.28), 0.6)
		base.border_color = Color(0.30, 0.45, 0.85)

	# Selected overlay
	if _is_selected:
		base.bg_color = base.bg_color.lerp(Color(0.22, 0.28, 0.36), 0.85)
		base.border_color = Color(0.45, 0.70, 1.0)
		base.set_border_width_all(2)

	add_theme_stylebox_override("panel", base)
