extends Control
## Mission Select controller
##
## Shows campaign map, mission pins, and a details card.

@onready var _container: Panel = $"Container"
@onready var _btn_back: Button = $"BackToCampaign"
@onready var _map_rect: TextureRect = $"Container/Map"
@onready var _pins_layer: Control = $"Container/PinsLayer"

@onready var _card: Panel = $"Container/MissionCard"
@onready var _card_title: Label = $"Container/MissionCard/VBoxContainer/Title"
@onready var _card_desc: RichTextLabel = $"Container/MissionCard/VBoxContainer/HBoxContainer/Desc"
@onready var _card_image: TextureRect = $"Container/MissionCard/VBoxContainer/HBoxContainer/VBoxContainer/Image"
@onready var _card_diff: Label = $"Container/MissionCard/VBoxContainer/HBoxContainer/VBoxContainer/Difficulty"
@onready var _card_start: Button = $"Container/MissionCard/VBoxContainer/HBoxContainer/VBoxContainer/StartMission"
@onready var _click_catcher: Control = $"Container/ClickCatcher"

var _selected_mission: ScenarioData
var _campaign: CampaignData
var _scenarios: Array[ScenarioData] = []
var _card_pin_button: BaseButton

## Size of each mission pin in pixels.
@export var pin_size := Vector2i(24, 24)
## Optional custom pin icon; if empty, a text-dot button is used.
@export var pin_texture: Texture2D
## Show title labels next to pins.
@export var show_pin_labels := true
## Offset for the label relative to the pin's top-left (px).
@export var pin_label_offset := Vector2(16, -8)
## Label background color (with alpha).
@export var pin_label_bg_color := Color(0, 0, 0, 0.65)
## Label text color.
@export var pin_label_text_color := Color(1, 1, 1)
## Label font size.
@export var pin_label_font_size := 14
## Label corner radius (px).
@export var pin_label_corner_radius := 6
## Extra padding inside the label panel (px).
@export var pin_label_padding := Vector2(6, 3)

## Path to campaign select scene
const SCENE_CAMPAIGN_SELECT := "res://scenes/campaign_select.tscn"

## Path to unit select scene
const SCENE_BRIEFING := "res://scenes/briefing.tscn"

## Build UI, load map, place pins, hook resizes.
func _ready() -> void:
	_btn_back.pressed.connect(_on_back_pressed)
	_load_campaign_and_map()
	await get_tree().process_frame
	_build_pins()

	_click_catcher.gui_input.connect(_on_backdrop_gui_input)
	if not resized.is_connected(_update_pin_positions):
		resized.connect(_update_pin_positions)
	if not _container.resized.is_connected(_update_pin_positions):
		_container.resized.connect(_update_pin_positions)
	if not _map_rect.resized.is_connected(_update_pin_positions):
		_map_rect.resized.connect(_update_pin_positions)
	if not _card_start.pressed.is_connected(_on_start_pressed):
		_card_start.pressed.connect(_on_start_pressed)

## Load current campaign + map.
func _load_campaign_and_map() -> void:
	_campaign = Game.current_campaign
	if not _campaign:
		push_warning("MissionSelect: No current campaign set.")
		return
	
	if _campaign.scenario_bg:
		_map_rect.texture = _campaign.scenario_bg
	else:
		push_warning("MissionSelect: Failed to load map: %s" % _campaign.scenario_bg)

	_scenarios = ContentDB.list_scenarios_for_campaign(_campaign.id)
	if _scenarios.is_empty():
		push_warning("MissionSelect: Campaign has no missions.")

## Create pins and position them (normalized coords).
func _build_pins() -> void:
	_clear_children(_pins_layer)
	for m in _scenarios:
		var pin := _make_pin(m)
		pin.set_meta("pos_norm", m.map_position)
		pin.set_meta("title", m.title)
		pin.pressed.connect(func(): _on_pin_pressed(m, pin))
		_pins_layer.add_child(pin)
	_update_pin_positions()

## Builds a pin control.
func _make_pin(m: ScenarioData) -> BaseButton:
	var title: String = m.title
	if pin_texture:
		var t := TextureButton.new()
		t.texture_normal = pin_texture
		t.expand = true
		t.ignore_texture_size = true
		t.custom_minimum_size = Vector2(pin_size)
		t.focus_mode = Control.FOCUS_NONE
		_attach_pin_label(t, title)
		return t
	else:
		var b := Button.new()
		b.text = "●"
		b.flat = true
		b.custom_minimum_size = Vector2(pin_size)
		b.focus_mode = Control.FOCUS_NONE
		b.add_theme_font_size_override("font_size", pin_size.y)
		_apply_transparent_button_style(b)
		_attach_pin_label(b, title)
		return b

## Remove all button styleboxes so only icon/text remains.
func _apply_transparent_button_style(btn: Button) -> void:
	var empty := StyleBoxEmpty.new()
	btn.add_theme_stylebox_override("normal", empty)
	btn.add_theme_stylebox_override("hover", empty)
	btn.add_theme_stylebox_override("pressed", empty)
	btn.add_theme_stylebox_override("disabled", empty)
	btn.add_theme_stylebox_override("focus", empty)

