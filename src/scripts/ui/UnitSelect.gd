class_name UnitSelect
extends Control
## Unit selection controller.
##
## Loads mission, builds pool and slots, handles drag/drop, points and logistics.

## Path to briefing scene
const SCENE_BRIEFING := "res://scenes/briefing.tscn"

## Path to hq table scene
const SCENE_HQ_TABLE := "res://scenes/hq_table.tscn"

## Default fallback icon for units.
@export var default_unit_icon: Texture2D
## Scene used for unit cards
@export var unit_card_scene: PackedScene

var _total_points: int = 0
var _total_slots: int = 0

var _cards_by_unit: Dictionary = {}
var _units_by_id: Dictionary = {}
var _slot_data: Dictionary = {}
var _assigned_by_unit: Dictionary = {}
var _used_points: int = 0

var _selected_card: UnitCard = null

@onready var _lbl_title: Label = %Title
@onready var _lbl_points: Label = %Points
@onready var _lbl_slots: Label = %Slots

@onready var _btn_back: Button = %Back
@onready var _btn_reset: Button = %Reset
@onready var _btn_deploy: Button = %Deploy

@onready var _filter_all: Button = %"Filters/All"
@onready var _filter_armor: Button = %"Filters/Armor"
@onready var _filter_inf: Button = %"Filters/Inf"
@onready var _filter_mech: Button = %"Filters/Mech"
@onready var _filter_motor: Button = %"Filters/Motor"
@onready var _filter_support: Button = %"Filters/Support"

@onready var _search: LineEdit = %Search
@onready var _pool: PoolDropArea = %Pool/List

@onready var _slots_list: SlotsList = %SlotsList

@onready var _lbl_ammo: Label = %Ammo
@onready var _lbl_fuel: Label = %Fuel
@onready var _lbl_med: Label = %Medical
@onready var _lbl_rep: Label = %Repair

@onready var _lbl_vet: Label = %UnitStats/Veterancy
@onready var _lbl_att: Label = %UnitStats/Attack
@onready var _lbl_def: Label = %UnitStats/Defence
@onready var _lbl_spot: Label = %UnitStats/SpottingDistance
@onready var _lbl_range: Label = %UnitStats/EngagementRange
@onready var _lbl_morale: Label = %UnitStats/Morale
@onready var _lbl_speed: Label = %UnitStats/GroundSpeed
@onready var _lbl_coh: Label = %UnitStats/Cohesion


## Build UI, load mission
func _ready() -> void:
	_connect_ui()
	_load_mission()
	_refresh_topbar()
	_refresh_filters()
	_update_deploy_enabled()
	_update_logistics_labels(0, 0, 0, 0)


## Connect UI actions to methods
func _connect_ui() -> void:
	_btn_back.pressed.connect(_on_back_pressed)
	_btn_reset.pressed.connect(_on_reset_pressed)
	_btn_deploy.pressed.connect(_on_deploy_pressed)

	for b in [
		_filter_all, _filter_armor, _filter_inf, _filter_mech, _filter_motor, _filter_support
	]:
		b.toggled.connect(func(_p): _on_filter_changed(b))
	_search.text_changed.connect(_on_filter_text_changed)

	_slots_list.request_assign_drop.connect(_on_request_assign_drop)
	_slots_list.request_inspect_unit.connect(_on_request_inspect_from_tree)

	_pool.request_return_to_pool.connect(_on_request_return_to_pool)


## Load mission data into the UI
func _load_mission() -> void:
	_lbl_title.text = Game.current_scenario.title
	_total_points = Game.current_scenario.unit_points

	_build_slots()
	_build_pool()


## Build slot list from mission slot definitions
func _build_slots() -> void:
	_slot_data.clear()
	_total_slots = 0

	var defs: Array[UnitSlotData] = Game.current_scenario.unit_slots
	for def in defs:
		var title := String(def.title)
		var key := String(def.key)

		var allowed_roles: Array = def.allowed_roles
		var slot_id := key
		_slot_data[slot_id] = {
			"key": key,
			"title": title,
			"allowed_roles": allowed_roles.duplicate(),
			"index": _total_slots + 1,
			"max": defs.size(),
			"assigned": ""
		}
		_total_slots += 1

	_slots_list.build_from_slots(_slot_data)


