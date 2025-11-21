class_name UnitSelect
extends Control
## Unit selection controller.
##
## Loads mission, builds pool and slots, handles drag/drop, points and logistics.

## Path to briefing scene
const SCENE_BRIEFING := "res://scenes/briefing.tscn"

## Path to hq table scene
const SCENE_HQ_TABLE := "res://scenes/hq_table.tscn"

## ReinforcementPanel scene
const REINFORCEMENT_PANEL_SCENE := preload("res://scenes/ui/unit_mgmt/reinforcement_panel.tscn")

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
var _selected_unit_for_supply: UnitData = null
var _current_equipment_pool: int = 0
var _current_ammo_pools: Dictionary = {}
var _reinforcement_panel: ReinforcementPanel = null

## Pending resupply changes (staged before commit)
var _pending_equipment: int = 0  # Target equipment percentage
var _pending_ammo: Dictionary = {}  # ammo_type -> target amount

## Original state tracking (for reset to undo all changes) - per unit
var _original_equipment: Dictionary = {}  # unit_id -> int (equipment %)
var _original_ammo: Dictionary = {}  # unit_id -> { ammo_type -> amount }
var _original_equipment_pool: Dictionary = {}  # unit_id -> int (pool at time of selection)
var _original_ammo_pools: Dictionary = {}  # unit_id -> { ammo_type -> amount }

## Temporary ScenarioUnit instances for state management during loadout configuration
var _temp_scenario_units: Dictionary = {}  # unit_id -> ScenarioUnit

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

@onready var _supply_vbox: VBoxContainer = %Supply
@onready var _replacements_vbox: VBoxContainer = %Replacements


## Build UI, load mission
func _ready() -> void:
	_connect_ui()
	_load_mission()
	_refresh_topbar()
	_refresh_filters()
	_update_deploy_enabled()
	_update_logistics_labels(0, 0, 0, 0)
	_init_supply_pools()


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
		# Restore experience from campaign save if available
		if Game.current_save:
			var saved_state := Game.current_save.get_unit_state(u.id)
			if not saved_state.is_empty():
				u.experience = saved_state.get("experience", u.experience)

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
	_selected_unit_for_supply = unit
	_populate_supply_ui(unit)
	_populate_replacements_ui(unit)


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
	_selected_unit_for_supply = unit
	_populate_supply_ui(unit)
	_populate_replacements_ui(unit)


## Update stats panel with selected unit data
func _show_unit_stats(unit: UnitData) -> void:
	_lbl_vet.text = "Veterancy: %d" % unit.experience
	_lbl_att.text = "Attack: %d" % unit.attack
	_lbl_def.text = "Defence: %d" % unit.defense
	_lbl_spot.text = "Spotting Distance: %dm" % unit.spot_m
	_lbl_range.text = "Engagement Range: %dm" % unit.range_m
	_lbl_morale.text = "Morale: %d%%" % (unit.morale * 100.0)
	_lbl_speed.text = "Ground Speed: %dkm/h" % unit.speed_kph
	_lbl_coh.text = "Cohesion: 100%%"  # Cohesion is per-mission state, starts at 100%


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

	# Save temp unit states back to save file
	_save_temp_unit_states()

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


## Initialize supply pools from scenario
func _init_supply_pools() -> void:
	if not Game.current_scenario:
		return

	_current_equipment_pool = Game.current_scenario.equipment_pool
	_current_ammo_pools = Game.current_scenario.ammo_pools.duplicate()