## Create and attach a readable label to a pin button.
func _attach_pin_label(pin_btn: BaseButton, title: String) -> void:
	# Remove old label (if any) to avoid duplicates when rebuilding pins.
	if pin_btn.has_node("PinLabel"):
		pin_btn.get_node("PinLabel").queue_free()

	if not show_pin_labels or title.strip_edges() == "":
		return

	var panel := PanelContainer.new()
	panel.name = "PinLabel"
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.z_index = 1
	panel.position = pin_label_offset
	panel.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	panel.size_flags_vertical = Control.SIZE_SHRINK_BEGIN

	var sb := StyleBoxFlat.new()
	sb.bg_color = pin_label_bg_color
	sb.corner_radius_top_left = pin_label_corner_radius
	sb.corner_radius_top_right = pin_label_corner_radius
	sb.corner_radius_bottom_left = pin_label_corner_radius
	sb.corner_radius_bottom_right = pin_label_corner_radius
	sb.content_margin_left = pin_label_padding.x
	sb.content_margin_right = pin_label_padding.x
	sb.content_margin_top = pin_label_padding.y
	sb.content_margin_bottom = pin_label_padding.y
	panel.add_theme_stylebox_override("panel", sb)

	var lab := Label.new()
	lab.text = title
	lab.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lab.autowrap_mode = TextServer.AUTOWRAP_OFF
	lab.clip_text = false
	lab.custom_minimum_size = Vector2.ZERO
	lab.add_theme_font_size_override("font_size", pin_label_font_size)
	lab.add_theme_color_override("font_color", pin_label_text_color)

	panel.add_child(lab)
	pin_btn.add_child(panel)

## Refresh label visibility on all pins.
func _refresh_pin_labels() -> void:
	for node in _pins_layer.get_children():
		if node is BaseButton:
			if show_pin_labels:
				var title: String = node.get_meta("title", "")
				if title != "":
					_attach_pin_label(node, title)
			else:
				if node.has_node("PinLabel"):
					node.get_node("PinLabel").queue_free()

## Reposition pins with letterbox awareness.
func _update_pin_positions() -> void:
	var tex := _map_rect.texture
	if tex == null: return
	var tex_size: Vector2 = tex.get_size()
	if tex_size == Vector2.ZERO: return

	var rect_size: Vector2 = _map_rect.size
	var pin_scale: float = min(rect_size.x / tex_size.x, rect_size.y / tex_size.y)
	var drawn_size: Vector2 = tex_size * pin_scale
	var offset: Vector2 = (rect_size - drawn_size) * 0.5

	for node in _pins_layer.get_children():
		if not (node is Control) or not node.has_meta("pos_norm"):
			continue
		var p: Vector2 = node.get_meta("pos_norm", Vector2.ZERO)
		var px := offset + Vector2(p.x * drawn_size.x, p.y * drawn_size.y) - Vector2(pin_size) * 0.5
		(node as Control).position = px

	if _card.visible and is_instance_valid(_card_pin_button):
		_position_card_near_pin(_card_pin_button)

## Open the mission card; create/remove image node depending on presence.
func _on_pin_pressed(mission: ScenarioData, pin_btn: BaseButton) -> void:
	_selected_mission = mission
	_card_pin_button = pin_btn
	_card_title.text = mission.title

	_card_image.texture = mission.preview

	_card_desc.text = mission.description
	_card_diff.text = "Difficulty: %s" % [mission.difficulty]
	
	# BUG Unhiding card removes theme
	_card.visible = true
	_click_catcher.visible = true
	_card.reset_size()
	show_pin_labels = false
	_refresh_pin_labels()
	
	call_deferred("_position_card_near_pin", pin_btn)

## Start current mission.
func _on_start_pressed() -> void:
	Game.select_scenario(_selected_mission)
	Game.goto_scene(SCENE_BRIEFING)

## Return to campaign select.
func _on_back_pressed() -> void:
	Game.goto_scene(SCENE_CAMPAIGN_SELECT)

## Decide if an overlay click should close the card.
func _on_backdrop_gui_input(event: InputEvent) -> void:
	if not _card.visible: return
	var mb := event as InputEventMouseButton
	if mb and mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
		var pt: Vector2 = mb.position
		if _card.get_global_rect().has_point(pt):
			return
		_close_card()

## True if the viewport point lies over any mission pin.
func _point_over_any_pin(view_pt: Vector2) -> bool:
	for node in _pins_layer.get_children():
		if node is Control and (node as Control).get_global_rect().has_point(view_pt):
			return true
	return false

## Place the card near a pin and keep it on-screen.
func _position_card_near_pin(pin_btn: BaseButton) -> void:
	var pin_center_global := pin_btn.global_position + pin_btn.size * 0.5

	var container_inv := _container.get_global_transform_with_canvas().affine_inverse()
	var anchor: Vector2 = container_inv * pin_center_global

	var gap := 12.0

	var card_size := _card.size
	if card_size == Vector2.ZERO:
		card_size = _card.get_combined_minimum_size()

	var bg_size := _container.size
	var pos := anchor + Vector2(gap, -card_size.y * 0.5)

	# Flip if overflowing right
	if pos.x + card_size.x > bg_size.x:
		pos.x = anchor.x - gap - card_size.x
	# Clamp to container
	pos.x = clampf(pos.x, 0.0, max(0.0, bg_size.x - card_size.x))
	pos.y = clampf(pos.y, 0.0, max(0.0, bg_size.y - card_size.y))

	# Absolute positioning inside the container
	_card.anchor_left = 0.0
	_card.anchor_top = 0.0
	_card.anchor_right = 0.0
	_card.anchor_bottom = 0.0
	_card.position = pos

## Hide card and clear selection.
func _close_card() -> void:
	_card.visible = false
	_click_catcher.visible = false
	show_pin_labels = true
	_refresh_pin_labels()
	_selected_mission = null
	_card_pin_button = null

## Remove all children from a node.
func _clear_children(node: Node) -> void:
	for c in node.get_children():
		node.remove_child(c)
		c.queue_free()
