extends Node
## Unit Management screen controller. Integrates ReinforcementPanel with unit list.
## This scene expects a Game singleton with current_scenario and an integer
## Game.campaign_replacement_pool for the shared personnel pool.
## When the player commits a plan, this applies the allocations to UnitData
## and emits unit_strength_changed for each modified unit.

signal unit_strength_changed(unit_id: String, current: int, status: String)

@onready var _list: ItemList = %UnitList
@onready var _panel: ReinforcementPanel = %ReinforcementPanel
@onready var _btn_refresh: Button = $"Root/Left/Buttons/RefreshBtn"

var _units: Array[UnitData] = []
var _uid_to_index: Dictionary = {}  # { uid: idx }

func _ready() -> void:
	_btn_refresh.pressed.connect(_refresh_from_game)
	_panel.reinforcement_preview_changed.connect(_on_preview_changed)
	_panel.reinforcement_committed.connect(_on_committed)
	_refresh_from_game()

func _refresh_from_game() -> void:
	_units = _collect_units_from_game()
	_uid_to_index.clear()
	_list.clear()
	for i in _units.size():
		var u := _units[i]
		_uid_to_index[u.id] = i
		var cur: int = int(round(u.state_strength))
		var cap: int = int(max(1, u.strength))
		var pct := int(round((float(cur) / float(cap)) * 100.0)) if cur > 0 else 0
		_list.add_item("%s  (%d/%d, %d%%)" % [u.title, cur, cap, pct])
	_panel.set_units(_units)
	_panel.set_pool(_get_pool())

func _collect_units_from_game() -> Array[UnitData]:
	var out: Array[UnitData] = []
	if Engine.has_singleton("Game"):
		pass
	# Autoload singleton
	var g = get_tree().get_root().get_node_or_null("/root/Game")
	if g and g.has_method("get_current_units"):
		var tmp = g.call("get_current_units")
		for su in tmp:
			if su is ScenarioUnit:
				if su.unit is UnitData:
					out.append(su.unit)
			elif su is UnitData:
				out.append(su)
	elif Game and Game.current_scenario:
		# Fallback to scenario units list
		for su in Game.current_scenario.units:
			if su and su.unit:
				out.append(su.unit)
	return out

func _get_pool() -> int:
	# This will be wired to persistence later
	if Game and Game.has_method("get_replacement_pool"):
		return int(Game.call("get_replacement_pool"))
	if Game and Game.has_variable("campaign_replacement_pool"):
		return int(Game.campaign_replacement_pool)
	return 0

func _set_pool(v: int) -> void:
	if Game and Game.has_method("set_replacement_pool"):
		Game.call("set_replacement_pool", v)
	elif Game and Game.has_variable("campaign_replacement_pool"):
		Game.campaign_replacement_pool = v

func _on_preview_changed(unit_id: String, amt: int) -> void:
	# hook for live updates if needed
	pass

func _on_committed(plan: Dictionary) -> void:
	var remaining := _get_pool()
	for uid in plan.keys():
		var add := int(plan[uid])
		var u := _find_unit(uid)
		if u == null:
			continue
		var cur: int = int(round(u.state_strength))
		var cap: int = int(max(0, u.strength))
		var missing: int = max(0, cap - cur)
		var give : float = min(add, missing, remaining)
		if give <= 0:
			continue
		u.state_strength = float(cur + give)
		remaining -= give
		var status := _status_string(u)
		emit_signal("unit_strength_changed", uid, int(round(u.state_strength)), status)

	_set_pool(remaining)
	_refresh_from_game()  # reflect updated numbers

func _find_unit(uid: String) -> UnitData:
	for u in _units:
		if u and u.id == uid:
			return u
	return null

func _status_string(u: UnitData) -> String:
	if u.state_strength <= 0.5:
		return "WIPED_OUT"
	var cap: float = float(max(1, u.strength))
	var pct: float = clamp(u.state_strength / cap, 0.0, 1.0)
	if pct < _panel.understrength_threshold:
		return "UNDERSTRENGTH"
	return "ACTIVE"
