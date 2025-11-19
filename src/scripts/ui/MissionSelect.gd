extends Control
## Mission Select controller
##
## Shows campaign map, mission pins, and a details card.

## Path to campaign select scene
const SCENE_CAMPAIGN_SELECT := "res://scenes/campaign_select.tscn"

## Path to unit select scene
const SCENE_BRIEFING := "res://scenes/briefing.tscn"

## Size of each mission pin in pixels.
@export var pin_size := Vector2i(24, 24)
## Optional custom pin icon; if empty, a text-dot button is used.
@export var pin_texture: Texture2D
## Show title tooltip for pins.
@export var show_pin_tooltips := true

var _selected_mission: ScenarioData
var _campaign: CampaignData
var _scenarios: Array[ScenarioData] = []
var _card_pin_button: BaseButton
var _mission_locked: Dictionary = {}  ## scenario_id -> bool

@onready var _container: OCMenuContainer = $"Container"
@onready var _btn_back: OCMenuButton = $"BackToCampaign"
@onready var _map_rect: TextureRect = $"Container/Map"
@onready var _pins_layer: Control = $"Container/PinsLayer"

@onready var _card: OCMenuContainer = %MissionCard
@onready var _card_title: Label = %CardTitle
@onready var _card_desc: RichTextLabel = %CardDesc
@onready var _card_image: TextureRect = %CardImage
@onready var _card_diff: Label = %CardDifficulty
@onready var _card_start: OCMenuButton = %CardStartMission
@onready var _card_close: OCMenuButton = %CardClose
@onready var _click_catcher: Control = $"Container/ClickCatcher"


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
	if not _card_close.pressed.is_connected(_close_card):
		_card_close.pressed.connect(_close_card)


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
	_update_mission_locked_states()

	for m in _scenarios:
		var pin := _make_pin(m)
		pin.set_meta("pos_norm", m.map_position)
		pin.set_meta("title", m.title)
		pin.pressed.connect(func(): _on_pin_pressed(m, pin))

		# Disable locked missions
		var is_locked: bool = _mission_locked.get(m.id, false)
		pin.disabled = is_locked

		# Visual feedback for locked missions
		if is_locked:
			pin.modulate = Color(0.5, 0.5, 0.5, 0.7)
			if show_pin_tooltips:
				if pin is Button:
					pin.tooltip_text = m.title + " (Locked)"
				elif pin is TextureButton:
					pin.tooltip_text = m.title + " (Locked)"

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
		if show_pin_tooltips:
			t.tooltip_text = title
		return t
	else:
		var b := Button.new()
		b.text = "●"
		b.flat = true
		b.custom_minimum_size = Vector2(pin_size)
		b.focus_mode = Control.FOCUS_NONE
		b.add_theme_font_size_override("font_size", pin_size.y)
		_apply_transparent_button_style(b)
		if show_pin_tooltips:
			b.tooltip_text = title
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
	if tex == null:
		return
	var tex_size: Vector2 = tex.get_size()
	if tex_size == Vector2.ZERO:
		return

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


## Open the mission card; create/remove image node depending on presence.
func _on_pin_pressed(mission: ScenarioData, pin_btn: BaseButton) -> void:
	_selected_mission = mission
	_card_pin_button = pin_btn

	var is_locked: bool = _mission_locked.get(mission.id, false)

	_card_title.text = mission.title + (" [LOCKED]" if is_locked else "")
	_card_image.texture = mission.preview
	_card_desc.text = mission.description
	_card_diff.text = (
		"Difficulty: %s" % [ScenarioData.ScenarioDifficulty.keys()[mission.difficulty]]
	)

	# Disable start button if mission is locked
	_card_start.disabled = is_locked
	if is_locked:
		_card_start.text = "Locked - Complete previous missions"
	else:
		_card_start.text = "Start Mission"

	_card.visible = false
	_click_catcher.visible = false

	_card.visible = true
	_click_catcher.visible = true


## Start current mission.
func _on_start_pressed() -> void:
	if not _selected_mission:
		return

	# Safety check: don't start locked missions
	if _mission_locked.get(_selected_mission.id, false):
		push_warning("Cannot start locked mission: %s" % _selected_mission.id)
		return

	Game.select_scenario(_selected_mission)
	Game.goto_scene(SCENE_BRIEFING)


## Return to campaign select.
func _on_back_pressed() -> void:
	Game.goto_scene(SCENE_CAMPAIGN_SELECT)


## Decide if an overlay click should close the card.
func _on_backdrop_gui_input(event: InputEvent) -> void:
	if not _card.visible:
		return
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


## Hide card and clear selection.
func _close_card() -> void:
	_card.visible = false
	_click_catcher.visible = false
	_selected_mission = null
	_card_pin_button = null


## Update which missions are locked based on campaign progression.
## First mission is always unlocked; subsequent missions require previous mission completion.
func _update_mission_locked_states() -> void:
	_mission_locked.clear()

	if not Game.current_save:
		# No save loaded - lock all missions except the first
		for i in range(_scenarios.size()):
			_mission_locked[_scenarios[i].id] = (i > 0)
		return

	# Check each mission's prerequisites
	for i in range(_scenarios.size()):
		var mission := _scenarios[i]

		if i == 0:
			# First mission is always unlocked
			_mission_locked[mission.id] = false
		else:
			# Check if previous mission is completed
			var prev_mission := _scenarios[i - 1]
			var is_prev_completed := Game.current_save.is_mission_completed(prev_mission.id)
			_mission_locked[mission.id] = not is_prev_completed


## Check if a mission is available to play.
func is_mission_available(mission: ScenarioData) -> bool:
	return not _mission_locked.get(mission.id, true)


## Remove all children from a node.
func _clear_children(node: Node) -> void:
	for c in node.get_children():
		node.remove_child(c)
		c.queue_free()
