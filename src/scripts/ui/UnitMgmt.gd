extends Control
## Unit Management screen controller. Integrates ReinforcementPanel with unit list.
## This scene expects a Game singleton with current_scenario and an integer
## Game.campaign_replacement_pool for the shared personnel pool.
## When the player commits a plan, this applies the allocations to UnitData
## and emits unit_strength_changed for each modified unit.to UnitData.

signal unit_strength_changed(unit_id: String, current: int, status: String)

@onready var _list_box: VBoxContainer = %UnitListBox
@onready var _panel: ReinforcementPanel = %ReinforcementPanel
@onready var _btn_refresh: Button = $"Root/Left/Buttons/RefreshBtn"

var _units: Array[UnitData] = []
var _uid_to_index: Dictionary = {}   ## unit_id -> array index

## Scene is ready: wire signals and populate UI from Game.
func _ready() -> void:
	_btn_refresh.pressed.connect(_refresh_from_game)
	_panel.reinforcement_preview_changed.connect(_on_preview_changed)
	_panel.reinforcement_committed.connect(_on_committed)
	_refresh_from_game()

## Pull units from Game and refresh list and panel.
func _refresh_from_game() -> void:
	_units = _collect_units_from_game()
	_uid_to_index.clear()
	# rebuild list with badges
	for c in _list_box.get_children():
		c.queue_free()

	for u in _units:
		var row := HBoxContainer.new()
		_list_box.add_child(row)

		var title := Label.new()
		title.text = u.title
		row.add_child(title)

		var badge := UnitStrengthBadge.new()
		badge.set_unit(u, _panel.understrength_threshold)
		row.add_child(badge)

	# keep panel updated
	_panel.set_units(_units)
	_panel.set_pool(_get_pool())

## Return a flat array of UnitData from the current scenario or recruits.
func _collect_units_from_game() -> Array[UnitData]:
	var out: Array[UnitData] = []
	if Engine.has_singleton("Game"):
		pass
	# Autoload singleton
	var g := get_tree().get_root().get_node_or_null("/root/Game")
	if g and g.has_method("get_current_units"):
		var tmp = g.call("get_current_units")
		for su in tmp:
			if su is ScenarioUnit and su.unit:
				out.append(su.unit)
			elif su is UnitData:
				out.append(su)
	elif Game and Game.current_scenario:
		# Fallback to scenario units list
		for su in Game.current_scenario.units:
			if su and su.unit:
				out.append(su.unit)
	return out

## Read the replacement pool from Game (placeholder persistence).
func _get_pool() -> int:
	if Game and Game.has_method("get_replacement_pool"):
		return int(Game.call("get_replacement_pool"))
	if Game and Game.has_variable("campaign_replacement_pool"):
		return int(Game.campaign_replacement_pool)
	return 0

## Write the replacement pool to Game (placeholder persistence).
func _set_pool(v: int) -> void:
	if Game and Game.has_method("set_replacement_pool"):
		Game.call("set_replacement_pool", v)
	elif Game and Game.has_variable("campaign_replacement_pool"):
		Game.campaign_replacement_pool = v

## Live preview hook from panel.
func _on_preview_changed(unit_id: String, amt: int) -> void:
	pass

## Apply a committed plan: 
## clamp to capacity and pool, then signal status changes.
func _on_committed(plan: Dictionary) -> void:
	var remaining : int = _get_pool()
	for uid in plan.keys():
		var add := int(plan[uid])
		var u := _find_unit(uid)
		if u == null:
			continue

		# Authoritative gate: skip wiped-out here
		if not _can_reinforce(u):
			continue

		var cur: int = int(round(u.state_strength))
		var cap: int = int(max(0, u.strength))
		var missing: int = max(0, cap - cur)
		var give : int = min(add, missing, remaining)
		if give <= 0:
			continue

		u.state_strength = float(cur + give)
		remaining -= give
		emit_signal("unit_strength_changed", uid, int(round(u.state_strength)), _status_string(u))

	_set_pool(remaining)
	_panel.set_pool(remaining)   # keep UI in sync immediately
	_refresh_from_game()


## Find a unit by id in the cached list.
func _find_unit(uid: String) -> UnitData:
	for u in _units:
		if u and u.id == uid:
			return u
	return null

## Derive a status string for external consumers.
func _status_string(u: UnitData) -> String:
	if u.state_strength <= 0.0:
		return "WIPED_OUT"
	var cap: float = float(max(1, u.strength))
	var pct: float = clamp(u.state_strength / cap, 0.0, 1.0)
	if pct < _panel.understrength_threshold:
		return "UNDERSTRENGTH"
	return "ACTIVE"

## test if a unit can be reinforced
## this screen cannot reinforce wiped-out units
func _can_reinforce(u: UnitData) -> bool:
	return u != null and u.state_strength > 0.0
