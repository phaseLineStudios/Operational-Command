class_name LOSAdapter
extends Node
## Line-of-sight adapter for unit visibility and contact checks
##
## Wraps a LOS helper node and terrain data to answer LOS, spotting
## multipliers, and build contact pairs between forces.
## @experimental

## Minimal contact detector used by TaskWait until_contact.
## Either toggle by API, or do a simple distance scan against a group.

## If actor_path is set and hostiles_group_name is non-empty, we will auto-scan each frame.
@export var actor_path: NodePath
@export var hostiles_group_name: StringName = &"hostile"
@export var detection_radius: float = 60.0

## NodePath to a LOS helper that implements:
## `trace_los(a_pos, b_pos, renderer, terrain_data, effects_config) -> Dictionary`
@export var los_node_path: NodePath
## NodePath to the TerrainRender that provides `data: TerrainData`.
@export var terrain_renderer_path: NodePath
## Terrain effects configuration used by LOS/spotting calculations.
@export
var effects_config: TerrainEffectsConfig = preload("res://assets/configs/terrain_effects.tres")

@export var simworld_path: NodePath
@export var unit_id: String
@export var contact_memory_sec: float = 4.0
var _last_contact_s := -1.0

var _los: Node
var _renderer: TerrainRender
var _terrain: TerrainData

var _actor: Node3D
var _hostile_contact: bool = false


## Autowires LOS helper and terrain renderer from exported paths.
func _ready() -> void:
	var sim: SimWorld
	if simworld_path.is_empty():
		sim = null
	else:
		sim = get_node_or_null(simworld_path)
	if sim:
		sim.contact_reported.connect(_on_contact)
	if los_node_path != NodePath(""):
		_los = get_node(los_node_path)
	if terrain_renderer_path != NodePath(""):
		_renderer = get_node(terrain_renderer_path) as TerrainRender
		_terrain = _renderer.data
	if actor_path.is_empty():
		_actor = get_parent() as Node3D
	else:
		_actor = get_node_or_null(actor_path) as Node3D


func _process(_dt: float) -> void:
	if _actor == null:
		return
	if String(hostiles_group_name) == "":
		return
	# Simple proximity scan; replace with your perception logic when ready
	var pos: Vector3 = _actor.global_position
	var found: bool = false
	for n in get_tree().get_nodes_in_group(hostiles_group_name):
		if n is Node3D:
			if (n as Node3D).global_position.distance_to(pos) <= detection_radius:
				found = true
				break
	_hostile_contact = found


## Returns true if there is an unobstructed LOS from [param a] to [param b].
## Checks both terrain blocking AND maximum spotting range.
## [param a] Attacking/observing unit.
## [param b] Defending/observed unit.
## [return] True if LOS is clear and within range, otherwise false.
func has_los(a: ScenarioUnit, b: ScenarioUnit) -> bool:
	if a == null or b == null or _los == null or _renderer == null:
		return false

	var range_m := a.position_m.distance_to(b.position_m)
	var base_spot_range := a.unit.spot_m if (a.unit and a.unit.spot_m > 0) else 2000.0
	var behaviour_mult := _behaviour_spotting_mult(b)
	var terrain_mult := 1.0

	if _renderer.data != null:
		terrain_mult = spotting_mul(b.position_m, range_m)

	var effective_spot_range := base_spot_range * terrain_mult * behaviour_mult
	if range_m > effective_spot_range:
		return false

	var res: Dictionary = _los.trace_los(
		a.position_m, b.position_m, _renderer, _renderer.data, effects_config
	)
	var blocked: bool = res.get("blocked", false)
	var atten_integral: float = res.get("atten_integral", 0.0)

	const ATTEN_BLOCK_THRESHOLD := 3.4
	if atten_integral >= ATTEN_BLOCK_THRESHOLD:
		blocked = true

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


## used by AIAgent to determine what to do on contact in LOSAdapter
func _on_contact(attacker: String, defender: String) -> void:
	if attacker == unit_id or defender == unit_id:
		_last_contact_s = Time.get_ticks_msec() / 1000.0


## Used by AIAgent wait-until-contact
func has_hostile_contact() -> bool:
	if _last_contact_s < 0.0:
		return false
	var curr_time := Time.get_ticks_msec() / 1000.0
	return curr_time - _last_contact_s <= contact_memory_sec


## Allow external systems to toggle contact directly.
func set_hostile_contact(v: bool) -> void:
	_hostile_contact = v


func _behaviour_spotting_mult(target: ScenarioUnit) -> float:
	if target == null:
		return 1.0
	match target.behaviour:
		ScenarioUnit.Behaviour.CARELESS:
			return 1.1
		ScenarioUnit.Behaviour.SAFE:
			return 1.0
		ScenarioUnit.Behaviour.AWARE:
			return 0.9
		ScenarioUnit.Behaviour.COMBAT:
			return 0.8
		ScenarioUnit.Behaviour.STEALTH:
			return 0.6
		_:
			return 1.0
