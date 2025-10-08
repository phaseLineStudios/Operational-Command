class_name MovementAdapter
extends Node
## Bridges game orders to pathfinding-based unit movement.
## @brief Per-unit movement profiles (FOOT/WHEELED/TRACKED/RIVERINE) with
## on-demand grid builds and grouped ticks for performance.
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

@export var renderer: TerrainRender
var _grid: PathGrid

## Default profile if nothing is specified on the unit or its data.
@export var default_profile: int = TerrainBrush.MoveProfile.FOOT

func _ready() -> void:
	_grid = renderer.path_grid

	if _grid and not _grid.is_connected("build_ready", Callable(self, "_on_grid_ready")):
		_grid.build_ready.connect(_on_grid_ready)
		

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
		LogService.warning("unit or grid null", "MovementAdapter.gd:74")
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
	LogService.warning("plan_move failed", "MovementAdapter.gd:84")
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
		if su.has_meta("_pending_start_profile") and int(su.get_meta("_pending_start_profile")) == profile:
			var dest_m: Vector2 = su.get_meta("_pending_start_dest")
			su.erase_meta("_pending_start_profile")
			su.erase_meta("_pending_start_dest")
			if su.plan_move(_grid, dest_m):
				su.start_move(_grid)
