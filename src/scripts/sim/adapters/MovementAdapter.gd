class_name MovementAdapter
extends Node
## Movement adapter for pathfinding-based unit orders.
##
## @brief Plans and ticks movement using per-unit profiles (FOOT/WHEELED/
## TRACKED/RIVERINE), groups ticks by profile for performance, and resolves
## map label names into terrain positions for destination orders.
## @experimental

## Map lowercase mobility tags/strings to movement profiles.
const _PROFILE_BY_TAG := {
	"foot": TerrainBrush.MoveProfile.FOOT,
	"infantry": TerrainBrush.MoveProfile.FOOT,
	"wheeled": TerrainBrush.MoveProfile.WHEELED,
	"truck": TerrainBrush.MoveProfile.WHEELED,
	"apc": TerrainBrush.MoveProfile.WHEELED,
	"tracked": TerrainBrush.MoveProfile.TRACKED,
	"mbt": TerrainBrush.MoveProfile.TRACKED,
	"ifv": TerrainBrush.MoveProfile.TRACKED,
	"riverine": TerrainBrush.MoveProfile.RIVERINE,
	"boat": TerrainBrush.MoveProfile.RIVERINE,
}

## Terrain renderer providing the PathGrid and TerrainData.
@export var renderer: TerrainRender
## Default profile used when a unit has no explicit movement profile.
@export var default_profile: int = TerrainBrush.MoveProfile.FOOT
## Enable resolving String destinations using TerrainData.labels[].text.
@export var enable_label_destinations := true

var _grid: PathGrid
var _labels: Dictionary = {}


## Initialize grid hooks and build the label index.
func _ready() -> void:
	_grid = renderer.path_grid
	_refresh_label_index()

	if _grid and not _grid.is_connected("build_ready", Callable(self, "_on_grid_ready")):
		_grid.build_ready.connect(_on_grid_ready)


## Rebuilds the label lookup from TerrainData.labels.
## Stores: normalized_text -> Array[Vector2] (terrain meters).
func _refresh_label_index() -> void:
	_labels.clear()
	if not enable_label_destinations:
		return
	if renderer == null or renderer.data == null:
		return
	var labels := renderer.data.labels
	for label in labels:
		var txt := str(label.get("text", "")).strip_edges()
		var pos: Vector2 = label.get("pos", null)
		if txt == "" or typeof(pos) != TYPE_VECTOR2:
			continue
		var key := _norm_label(txt)
		if not _labels.has(key):
			_labels[key] = []
		_labels[key].append(pos)


## Normalizes label text for tolerant matching.
## Removes punctuation, collapses spaces, and lowercases.
## [param s] Original label text.
## [return] Normalized key.
func _norm_label(s: String) -> String:
	var t := s.strip_edges().to_lower()
	for bad in [
		",",
		".",
		":",
		";",
		"(",
		")",
		"[",
		"]",
		"'",
		'"',
		"?",
		"!",
		"@",
		"#",
		"$",
		"%",
		"^",
		"&",
		"*",
		"+",
		"=",
		"|",
		"\\"
	]:
		t = t.replace(bad, "")
	t = t.replace("-", " ").replace("_", " ").replace("/", " ")
	while t.find("  ") != -1:
		t = t.replace("  ", " ")
	return t


## Resolves a label phrase to a terrain position in meters.
## When multiple labels share the same text, picks the closest to origin.
## [param label_text] Label string to look up.
## [param origin_m] Optional origin (unit position) for tie-breaking.
## [return] Vector2 position if found, otherwise null.
func _resolve_label_to_pos(label_text: String, origin_m: Vector2 = Vector2.INF) -> Variant:
	if not enable_label_destinations:
		return null
	var key := _norm_label(label_text)
	if not _labels.has(key):
		return null
	var arr: Array = _labels[key]
	if arr.is_empty():
		return null
	if origin_m.is_finite():
		var best: Vector2 = arr[0]
		var best_d := best.distance_to(origin_m)
		for p in arr:
			var d := (p as Vector2).distance_to(origin_m)
			if d < best_d:
				best = p
				best_d = d
		return best
	return arr[0]


## Plans and starts movement to a map label.
## [param su] ScenarioUnit to move.
## [param label_text] Label name to resolve.
## [return] True if the order was accepted (or deferred), else false.
func plan_and_start_to_label(su: ScenarioUnit, label_text: String) -> bool:
	if su == null:
		return false
	var pos: Variant = _resolve_label_to_pos(label_text, su.position_m)
	if typeof(pos) == TYPE_VECTOR2:
		return plan_and_start(su, pos)
	LogService.warning("label not found: %s" % label_text, "MovementAdapter.gd:88")
	return false


