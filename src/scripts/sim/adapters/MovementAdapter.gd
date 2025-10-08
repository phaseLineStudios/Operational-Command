class_name MovementAdapter
extends Node
## Bridge for ScenarioUnit → PathGrid pathing & movement ticks.

## Terrain renderer
@export var terrain_renderer: TerrainRender

var _grid: PathGrid

func _ready():
	_grid = terrain_renderer.path_grid

## Plan movement for [param su] to [param dest_m]. Returns true on success.
func plan_move(su: ScenarioUnit, dest_m: Vector2) -> bool:
	if su == null or _grid == null:
		LogService.warning("no_grid or no_unit")
		return false
	return su.plan_move(_grid, dest_m)


## Cancel/hold current movement for [param su].
func cancel_move(su: ScenarioUnit) -> void:
	if su == null:
		return
	su.pause_move()


## Tick all units for [param dt] seconds of movement.
func tick_units(units: Array[ScenarioUnit], dt: float) -> void:
	if _grid == null:
		return
	for u in units:
		u.tick(dt, _grid)
