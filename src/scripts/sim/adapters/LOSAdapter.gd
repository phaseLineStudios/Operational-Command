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
## Checks both terrain blocking AND maximum spotting range.
## [param a] Attacking/observing unit.
## [param b] Defending/observed unit.
## [return] True if LOS is clear and within range, otherwise false.
func has_los(a: ScenarioUnit, b: ScenarioUnit) -> bool:
	if a == null or b == null or _los == null or _renderer == null:
		LogService.warning(
			"LOS check failed: missing components (a=%s, b=%s, _los=%s, _renderer=%s)" % [
				a != null,
				b != null,
				_los != null,
				_renderer != null
			],
			"LOSAdapter.gd:has_los"
		)
		return false

	# Check if terrain data is loaded
	if _renderer.data == null:
		LogService.warning("LOS check: terrain data not loaded!", "LOSAdapter.gd:has_los")
		# Without terrain, we can't block LOS, so just use range check
		var range_m := a.position_m.distance_to(b.position_m)
		var max_spot_range := a.unit.spot_m if (a.unit and a.unit.spot_m > 0) else 2000.0
		return range_m <= max_spot_range

	# Check maximum spotting range
	var range_m := a.position_m.distance_to(b.position_m)
	var max_spot_range := 0.0
	if a.unit and a.unit.spot_m > 0:
		max_spot_range = a.unit.spot_m
	else:
		# Default spotting range if not specified
		max_spot_range = 2000.0

	# Out of spotting range
	if range_m > max_spot_range:
		return false

	# Check terrain blocking
	var res: Dictionary = _los.trace_los(
		a.position_m, b.position_m, _renderer, _renderer.data, effects_config
	)
	var blocked: bool = res.get("blocked", false)
	var atten_integral: float = res.get("atten_integral", 0.0)

	# Dense vegetation (forests, etc.) can also block LOS via attenuation
	# If attenuation integral is high enough, treat as blocked
	# exp(-5.0) ≈ 0.0067 = ~0.7% spotting chance = effectively blocked
	const ATTEN_BLOCK_THRESHOLD := 5.0
	if atten_integral >= ATTEN_BLOCK_THRESHOLD:
		blocked = true

	# Debug log for contact reports
	if not blocked and a.playable:
		LogService.trace(
			"LOS established: %s -> %s (range: %.0fm, spot: %.0fm, atten: %.2f, blocked: %s)" % [
				a.callsign,
				b.callsign,
				range_m,
				max_spot_range,
				atten_integral,
				blocked
			],
			"LOSAdapter.gd:has_los"
		)
	elif blocked and a.playable:
		var reason := "terrain" if res.get("blocked", false) else "vegetation"
		LogService.trace(
			"LOS blocked by %s: %s -> %s (range: %.0fm, atten: %.2f)" % [
				reason,
				a.callsign,
				b.callsign,
				range_m,
				atten_integral
			],
			"LOSAdapter.gd:has_los"
		)

	return not blocked


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
