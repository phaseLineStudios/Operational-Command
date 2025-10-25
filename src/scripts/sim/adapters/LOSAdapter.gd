class_name LOSAdapter
extends Node
## Line-of-sight adapter for unit visibility and contact checks
##
## Wraps a LOS helper node and terrain data to answer LOS, spotting
## multipliers, and build contact pairs between forces.
## @experimental

## NodePath to a LOS helper that implements:
## `trace_los(a_pos, b_pos, renderer, terrain_data, effects_config) -> Dictionary`
@export var los_node_path: NodePath
## NodePath to the TerrainRender that provides `data: TerrainData`.
@export var terrain_renderer_path: NodePath
## Terrain effects configuration used by LOS/spotting calculations.
@export
var effects_config: TerrainEffectsConfig = preload("res://assets/configs/terrain_effects.tres")

var _los: Node
var _renderer: TerrainRender
var _terrain: TerrainData


## Autowires LOS helper and terrain renderer from exported paths.
func _ready() -> void:
	if los_node_path != NodePath(""):
		_los = get_node(los_node_path)
	if terrain_renderer_path != NodePath(""):
		_renderer = get_node(terrain_renderer_path) as TerrainRender
		_terrain = _renderer.data


## Returns true if there is an unobstructed LOS from [param a] to [param b].
## [param a] Attacking/observing unit.
## [param b] Defending/observed unit.
## [return] True if LOS is clear, otherwise false.
func has_los(a: ScenarioUnit, b: ScenarioUnit) -> bool:
	if a == null or b == null or _los == null or _renderer == null:
		return false
	var res: Dictionary = _los.trace_los(
		a.position_m, b.position_m, _renderer, _renderer.data, effects_config
	)
	return not bool(res.get("blocked", false))


## Computes a spotting multiplier (0..1) at [param range_m] from [param pos_d].
## Values near 0 reduce detection; 1 means no penalty.
## [param pos_d] Defender position in meters (terrain space).
## [param range_m] Range from observer to defender in meters.
## [param weather_severity] Optional 0..1 weather penalty factor.
## [return] Spotting multiplier in [0, 1].
func spotting_mul(pos_d: Vector2, range_m: float, weather_severity: float = 0.0) -> float:
	if _los == null or _renderer == null or _renderer.data == null:
		return 1.0
	return _los.compute_spotting_mul(
		_renderer, _renderer.data, pos_d, range_m, weather_severity, effects_config
	)


## Builds contact pairs with clear LOS between [param friends] and [param enemies].
## [param friends] Array of friendly ScenarioUnit.
## [param enemies] Array of enemy ScenarioUnit.
## [return] Array of Dictionaries: { \"attacker\": ScenarioUnit, \"defender\": ScenarioUnit }.
func contacts_between(friends: Array[ScenarioUnit], enemies: Array[ScenarioUnit]) -> Array:
	var out: Array = []
	for f in friends:
		for e in enemies:
			if has_los(f, e):
				out.append({"attacker": f, "defender": e})
	return out
