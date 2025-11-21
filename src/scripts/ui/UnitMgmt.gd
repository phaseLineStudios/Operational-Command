extends Control
## Unit Management screen controller. Integrates ReinforcementPanel with unit list.
## This scene expects a Game singleton with current_scenario containing the
## scenario's replacement_pool for the shared personnel pool.
## When the player commits a plan, this applies the allocations to UnitData
## and emits unit_strength_changed for each modified unit.

signal unit_strength_changed(unit_id: String, current: int, status: String)

# --- regular vars first (to satisfy gdlint class-definitions-order) ---
var _units: Array[UnitData] = []
var _uid_to_index: Dictionary = {}  ## unit_id -> array index (kept for future lookups)
## Temporary: tracks current strength per unit for campaign persistence (to be replaced)
var _unit_strength: Dictionary[String, float] = {}

# --- onready vars after regular vars ---
@onready var _list_box: VBoxContainer = %UnitListBox
@onready var _panel: ReinforcementPanel = %ReinforcementPanel
@onready var _btn_refresh: Button = $"Root/Left/Buttons/RefreshBtn"


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
	_unit_strength.clear()

	# Rebuild list with title + strength badge per row
	for c in _list_box.get_children():
		c.queue_free()

	var idx := 0
	for u: UnitData in _units:
		var uid := u.id
		_uid_to_index[uid] = idx
		idx += 1

		# Initialize strength to full (campaign persistence will override this later)
		_unit_strength[uid] = float(u.strength)

		var row := HBoxContainer.new()
		_list_box.add_child(row)

		var title := Label.new()
		title.text = u.title
		row.add_child(title)

		var badge: UnitStrengthBadge = UnitStrengthBadge.new()
		var cur_strength: float = _unit_strength.get(uid, float(u.strength))
		badge.set_unit(u, cur_strength, _panel.understrength_threshold)
		row.add_child(badge)

	# Keep panel updated
	_panel.set_units(_units, _unit_strength)
	_panel.set_pool(_get_pool())


## Return a flat array of UnitData from the current scenario or recruits.
func _collect_units_from_game() -> Array[UnitData]:
	var out: Array[UnitData] = []

	# Prefer the autoload (works whether you reference 'Game' or via tree)
	var g: Node = get_tree().get_root().get_node_or_null("/root/Game")
	if g and g.has_method("get_current_units"):
		var tmp: Array = g.call("get_current_units")
		for su in tmp:
			if su is ScenarioUnit and su.unit:
				out.append(su.unit)
			elif su is UnitData:
				out.append(su)
		return out

	# Fallback: read directly from Game.current_scenario if present
	if Game and Game.current_scenario:
		for su in Game.current_scenario.units:
			if su and su.unit:
				out.append(su.unit)

	return out


## Read the replacement pool from Game scenario.
func _get_pool() -> int:
	if Game and Game.current_scenario:
		return int(Game.current_scenario.replacement_pool)
	return 0


## Write the replacement pool to Game scenario.
func _set_pool(v: int) -> void:
	if Game and Game.current_scenario:
		Game.current_scenario.replacement_pool = v


## Live preview hook from panel (visual-only here).
func _on_preview_changed(_unit_id: String, _amt: int) -> void:
	# This screen doesn't need a live preview side-effect;
	# values are applied on commit. Arguments prefixed with '_' to satisfy gdlint.
	pass


## Apply a committed plan:
## clamp to capacity and pool, then signal status changes.
func _on_committed(plan: Dictionary) -> void:
	var remaining: int = _get_pool()

	for uid in plan.keys():
		var add := int(plan[uid])
		var u: UnitData = _find_unit(uid)
		if u == null:
			continue

		# Authoritative gate: skip wiped-out units here
		if not _can_reinforce(uid):
			continue

		var cur: int = int(round(_unit_strength.get(uid, 0.0)))
		var cap: int = int(max(0, u.strength))
		var missing: int = max(0, cap - cur)
		var give: int = min(add, missing, remaining)
		if give <= 0:
			continue

		_unit_strength[uid] = float(cur + give)
		remaining -= give
		emit_signal(
			"unit_strength_changed", uid, int(round(_unit_strength[uid])), _status_string(uid)
		)

	# Persist pool and refresh UI
	_set_pool(remaining)
	_panel.set_pool(remaining)
	_refresh_from_game()


## Find a unit by id in the cached list.
func _find_unit(uid: String) -> UnitData:
	for u in _units:
		if u and u.id == uid:
			return u
	return null


## Derive a status string for external consumers.
func _status_string(uid: String) -> String:
	var cur_strength: float = _unit_strength.get(uid, 0.0)
	if cur_strength <= 0.0:
		return "WIPED_OUT"

	var u := _find_unit(uid)
	if u == null:
		return "UNKNOWN"

	var cap: float = float(max(1, u.strength))
	var pct: float = clamp(cur_strength / cap, 0.0, 1.0)
	var thr: float = (
		u.understrength_threshold
		if u.understrength_threshold > 0.0
		else _panel.understrength_threshold
	)

	if pct < thr:
		return "UNDERSTRENGTH"
	return "ACTIVE"


## Test if a unit can be reinforced (this screen cannot reinforce wiped-out units).
func _can_reinforce(uid: String) -> bool:
	var cur_strength: float = _unit_strength.get(uid, 0.0)
	return cur_strength > 0.0