## Populate supply UI with ammo and equipment resupply options
func _populate_supply_ui(unit: UnitData, reset_pending: bool = true) -> void:
	# Clear existing children immediately
	for child in _supply_vbox.get_children():
		_supply_vbox.remove_child(child)
		child.queue_free()

	if not unit:
		return

	var scenario_unit := _get_scenario_unit_for_id(unit.id)
	if not scenario_unit:
		return

	# Sync pool values from scenario (in case they were updated)
	_current_equipment_pool = Game.current_scenario.equipment_pool
	_current_ammo_pools = Game.current_scenario.ammo_pools.duplicate()

	# Initialize pending values to current values (only if reset_pending is true)
	if reset_pending:
		_pending_equipment = int(scenario_unit.state_equipment * 100.0)
		_pending_ammo.clear()
		for ammo_type in unit.ammunition.keys():
			_pending_ammo[ammo_type] = int(scenario_unit.state_ammunition.get(ammo_type, 0))

		# Capture original state ONLY on first selection of this unit
		if not _original_equipment.has(unit.id):
			_original_equipment[unit.id] = int(scenario_unit.state_equipment * 100.0)
			var unit_ammo: Dictionary = {}
			for ammo_type in unit.ammunition.keys():
				unit_ammo[ammo_type] = int(scenario_unit.state_ammunition.get(ammo_type, 0))
			_original_ammo[unit.id] = unit_ammo
			_original_equipment_pool[unit.id] = _current_equipment_pool
			_original_ammo_pools[unit.id] = _current_ammo_pools.duplicate()
			LogService.debug(
				(
					"Captured original state for %s: equipment=%d%%, pool=%d"
					% [
						unit.id,
						int(_original_equipment[unit.id]),
						int(_original_equipment_pool[unit.id])
					]
				),
				"UnitSelect"
			)

	LogService.debug(
		(
			"Populate supply UI: pool=%d, current=%d%%, pending=%d%%"
			% [
				_current_equipment_pool,
				int(scenario_unit.state_equipment * 100.0),
				_pending_equipment
			]
		),
		"UnitSelect"
	)

	# Create ScrollContainer for supply items
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_supply_vbox.add_child(scroll)

	# Create VBoxContainer inside scroll for items
	var items_vbox := VBoxContainer.new()
	items_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(items_vbox)

	# Add equipment resupply row
	_add_equipment_row(scenario_unit, items_vbox)

	# Add ammo resupply rows for each ammo type the unit has
	for ammo_type in unit.ammunition.keys():
		var capacity: int = int(unit.ammunition.get(ammo_type, 0))
		if capacity > 0:
			_add_ammo_row(scenario_unit, ammo_type, capacity, items_vbox)

	# Add spacer
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 10)
	_supply_vbox.add_child(spacer)

	# Add commit/reset buttons row (outside scroll container)
	var button_row := HBoxContainer.new()
	button_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button_row.alignment = BoxContainer.ALIGNMENT_END
	_supply_vbox.add_child(button_row)

	var reset_btn := Button.new()
	reset_btn.text = "Reset"
	reset_btn.pressed.connect(func(): _reset_resupply_pending(unit))
	button_row.add_child(reset_btn)

	var commit_btn := Button.new()
	commit_btn.text = "Commit Resupply"
	commit_btn.pressed.connect(func(): _commit_resupply(unit))
	button_row.add_child(commit_btn)


## Add equipment resupply row
func _add_equipment_row(scenario_unit: ScenarioUnit, container: VBoxContainer) -> void:
	var current_pct := int(scenario_unit.state_equipment * 100.0)

	# Row 1: Type, Pool, Current/Max
	var row1 := HBoxContainer.new()
	row1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.add_child(row1)

	var label := Label.new()
	label.text = "Equipment:"
	label.custom_minimum_size = Vector2(100, 0)
	row1.add_child(label)

	var pool_label := Label.new()
	pool_label.text = "Pool: %d" % _current_equipment_pool
	pool_label.custom_minimum_size = Vector2(80, 0)
	row1.add_child(pool_label)

	var current_label := Label.new()
	current_label.text = "%d%%" % current_pct
	current_label.custom_minimum_size = Vector2(60, 0)
	row1.add_child(current_label)

	# Row 2: Slider only
	var row2 := HBoxContainer.new()
	row2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.add_child(row2)

	var slider := HSlider.new()
	slider.min_value = 0.0
	slider.max_value = 100.0
	slider.step = 1.0
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(
		func(v: float) -> void:
			var target_pct := int(round(v))
			# Block slider from going below current value
			if target_pct < current_pct:
				slider.value = float(current_pct)
				return
			var cost := target_pct - current_pct
			var pool_after := _current_equipment_pool - cost
			if pool_after < 0:
				slider.value = float(current_pct + _current_equipment_pool)
				return
			# Update pending value only
			_pending_equipment = target_pct
			# Update labels to show preview
			current_label.text = "%d%%" % target_pct
			pool_label.text = "Pool: %d" % pool_after
	)
	row2.add_child(slider)
	# Set value after adding to tree to ensure it updates visually
	slider.set_value_no_signal(float(_pending_equipment))


