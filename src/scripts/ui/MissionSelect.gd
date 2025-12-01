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

@export_group("Pin Sounds")
## Sound to play when hovering over a pin
@export var pin_hover_sounds: Array[AudioStream] = [
	preload("res://audio/ui/sfx_ui_button_hover_01.wav"),
	preload("res://audio/ui/sfx_ui_button_hover_02.wav")
]
## Sound to play when clicking a pin
@export
var pin_click_sounds: Array[AudioStream] = [preload("res://audio/ui/sfx_ui_button_click_01.wav")]

var _selected_mission: ScenarioData
var _campaign: CampaignData
var _scenarios: Array[ScenarioData] = []
var _card_pin_button: BaseButton
var _mission_locked: Dictionary = {}

var _pin_centers_by_id: Dictionary = {}

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
	if not _pins_layer.draw.is_connected(_on_pins_layer_draw):
		_pins_layer.draw.connect(_on_pins_layer_draw)


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
		var is_locked: bool = _mission_locked.get(m.id, false)
		if is_locked:
			continue
		var pin := _make_pin(m)
		pin.set_meta("pos_norm", m.map_position)
		pin.set_meta("title", m.title)
		pin.set_meta("scenario_id", m.id)
		pin.pressed.connect(func(): _on_pin_pressed(m, pin))
		pin.mouse_entered.connect(_on_pin_mouse_entered.bind(pin))
		pin.mouse_exited.connect(_on_pin_mouse_exited.bind(pin))

		_pins_layer.add_child(pin)
	_update_pin_positions()
	_update_pin_highlight()


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

	_pin_centers_by_id.clear()

	for node in _pins_layer.get_children():
		if not (node is Control) or not node.has_meta("pos_norm"):
			continue

		var p: Vector2 = node.get_meta("pos_norm", Vector2.ZERO)
		var center: Vector2 = offset + Vector2(p.x * drawn_size.x, p.y * drawn_size.y)
		var px: Vector2 = center - Vector2(pin_size.x, pin_size.y * 1.6) * 0.5
		var ctrl := node as Control
		ctrl.position = px

		if node.has_meta("scenario_id"):
			var mission_id: String = node.get_meta("scenario_id", "")
			if typeof(mission_id) == TYPE_STRING and mission_id != "":
				_pin_centers_by_id[mission_id] = center

	_pins_layer.queue_redraw()


## Highlight latest unlocked mission pin and fade previous ones.
func _update_pin_highlight() -> void:
	if _scenarios.is_empty():
		return

	var last_unlocked_idx := -1
	for i in range(_scenarios.size()):
		var m := _scenarios[i]
		if not _mission_locked.get(m.id, false):
			last_unlocked_idx = i

	if last_unlocked_idx == -1:
		return

	var last_unlocked_id: String = _scenarios[last_unlocked_idx].id

	for node in _pins_layer.get_children():
		if not (node is Control) or not node.has_meta("scenario_id"):
			continue

		var ctrl := node as Control
		var mission_id: String = ctrl.get_meta("scenario_id", "")

		if mission_id == last_unlocked_id:
			ctrl.set_meta("highlight_state", "current")
			ctrl.modulate = Color(1.0, 1.0, 1.0, 0.5)
		else:
			ctrl.set_meta("highlight_state", "dim")
			ctrl.modulate = Color(1.0, 1.0, 1.0, 1.0)


## Temporarily restore full alpha while hovering a pin.
func _on_pin_mouse_entered(pin: Control) -> void:
	var c := pin.modulate
	c.a = 1.0
	pin.modulate = c

	if pin_hover_sounds.size() > 0:
		AudioManager.play_random_ui_sound(pin_hover_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1))


## Restore highlight alpha when mouse leaves.
func _on_pin_mouse_exited(pin: Control) -> void:
	var state := str(pin.get_meta("highlight_state", "dim"))

	if state == "current":
		pin.modulate = Color(1.0, 1.0, 1.0, 0.5)
	else:
		pin.modulate = Color(1.0, 1.0, 1.0, 1.0)


## Open the mission card; create/remove image node depending on presence.
func _on_pin_pressed(mission: ScenarioData, pin_btn: BaseButton) -> void:
	if pin_click_sounds.size() > 0:
		AudioManager.play_random_ui_sound(pin_click_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1))

	_selected_mission = mission
	_card_pin_button = pin_btn

	var is_locked: bool = _mission_locked.get(mission.id, false)

	_card_title.text = mission.title + (" [LOCKED]" if is_locked else "")
	_card_image.texture = mission.preview
	_card_desc.text = mission.description
	_card_diff.text = (
		"Difficulty: %s" % [ScenarioData.ScenarioDifficulty.keys()[mission.difficulty]]
	)

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
		for i in range(_scenarios.size()):
			_mission_locked[_scenarios[i].id] = (i > 0)
		return

	for i in range(_scenarios.size()):
		var mission := _scenarios[i]

		if i == 0:
			_mission_locked[mission.id] = false
		else:
			var prev_mission := _scenarios[i - 1]
			var is_prev_completed := Game.current_save.is_mission_completed(prev_mission.id)
			_mission_locked[mission.id] = not is_prev_completed


## Check if a mission is available to play.
func is_mission_available(mission: ScenarioData) -> bool:
	return not _mission_locked.get(mission.id, true)


## Draw mission path between pins in campaign order.
func _on_pins_layer_draw() -> void:
	if _scenarios.size() < 2:
		return

	var color_to_unplayed := Color(1.0, 1.0, 1.0, 0.5)
	var color_default := Color(1.0, 1.0, 1.0, 1.0)
	var width := 1.0
	var antialias := true
	var gap: float = float(pin_size.x) * 0.4

	var latest_unplayed_idx := -1
	if Game.current_save:
		for i in range(_scenarios.size()):
			var m := _scenarios[i]
			if not Game.current_save.is_mission_completed(m.id):
				latest_unplayed_idx = i
				break

	if latest_unplayed_idx == -1:
		latest_unplayed_idx = _scenarios.size()

	for i in range(_scenarios.size() - 1):
		var from_mission := _scenarios[i]
		var to_mission := _scenarios[i + 1]

		if not _pin_centers_by_id.has(from_mission.id) or not _pin_centers_by_id.has(to_mission.id):
			continue

		var from_center: Vector2 = _pin_centers_by_id[from_mission.id]
		var to_center: Vector2 = _pin_centers_by_id[to_mission.id]

		var segment: Vector2 = to_center - from_center
		var length := segment.length()
		if length <= gap * 2.0:
			continue

		var dir: Vector2 = segment / length
		var from_pt: Vector2 = from_center + dir * gap
		var to_pt: Vector2 = to_center - dir * gap

		var to_idx := i + 1
		var is_to_unplayed := to_idx == latest_unplayed_idx
		var color := color_to_unplayed if is_to_unplayed else color_default

		_pins_layer.draw_line(from_pt, to_pt, color, width, antialias)


## Remove all children from a node.
func _clear_children(node: Node) -> void:
	for c in node.get_children():
		node.remove_child(c)
		c.queue_free()
