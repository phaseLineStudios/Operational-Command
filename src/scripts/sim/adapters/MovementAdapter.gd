class_name MovementAdapter
extends Node
## Bridges game orders to pathfinding-based unit movement.
##
## Per-unit movement profiles (FOOT/WHEELED/TRACKED/RIVERINE) with
## on-demand grid builds and grouped ticks for performance. Also resolves
## @experimental

## Map lowercase tags/strings to profiles.
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

## Nodepath to terrain renderer.
@export var renderer: TerrainRender
## Default profile if nothing is specified on the unit or its data.
@export var default_profile: int = TerrainBrush.MoveProfile.FOOT
## Allow resolving string destinations via TerrainData.labels[].text
@export var enable_label_destinations := true

var _grid: PathGrid
var _labels: Dictionary = {}


func _ready() -> void:
	_grid = renderer.path_grid
	_refresh_label_index()

	if _grid and not _grid.is_connected("build_ready", Callable(self, "_on_grid_ready")):
		_grid.build_ready.connect(_on_grid_ready)


## Rebuild the label lookup from TerrainData.labels.
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


## Normalize label text for matching (case/space/punctuation tolerant).
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


## Resolve a label (phrase) to a terrain position; if multiple matches,
## chooses the one closest to `origin_m` (unit position) when provided.
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


## Public helper: plan move to a map label.
func plan_and_start_to_label(su: ScenarioUnit, label_text: String) -> bool:
	if su == null:
		return false
	var pos: Variant = _resolve_label_to_pos(label_text, su.position_m)
	if typeof(pos) == TYPE_VECTOR2:
		return plan_and_start(su, pos)
	LogService.warning("label not found: %s" % label_text, "MovementAdapter.gd:88")
	return false


## Public helper: plan move to an arbitrary destination (Vector2 or String label).
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


## Build any missing profiles we will need for the given unit list.
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


## Tick units grouped by their profile. Skips units whose profile grid
## is still building this frame (will run once build_ready fires).
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


## Cancel/hold current movement for [param su].
func cancel_move(su: ScenarioUnit) -> void:
	if su == null:
		return
	su.pause_move()


## Plan + immediately start unit movement to `dest_m`.
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


## When a needed profile finishes building, start any deferred moves and
## force a movement tick so units immediately advance.
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