## Add ammo resupply row
func _add_ammo_row(
	scenario_unit: ScenarioUnit, ammo_type: String, capacity: int, container: VBoxContainer
) -> void:
	var current := int(scenario_unit.state_ammunition.get(ammo_type, 0))
	var pool_available := int(_current_ammo_pools.get(ammo_type, 0))
	var pending := int(_pending_ammo.get(ammo_type, current))

	# Row 1: Type, Pool, Current/Max
	var row1 := HBoxContainer.new()
	row1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.add_child(row1)

	var label := Label.new()
	label.text = ammo_type.capitalize() + ":"
	label.custom_minimum_size = Vector2(100, 0)
	row1.add_child(label)

	var pool_label := Label.new()
	pool_label.text = "Pool: %d" % pool_available
	pool_label.custom_minimum_size = Vector2(80, 0)
	row1.add_child(pool_label)

	var current_label := Label.new()
	current_label.text = "%d/%d" % [current, capacity]
	current_label.custom_minimum_size = Vector2(60, 0)
	row1.add_child(current_label)

	# Row 2: Slider only
	var row2 := HBoxContainer.new()
	row2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.add_child(row2)

	var slider := HSlider.new()
	slider.min_value = 0.0
	slider.max_value = float(capacity)
	slider.step = 1.0
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(
		func(v: float) -> void:
			var target := int(round(v))
			# Block slider from going below current value
			if target < current:
				slider.value = float(current)
				return
			var needed := target - current
			var pool_after := pool_available - needed
			if pool_after < 0:
				slider.value = float(current + pool_available)
				return
			# Update pending value only
			_pending_ammo[ammo_type] = target
			# Update labels to show preview
			current_label.text = "%d/%d" % [target, capacity]
			pool_label.text = "Pool: %d" % pool_after
	)
	row2.add_child(slider)
	# Set value after adding to tree to ensure it updates visually
	slider.set_value_no_signal(float(pending))


## Commit pending resupply changes
func _commit_resupply(unit: UnitData) -> void:
	if not unit:
		return

	var scenario_unit := _get_scenario_unit_for_id(unit.id)
	if not scenario_unit:
		return

	var current_equipment_pct := int(scenario_unit.state_equipment * 100.0)
	var equipment_cost := _pending_equipment - current_equipment_pct

	# Apply equipment resupply
	if equipment_cost > 0:
		if _current_equipment_pool >= equipment_cost:
			_current_equipment_pool -= equipment_cost
			scenario_unit.state_equipment = clamp(float(_pending_equipment) / 100.0, 0.0, 1.0)
			Game.current_scenario.equipment_pool = _current_equipment_pool
			LogService.info(
				"Committed equipment resupply for %s: %d%%" % [unit.id, _pending_equipment],
				"UnitSelect"
			)

	# Apply ammo resupply
	for ammo_type in _pending_ammo.keys():
		var target := int(_pending_ammo[ammo_type])
		var current := int(scenario_unit.state_ammunition.get(ammo_type, 0))
		var needed := target - current

		if needed > 0:
			var pool_available := int(_current_ammo_pools.get(ammo_type, 0))
			if pool_available >= needed:
				_current_ammo_pools[ammo_type] = pool_available - needed
				scenario_unit.state_ammunition[ammo_type] = target
				LogService.info(
					(
						"Committed ammo resupply for %s %s: +%d (now %d)"
						% [unit.id, ammo_type, needed, target]
					),
					"UnitSelect"
				)

	# Update scenario ammo pools
	Game.current_scenario.ammo_pools = _current_ammo_pools.duplicate()

	# Refresh the UI with the new committed values
	_populate_supply_ui(unit, true)