## Build the pool of recruitable unit cards
func _build_pool() -> void:
	_cards_by_unit.clear()
	_units_by_id.clear()
	for child in _pool.get_children():
		child.queue_free()

	var units: Array[UnitData] = ContentDB.list_recruitable_units(Game.current_scenario.id)
	for u in units:
		_units_by_id[u.id] = u

		var card: UnitCard = unit_card_scene.instantiate() as UnitCard
		card.default_icon = default_unit_icon

		_pool.add_child(card)
		card.call_deferred("setup", u)

		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.unit_selected.connect(_on_card_selected)
		_cards_by_unit[u.id] = card

	_refresh_pool_filter()


## Handle filter button toggled
func _on_filter_changed(button: Button) -> void:
	for b in [
		_filter_all, _filter_armor, _filter_inf, _filter_mech, _filter_motor, _filter_support
	]:
		if b != button:
			b.set_pressed_no_signal(false)
	_refresh_pool_filter()


## Handle text search filter changed
func _on_filter_text_changed(_t: String) -> void:
	_refresh_pool_filter()


## Collect roles enabled in current filter
func _active_roles() -> PackedStringArray:
	if _filter_all.button_pressed:
		return []
	var wanted: PackedStringArray = []
	if _filter_armor.button_pressed:
		wanted.append("ARMOR")
	if _filter_inf.button_pressed:
		wanted.append("INF")
	if _filter_mech.button_pressed:
		wanted.append("MECH")
	if _filter_motor.button_pressed:
		wanted.append("MOTOR")
	if _filter_support.button_pressed:
		wanted.append("SUPPORT")
	return wanted


## Refresh pool visibility based on filter/search/assignment
func _refresh_pool_filter() -> void:
	var roles := _active_roles()
	var search := _search.text.strip_edges().to_lower()
	for unit_id in _cards_by_unit.keys():
		var card: UnitCard = _cards_by_unit[unit_id]
		if not is_instance_valid(card):
			continue
		var u: UnitData = _units_by_id[unit_id]
		var role_ok := roles.is_empty() or roles.has(u.role)
		var text_ok := (
			search.is_empty()
			or u.title.to_lower().find(search) >= 0
			or String(unit_id).to_lower().find(search) >= 0
		)
		var in_use := _assigned_by_unit.has(unit_id)
		card.visible = role_ok and text_ok and not in_use


## Reset all role filter buttons
func _refresh_filters() -> void:
	_filter_all.set_pressed_no_signal(true)
	for b in [_filter_armor, _filter_inf, _filter_mech, _filter_motor, _filter_support]:
		b.set_pressed_no_signal(false)


## Called when a slot requests to assign a unit
func _on_request_assign_drop(slot_id: String, unit: UnitData, source_slot_id: String) -> void:
	# Move from another slot if needed
	if not source_slot_id.is_empty():
		if source_slot_id == slot_id:
			return
		_unassign_slot(source_slot_id)

	_try_assign(slot_id, unit)


## Attempt to assign a unit to a slot with validation
func _try_assign(slot_id: String, unit: UnitData) -> void:
	if not _slot_data.has(slot_id):
		return
	var slot: Variant = _slot_data[slot_id]

	# Validate: empty
	if not String(slot["assigned"]).is_empty():
		_slots_list.flash_denied(slot_id)
		return

	# Validate: role
	var allowed: Array = slot["allowed_roles"]
	var role := unit.role
	if not allowed.has(role):
		_slots_list.flash_denied(slot_id)
		return

	# Validate: points
	var cost := unit.cost
	if _used_points + cost > _total_points:
		_slots_list.flash_denied(slot_id)
		return

	# Validate: unit unique
	if _assigned_by_unit.has(unit.id):
		_slots_list.flash_denied(slot_id)
		return

	# Apply
	slot["assigned"] = unit.id
	_slot_data[slot_id] = slot
	_assigned_by_unit[unit.id] = slot_id
	_used_points += cost

	# Hide card in pool
	if _cards_by_unit.has(unit.id):
		var c: UnitCard = _cards_by_unit[unit.id]
		if is_instance_valid(c):
			c.visible = false

	_slots_list.set_assignment(slot_id, unit)
	_refresh_topbar()
	_refresh_pool_filter()
	_recompute_logistics()
	_update_deploy_enabled()
	_on_card_selected(unit)


## Called when a slot unit is returned to pool
func _on_request_return_to_pool(slot_id: String, _unit: UnitData) -> void:
	_unassign_slot(slot_id)