## Plans and starts movement to either a Vector2 destination or a label.
## Also accepts {x,y} or {pos: Vector2} dictionaries.
## [param su] ScenarioUnit to move.
## [param dest] Vector2 | String | Dictionary destination.
## [return] True if the order was accepted (or deferred), else false.
func plan_and_start_any(su: ScenarioUnit, dest: Variant) -> bool:
	match typeof(dest):
		TYPE_VECTOR2:
			return plan_and_start(su, dest)
		TYPE_STRING:
			return plan_and_start_to_label(su, dest)
		TYPE_DICTIONARY:
			if dest.has("x") and dest.has("y"):
				return plan_and_start(su, Vector2(dest["x"], dest["y"]))
			if dest.has("pos"):
				var p: Vector2 = dest["pos"]
				if typeof(p) == TYPE_VECTOR2:
					return plan_and_start(su, p)
	return false


## Ensures PathGrid profiles needed by [param units] are available.
## Triggers async builds for any missing profiles.
func _prebuild_needed_profiles(units: Array[ScenarioUnit]) -> void:
	if _grid == null:
		return
	var wanted := {}
	for u in units:
		var p := u.unit.movement_profile
		wanted[p] = true
	for p in wanted.keys():
		if not _grid.has_profile(p):
			_grid.ensure_profile(p)


## Ticks unit movement grouped by profile (reduces grid switching).
## Skips groups whose profile grid is still building this frame.
## [param units] Units to tick.
## [param dt] Delta time in seconds.
func tick_units(units: Array[ScenarioUnit], dt: float) -> void:
	if _grid == null or units.is_empty():
		return

	_prebuild_needed_profiles(units)

	var groups := {}
	for u in units:
		var p := u.unit.movement_profile
		if not groups.has(p):
			groups[p] = []
		groups[p].append(u)

	for p in groups.keys():
		if _grid.ensure_profile(p):
			_grid.use_profile(p)
			for u in groups[p]:
				u.tick(dt, _grid)


## Pauses current movement for a unit.
## [param su] ScenarioUnit to pause.
func cancel_move(su: ScenarioUnit) -> void:
	if su == null:
		return
	su.pause_move()


## Plans and immediately starts movement to [param dest_m].
## Defers start if the profile grid is still building.
## [param su] ScenarioUnit to move.
## [param dest_m] Destination in terrain meters.
## [return] True if planned (or deferred), false on error or plan failure.
func plan_and_start(su: ScenarioUnit, dest_m: Vector2) -> bool:
	if su == null or _grid == null:
		LogService.warning("unit or grid null", "MovementAdapter.gd:151")
		return false
	var p := su.unit.movement_profile
	if not _grid.ensure_profile(p):
		su.set_meta("_pending_start_dest", dest_m)
		su.set_meta("_pending_start_profile", p)
		return true
	_grid.use_profile(p)
	if su.plan_move(_grid, dest_m):
		su.start_move(_grid)
		return true
	LogService.warning("plan_move failed", "MovementAdapter.gd:163")
	return false


## Starts any deferred moves whose profile just finished building.
## [param profile] Movement profile that became available.
func _on_grid_ready(profile: int) -> void:
	var scen := Game.current_scenario
	if scen == null:
		return
	var all_units: Array = []
	all_units.append_array(scen.units)
	all_units.append_array(scen.playable_units)
	_grid.use_profile(profile)
	for su in all_units:
		if su == null:
			continue
		if (
			su.has_meta("_pending_start_profile")
			and int(su.get_meta("_pending_start_profile")) == profile
		):
			var dest_m: Vector2 = su.get_meta("_pending_start_dest")
			su.erase_meta("_pending_start_profile")
			su.erase_meta("_pending_start_dest")
			if su.plan_move(_grid, dest_m):
				su.start_move(_grid)

## Behaviour mapping from AIAgent
func set_behaviour_params(speed_mult: float, cover_bias: float, noise_level: float) -> void:
	pass

## TaskMove
func request_move_to(dest: Vector3) -> void:
	pass

func is_move_complete() -> bool:
	return false

## TaskDefend
func request_hold_area(center: Vector3, radius: float) -> void:
	pass

func is_hold_established() -> bool:
	return false

## TaskPatrol
func request_patrol(points: Array[Vector3], ping_pong: bool) -> void:
	pass

func is_patrol_running() -> bool:
	return false