## Reset pending resupply changes to original values (undo all changes including commits)
func _reset_resupply_pending(unit: UnitData) -> void:
	if not unit:
		return

	var scenario_unit := _get_scenario_unit_for_id(unit.id)
	if not scenario_unit:
		return

	# Check if we have original state for this unit
	if not _original_equipment.has(unit.id):
		LogService.warn("No original state captured for unit %s" % unit.id, "UnitSelect")
		return

	# Get this unit's original state
	var original_eq: int = int(_original_equipment.get(unit.id, 0))
	var original_ammo_dict: Dictionary = _original_ammo.get(unit.id, {})
	var original_eq_pool: int = int(_original_equipment_pool.get(unit.id, 0))
	var original_ammo_pool_dict: Dictionary = _original_ammo_pools.get(unit.id, {})

	# Restore scenario unit to original state
	scenario_unit.state_equipment = float(original_eq) / 100.0
	for ammo_type in original_ammo_dict.keys():
		scenario_unit.state_ammunition[ammo_type] = original_ammo_dict[ammo_type]

	# Restore pools to original state
	_current_equipment_pool = original_eq_pool
	_current_ammo_pools = original_ammo_pool_dict.duplicate()
	Game.current_scenario.equipment_pool = original_eq_pool
	Game.current_scenario.ammo_pools = original_ammo_pool_dict.duplicate()

	# Reset pending values to original values
	_pending_equipment = original_eq
	_pending_ammo = original_ammo_dict.duplicate()

	LogService.info(
		(
			"Reset resupply to original for %s: equipment=%d%%, pool=%d"
			% [unit.id, original_eq, original_eq_pool]
		),
		"UnitSelect"
	)

	# Refresh UI to show original state
	_populate_supply_ui(unit, false)


## Populate replacements UI with ReinforcementPanel
func _populate_replacements_ui(unit: UnitData) -> void:
	if not unit:
		# Clear all children when no unit selected
		for child in _replacements_vbox.get_children():
			child.queue_free()
		return

	var scenario_unit := _get_scenario_unit_for_id(unit.id)
	if not scenario_unit:
		# Clear all children when no scenario unit found
		for child in _replacements_vbox.get_children():
			child.queue_free()
		return

	# Instantiate ReinforcementPanel if needed
	if not _reinforcement_panel:
		_reinforcement_panel = REINFORCEMENT_PANEL_SCENE.instantiate() as ReinforcementPanel
		_reinforcement_panel.reinforcement_committed.connect(_on_reinforcement_committed)

	# Add to replacements vbox if not already added
	if _reinforcement_panel.get_parent() != _replacements_vbox:
		if _reinforcement_panel.get_parent():
			_reinforcement_panel.get_parent().remove_child(_reinforcement_panel)
		_replacements_vbox.add_child(_reinforcement_panel)

	# Get unit strength from scenario unit
	var unit_strengths: Dictionary[String, float] = {}
	unit_strengths[unit.id] = scenario_unit.state_strength

	# Set up panel with single unit
	_reinforcement_panel.set_units([unit], unit_strengths)
	_reinforcement_panel.set_pool(Game.current_scenario.replacement_pool)
	_reinforcement_panel.reset_pending()


