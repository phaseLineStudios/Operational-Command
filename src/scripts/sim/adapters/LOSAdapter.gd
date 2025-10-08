class_name LOSAdapter
extends Node
## Wraps LOS helpers to produce contact checks between units.
## @experimental

@export var los_node_path: NodePath
@export var terrain_renderer_path: NodePath
@export
var effects_config: TerrainEffectsConfig = preload("res://assets/configs/terrain_effects.tres")

var _los: Node
var _renderer: TerrainRender
var _terrain: TerrainData


func _ready() -> void:
	if los_node_path != NodePath(""):
		_los = get_node(los_node_path)
	if terrain_renderer_path != NodePath(""):
		_renderer = get_node(terrain_renderer_path) as TerrainRender
		_terrain = _renderer.data


## Returns true if there is line-of-sight from [param a] to [param b].
func has_los(a: ScenarioUnit, b: ScenarioUnit) -> bool:
	if a == null or b == null or _los == null or _renderer == null:
		return false
	var res: Dictionary = _los.trace_los(
		a.position_m, b.position_m, _renderer, _renderer.data, effects_config
	)
	return not bool(res.get("blocked", false))


## Compute spotting multiplier (0..1) at [param range_m] for [param pos_d].
func spotting_mul(pos_d: Vector2, range_m: float, weather_severity: float = 0.0) -> float:
	if _los == null or _renderer == null or _renderer.data == null:
		return 1.0
	return _los.compute_spotting_mul(
		_renderer, _renderer.data, pos_d, range_m, weather_severity, effects_config
	)


## Find all contact pairs between [param friends] and [param enemies].
## Returns Array of { attacker: ScenarioUnit, defender: ScenarioUnit }.
func contacts_between(friends: Array[ScenarioUnit], enemies: Array[ScenarioUnit]) -> Array:
	var out: Array = []
	for f in friends:
		for e in enemies:
			if has_los(f, e):
				out.append({"attacker": f, "defender": e})
	return out
