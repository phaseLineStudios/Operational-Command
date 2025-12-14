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
## Interval for proximity scans when enabled (seconds).
@export var proximity_scan_interval_sec: float = 0.25

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
var _scan_accum: float = 0.0


## Autowires LOS helper and terrain renderer from exported paths.
func _ready() -> void:
	var sim: SimWorld = null
	if not simworld_path.is_empty():
		sim = get_node_or_null(simworld_path) as SimWorld
	if sim == null:
		sim = _find_simworld()
	if sim and not sim.is_connected("contact_reported", Callable(self, "_on_contact")):
		sim.contact_reported.connect(_on_contact)
	if los_node_path != NodePath(""):
		_los = get_node(los_node_path)
	if terrain_renderer_path != NodePath(""):
		_renderer = get_node(terrain_renderer_path) as TerrainRender
		_terrain = _renderer.data

	var scan_enabled: bool = sim == null and not actor_path.is_empty() and String(hostiles_group_name) != ""
	set_process(scan_enabled)
	if scan_enabled:
		_actor = get_node_or_null(actor_path) as Node3D
		_scan_accum = proximity_scan_interval_sec


func _process(_dt: float) -> void:
	if _actor == null:
		return
	if String(hostiles_group_name) == "":
		return

	_scan_accum += _dt
	var interval: float = maxf(proximity_scan_interval_sec, 0.0)
	if interval > 0.0 and _scan_accum < interval:
		return
	_scan_accum = 0.0

	# Simple proximity scan; replace with your perception logic when ready.
	var pos: Vector3 = _actor.global_position
	var radius_sq: float = detection_radius * detection_radius
	var found: bool = false
	for n in get_tree().get_nodes_in_group(hostiles_group_name):
		var n3d: Node3D = n as Node3D
		if n3d == null:
			continue
		if n3d.global_position.distance_squared_to(pos) <= radius_sq:
			found = true
			break
	_hostile_contact = found
	if found:
		_last_contact_s = Time.get_ticks_msec() / 1000.0


func _find_simworld() -> SimWorld:
	var node: Node = self
	while node != null:
		if node is SimWorld:
			return node as SimWorld
		for child in node.get_children():
			if child is SimWorld:
				return child as SimWorld
		node = node.get_parent()
	return null


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
	if _hostile_contact:
		return true
	if _last_contact_s < 0.0:
		return false
	var curr_time := Time.get_ticks_msec() / 1000.0
	return curr_time - _last_contact_s <= contact_memory_sec


## Allow external systems to toggle contact directly.
func set_hostile_contact(v: bool) -> void:
	_hostile_contact = v
	if v:
		_last_contact_s = Time.get_ticks_msec() / 1000.0


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


## Fast local visibility query placeholder for EnvBehaviorSystem.
func sample_visibility_for_unit(_unit: ScenarioUnit) -> float:
	if _unit == null:
		return 1.0
	var pos_m: Vector2 = _unit.position_m if "position_m" in _unit else Vector2.ZERO
	return sample_visibility_at(pos_m)


## Visibility sampling at a position placeholder.
func sample_visibility_at(_pos_m: Vector2) -> float:
	if _renderer == null:
		return 1.0
	# Derive a local concealment penalty by sampling spotting_mul at zero range,
	# then invert it to represent visibility (1.0 = clear, lower = obscured).
	var spot_mul: float = spotting_mul(_pos_m, 0.0, _current_weather_severity())
	var conceal_bonus: float = 1.0
	var surf: Dictionary = _renderer.get_surface_at_terrain_position(_pos_m)
	if typeof(surf) == TYPE_DICTIONARY and surf.has("brush"):
		var brush: Variant = surf.get("brush")
		if brush and brush.has_method("get"):
			var conceal: float = clamp(float(brush.get("concealment", 0.0)), 0.0, 1.0)
			conceal_bonus = max(0.05, 1.0 - conceal)
	return clamp(spot_mul * conceal_bonus, 0.0, 1.0)


func _current_weather_severity() -> float:
	# If a terrain renderer data is attached, try to fetch ScenarioData weather if present.
	# Fallback to 0 severity.
	if Game.current_scenario != null:
		var scen: ScenarioData = Game.current_scenario
		var fog_m: float = float(scen.fog_m)
		var rain: float = float(scen.rain)
		var fog_sev: float = clamp(1.0 - fog_m / 8000.0, 0.0, 1.0)
		var rain_sev: float = clamp(rain / 50.0, 0.0, 1.0)
		return max(fog_sev, rain_sev)
	return 0.0