## Handle reinforcement committed
func _on_reinforcement_committed(plan: Dictionary) -> void:
	var remaining_pool: int = Game.current_scenario.replacement_pool

	for unit_id in plan.keys():
		var add := int(plan[unit_id])
		var unit := _units_by_id.get(unit_id) as UnitData
		if not unit:
			continue

		var scenario_unit := _get_scenario_unit_for_id(unit_id)
		if not scenario_unit:
			continue

		# Don't reinforce wiped out units
		if scenario_unit.state_strength <= 0.0:
			continue

		var current := int(scenario_unit.state_strength)
		var capacity := int(unit.strength)
		var missing: int = max(0, capacity - current)
		var actual: int = min(add, missing, remaining_pool)

		if actual > 0:
			scenario_unit.state_strength += float(actual)
			remaining_pool -= actual
			LogService.info(
				(
					"Reinforced %s: +%d personnel (now %d/%d)"
					% [unit_id, actual, int(scenario_unit.state_strength), capacity]
				),
				"UnitSelect"
			)

	# Update pool
	Game.current_scenario.replacement_pool = remaining_pool

	# Refresh UI
	if _selected_unit_for_supply:
		_populate_replacements_ui(_selected_unit_for_supply)


## Get or create temporary ScenarioUnit for a unit ID
func _get_scenario_unit_for_id(unit_id: String) -> ScenarioUnit:
	# Check if we already have a temp instance
	if _temp_scenario_units.has(unit_id):
		return _temp_scenario_units[unit_id]

	# Check scenario.units (pre-placed units)
	if Game.current_scenario:
		for su in Game.current_scenario.units:
			if su and su.unit and su.unit.id == unit_id:
				return su

	# Create temporary ScenarioUnit for recruitable unit
	var unit := _units_by_id.get(unit_id) as UnitData
	if not unit:
		return null

	var su := ScenarioUnit.new()
	su.unit = unit
	su.affiliation = ScenarioUnit.Affiliation.FRIEND

	# Initialize with saved state if available, otherwise use defaults
	if Game.current_save:
		var saved_state := Game.current_save.get_unit_state(unit_id)
		if not saved_state.is_empty():
			su.state_strength = saved_state.get("state_strength", unit.strength)
			su.state_injured = saved_state.get("state_injured", 0.0)
			su.state_equipment = saved_state.get("state_equipment", 1.0)
			su.cohesion = saved_state.get("cohesion", 1.0)
			unit.experience = saved_state.get("experience", unit.experience)
			var saved_ammo = saved_state.get("state_ammunition", {})
			if saved_ammo is Dictionary and not saved_ammo.is_empty():
				su.state_ammunition = saved_ammo.duplicate()
			else:
				su.state_ammunition = unit.ammunition.duplicate()
		else:
			# No saved state, use template defaults
			su.state_strength = unit.strength
			su.state_injured = 0.0
			su.state_equipment = 1.0
			su.cohesion = 1.0
			su.state_ammunition = unit.ammunition.duplicate()
	else:
		# No save, use template defaults
		su.state_strength = unit.strength
		su.state_injured = 0.0
		su.state_equipment = 1.0
		su.cohesion = 1.0
		su.state_ammunition = unit.ammunition.duplicate()

	_temp_scenario_units[unit_id] = su
	return su


## Save temporary unit states back to campaign save
func _save_temp_unit_states() -> void:
	if not Game.current_save:
		return

	for unit_id in _temp_scenario_units.keys():
		var su: ScenarioUnit = _temp_scenario_units[unit_id]
		if su and su.unit:
			var state := {
				"state_strength": su.state_strength,
				"state_injured": su.state_injured,
				"state_equipment": su.state_equipment,
				"cohesion": su.cohesion,
				"state_ammunition": su.state_ammunition.duplicate(),
				"experience": su.unit.experience,
			}
			Game.current_save.update_unit_state(su.unit.id, state)

	# Persist to disk
	Persistence.save_to_file(Game.current_save)