## Unassign a unit from the given slot
func _unassign_slot(slot_id: String) -> void:
	if not _slot_data.has(slot_id):
		return
	var slot: Variant = _slot_data[slot_id]
	var unit_id: StringName = slot["assigned"]
	if unit_id.is_empty():
		return

	# Refund points
	var u: UnitData = _units_by_id[unit_id]
	_used_points -= int(u.cost)
	_used_points = max(_used_points, 0)

	# Clear maps
	_assigned_by_unit.erase(unit_id)
	slot["assigned"] = ""
	_slot_data[slot_id] = slot

	# Show card back in pool
	if _cards_by_unit.has(unit_id):
		var c: UnitCard = _cards_by_unit[unit_id]
		if is_instance_valid(c):
			c.visible = true

	_slots_list.clear_assignment(slot_id)
	_refresh_topbar()
	_refresh_pool_filter()
	_recompute_logistics()
	_update_deploy_enabled()


## Update topbar with used slots and points
func _refresh_topbar() -> void:
	var used_slots := _assigned_by_unit.size()
	_lbl_slots.text = "Slots %d/%d" % [used_slots, _total_slots]
	_lbl_points.text = "Points: %d/%d" % [_total_points - _used_points, _total_points]


## Recalculate logistics totals from assigned units
func _recompute_logistics() -> void:
	var equipment := 0
	var fuel := 0
	var medical := 0
	var repair := 0

	for unit_id in _assigned_by_unit.keys():
		var u: UnitData = _units_by_id[unit_id]
		var thr: Dictionary = u.throughput

		if thr.has("equipment"):
			equipment += int(thr["equipment"])
		if thr.has("fuel"):
			fuel += int(thr["fuel"])
		if thr.has("medical"):
			medical += int(thr["medical"])
		if thr.has("repair"):
			repair += int(thr["repair"])

	_update_logistics_labels(equipment, fuel, medical, repair)


## Update logistics labels with current totals
func _update_logistics_labels(equipment: int, fuel: int, medical: int, repair: int) -> void:
	_lbl_ammo.text = "Equipment: %d" % equipment
	_lbl_fuel.text = "Fuel: %d" % fuel
	_lbl_med.text = "Medical: %d" % medical
	_lbl_rep.text = "Repair: %d" % repair


## Handle card clicked in pool
func _on_card_selected(unit: UnitData) -> void:
	_show_unit_stats(unit)
	_update_card_selection(unit)


## Highlight the selected card in the pool
func _update_card_selection(unit: UnitData) -> void:
	if _selected_card and is_instance_valid(_selected_card):
		_selected_card.set_selected(false)

	if _cards_by_unit.has(unit.id):
		var c: UnitCard = _cards_by_unit[unit.id]
		if is_instance_valid(c) and c.visible:
			_selected_card = c
			_selected_card.set_selected(true)


## Inspect unit from slot list and show stats
func _on_request_inspect_from_tree(unit: UnitData) -> void:
	_show_unit_stats(unit)
	_update_card_selection(unit)


## Update stats panel with selected unit data
func _show_unit_stats(unit: UnitData) -> void:
	_lbl_vet.text = "Veterancy: %d" % unit.experience
	_lbl_att.text = "Attack: %d" % unit.attack
	_lbl_def.text = "Defence: %d" % unit.defense
	_lbl_spot.text = "Spotting Distance: %dm" % unit.spot_m
	_lbl_range.text = "Engagement Range: %dm" % unit.range_m
	_lbl_morale.text = "Morale: %d%%" % unit.morale
	_lbl_speed.text = "Ground Speed: %dkm/h" % unit.speed_kph
	_lbl_coh.text = "Cohesion: %d%%" % unit.cohesion


## Go back to briefing scene
func _on_back_pressed() -> void:
	Game.goto_scene(SCENE_BRIEFING)


## Reset all slots to empty
func _on_reset_pressed() -> void:
	var to_clear := _slot_data.keys()
	for sid in to_clear:
		_unassign_slot(sid)


## Deploy current loadout if slots are filled
func _on_deploy_pressed() -> void:
	# Only when all slots filled
	if _assigned_by_unit.size() != _total_slots:
		return
	var loadout := _export_loadout()
	Game.set_scenario_loadout(loadout)
	Game.goto_scene(SCENE_HQ_TABLE)


## Enable/disable deploy button based on slot fill
func _update_deploy_enabled() -> void:
	_btn_deploy.disabled = _assigned_by_unit.size() != _total_slots


## Export current mission loadout as dictionary
func _export_loadout() -> Dictionary:
	## Returns { mission_id, points_used, assignments: [{slot_id, unit_id}] }
	var arr: Array = []
	for sid: String in _slot_data.keys():
		var unit_id: StringName = _slot_data[sid]["assigned"]
		arr.append({"slot_id": sid, "slot_key": _slot_data[sid]["key"], "unit_id": String(unit_id)})
	return {"mission_id": Game.current_scenario.id, "points_used": _used_points, "assignments": arr}
