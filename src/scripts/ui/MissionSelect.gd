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

var _selected_mission: Dictionary = {}
var _campaign: Dictionary = {}
var _missions: Array = []
var _card_pin_button: BaseButton

## Size of each mission pin in pixels.
@export var pin_size := Vector2i(24, 24)
## Optional custom pin icon; if empty, a text-dot button is used.
@export var pin_texture: Texture2D

## Path to campaign select scene
const SCENE_CAMPAIGN_SELECT := "res://scenes/campaign_select.tscn"

## Path to unit select scene
const SCENE_UNIT_SELECT := "res://scenes/unit_select.tscn"

## Build UI, load map, place pins, hook resizes.
func _ready() -> void:
	_btn_back.pressed.connect(_on_back_pressed)
	_load_campaign_and_map()
	await get_tree().process_frame
	_build_pins()

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
	var cid := Game.current_campaign_id
	_campaign = ContentDB.get_campaign(cid)
	if _campaign.is_empty():
		push_warning("MissionSelect: No current campaign set.")
		return

	var map_path: String = _campaign.get("campaign_map", "")
	if map_path == "":
		push_warning("MissionSelect: Campaign has no 'campaign_map'.")
	else:
		var tex := load(map_path) as Texture2D
		if tex:
			_map_rect.texture = tex
		else:
			push_warning("MissionSelect: Failed to load map: %s" % map_path)

	_missions = ContentDB.list_missions(cid)
	if _missions.is_empty():
		push_warning("MissionSelect: Campaign has no missions.")

## Create pins and position them (normalized coords).
func _build_pins() -> void:
	_clear_children(_pins_layer)
	for m in _missions:
		var pin := _make_pin(m)
		pin.set_meta("pos_norm", _mission_pos_vec(m))
		pin.pressed.connect(func(): _on_pin_pressed(m, pin))
		_pins_layer.add_child(pin)
	_update_pin_positions()

## Builds a pin control.
func _make_pin(m: Dictionary) -> BaseButton:
	if pin_texture:
		var t := TextureButton.new()
		t.texture_normal = pin_texture
		t.expand = true
		t.ignore_texture_size = true
		t.custom_minimum_size = Vector2(pin_size)
		t.focus_mode = Control.FOCUS_NONE
		t.tooltip_text = m.get("title", "")
		return t
	else:
		var b := Button.new()
		b.text = "●"
		b.flat = true
		b.custom_minimum_size = Vector2(pin_size)
		b.focus_mode = Control.FOCUS_NONE
		b.add_theme_font_size_override("font_size", pin_size.y)
		b.tooltip_text = m.get("title", "")
		_apply_transparent_button_style(b)
		return b

## Remove all button styleboxes so only icon/text remains.
func _apply_transparent_button_style(btn: Button) -> void:
	var empty := StyleBoxEmpty.new()
	btn.add_theme_stylebox_override("normal", empty)
	btn.add_theme_stylebox_override("hover", empty)
	btn.add_theme_stylebox_override("pressed", empty)
	btn.add_theme_stylebox_override("disabled", empty)
	btn.add_theme_stylebox_override("focus", empty)

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
func _on_pin_pressed(mission: Dictionary, pin_btn: BaseButton) -> void:
	# Toggle: clicking same pin closes the card
	if _card.visible and String(_selected_mission.get("id", "")) == String(mission.get("id","")):
		_close_card()
		return

	_selected_mission = mission
	_card_pin_button = pin_btn
	_card_title.text = mission.get("title", "Untitled")

	var prev_path: String = mission.get("image", "")
	if prev_path != "":
		_ensure_card_image()
		_card_image.texture = load(prev_path) as Texture2D
	else:
		_remove_card_image()

	_card_desc.text = mission.get("description", "")
	_card_diff.text = "Difficulty: %s" % [mission.get("difficulty", "Unknown")]
	
	# BUG Unhiding card removes theme
	_card.visible = true
	_card.reset_size()

	call_deferred("_position_card_near_pin", pin_btn)

## Start current mission.
func _on_start_pressed() -> void:
	var mid: String = _selected_mission.get("id", "")
	if mid == "":
		return
	Game.select_mission(mid)
	Game.goto_scene(SCENE_UNIT_SELECT)

## Return to campaign select.
func _on_back_pressed() -> void:
	Game.goto_scene(SCENE_CAMPAIGN_SELECT)

## Close the card when clicking outside of it and not on any pin.
func _unhandled_input(event: InputEvent) -> void:
	if not _card.visible:
		return
	var mb := event as InputEventMouseButton
	if mb and mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
		var pt: Vector2 = mb.position  # viewport coords
		# If click is on the card, ignore (don't close)
		if _card.get_global_rect().has_point(pt):
			return
		# If click is on any mission pin, ignore (pin handlers will run)
		if _point_over_any_pin(pt):
			return
		_close_card()

## True if the viewport point lies over any mission pin.
func _point_over_any_pin(view_pt: Vector2) -> bool:
	for node in _pins_layer.get_children():
		if node is Control and (node as Control).get_global_rect().has_point(view_pt):
			return true
	return false

## Ensure the image TextureRect exists in the card (created just above the Desc).
func _ensure_card_image() -> void:
	if _card_image and is_instance_valid(_card_image):
		return
	var v := _card.get_node("V") as VBoxContainer
	_card_image = TextureRect.new()
	_card_image.name = "Image"
	_card_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_card_image.custom_minimum_size = Vector2(340, 160)
	v.add_child(_card_image)
	v.move_child(_card_image, 1)  # after Title

## Remove the image control if present.
func _remove_card_image() -> void:
	if _card_image and is_instance_valid(_card_image):
		_card_image.queue_free()
	_card_image = null

## Place the card near a pin and keep it on-screen.
func _position_card_near_pin(pin_btn: BaseButton) -> void:
	# Center of the pin in GLOBAL space
	var pin_center_global := pin_btn.global_position + pin_btn.size * 0.5

	# Convert GLOBAL → _container LOCAL (Controls: use canvas-aware transform)
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
	_selected_mission = {}
	_card_pin_button = null

## Convert mission.pos from JSON-friendly formats to Vector2.
func _mission_pos_vec(m: Dictionary) -> Vector2:
	var v = m.get("pos", Vector2.ZERO)
	if v is Vector2:
		return v
	if v is Array and v.size() >= 2:
		return Vector2(float(v[0]), float(v[1]))
	if v is Dictionary:
		return Vector2(float(v.get("x", 0.0)), float(v.get("y", 0.0)))
	return Vector2.ZERO

## Remove all children from a node.
func _clear_children(node: Node) -> void:
	for c in node.get_children():
		node.remove_child(c)
		c.queue_free()
