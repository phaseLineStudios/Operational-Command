class_name AIController
extends Node
## Enemy AI task manager with Cold War doctrine behaviors.
##
## Maintains a rolling task list (defend, attack, delay, ambush) and reacts to
## player activity and simulation feedback to re-plan routes and objectives.

## Coordinates per-unit ScenarioTaskRunner and AIAgent to execute authored task chains.

## Node references resolved in-scene (preferred over find_child calls).
@export var sim_world_ref: SimWorld
@export var movement_adapter_ref: MovementAdapter
@export var combat_adapter_ref: CombatAdapter
@export var los_adapter_ref: LOSAdapter
@export var orders_router_ref: OrdersRouter
@export var agents_root_ref: Node

@export var sim_world_path: NodePath
@export var movement_adapter_path: NodePath
@export var combat_adapter_path: NodePath
@export var los_adapter_path: NodePath
@export var orders_router_path: NodePath
@export var agents_root_path: NodePath

## Seconds a RETURN_FIRE unit may fire after being attacked.
@export var return_fire_window_sec: float = 5.0
## Active task runners per unit id.
var _runners: Dictionary = {}  ## unit_id -> ScenarioTaskRunner
## AI agents per unit id.
var _agents: Dictionary = {}  ## unit_id -> AIAgent
## Temporary return-fire flags: { uid:int, key:String, expire:float }.
var _recent_attack_marks: Array = []  ## Array of { uid:int, key:String, expire:float }
## Trigger id -> Array[Dictionary(unit_id, task_index)].
var _blocked_triggers: Dictionary = {}
## Unit id -> Array[task_index] (initial blocks before triggers fire).
var _initial_blocks_by_unit: Dictionary = {}
## Cached scene references for adapter injection.
var _sim: SimWorld
var _movement_adapter: MovementAdapter
var _combat_adapter: CombatAdapter
var _los_adapter: LOSAdapter
var _orders_router: OrdersRouter
var _agents_root: Node
## ScenarioUnit id -> index cache for quick lookup.
var _unit_index_cache: Dictionary = {}
var _env_behavior_system: Node = null


## Initialize controller and subscribe to sim engagement events for RETURN_FIRE.
func _ready() -> void:
	_resolve_context_nodes()
	# Wire return-fire window from SimWorld engagement events
	if _sim and not _sim.engagement_reported.is_connected(_on_engagement_reported):
		_sim.engagement_reported.connect(_on_engagement_reported)
	# Ensure runners tick via _physics_process
	set_physics_process(true)


## Register a unit's agent and its prebuilt ordered task list.
## [param unit_id] Index in ScenarioData.units.
## [param agent] AIAgent that will execute intents.
## [param ordered_tasks] Runner-ready task dictionaries for this unit.
func register_unit(unit_id: int, agent: AIAgent, ordered_tasks: Array[Dictionary]) -> void:
	if _runners.has(unit_id):
		unregister_unit(unit_id)
	var runner := ScenarioTaskRunner.new()
	add_child(runner)
	runner.setup(unit_id, ordered_tasks)
	_runners[unit_id] = runner
	_agents[unit_id] = agent
	_apply_initial_blocks_for_unit(unit_id)


## Unregister and free the runner/agent for a unit id (idempotent).
func unregister_unit(unit_id: int) -> void:
	if _runners.has(unit_id):
		var r: ScenarioTaskRunner = _runners[unit_id]
		_runners.erase(unit_id)
		if is_instance_valid(r):
			r.queue_free()
	if _agents.has(unit_id):
		var a: AIAgent = _agents[unit_id]
		_agents.erase(unit_id)
		if is_instance_valid(a):
			a.queue_free()


## Remove all registered units and dispose of their agents/runners.
func unregister_all_units() -> void:
	var runner_ids := _runners.keys()
	for uid in runner_ids:
		unregister_unit(uid)
	if not _agents.is_empty():
		var agent_ids := _agents.keys()
		for uid in agent_ids:
			unregister_unit(uid)


## True if a unit has no active or queued tasks in its runner.
func is_unit_idle(unit_id: int) -> bool:
	if not _runners.has(unit_id):
		return true
	return _runners[unit_id].is_idle()


## Pause the unit's task processing (current task remains active).
func pause_unit(unit_id: int) -> void:
	if _runners.has(unit_id):
		_runners[unit_id].pause()


## Resume a paused unit's task processing.
func resume_unit(unit_id: int) -> void:
	if _runners.has(unit_id):
		_runners[unit_id].resume()


## Cancel the active task (runner will start the next queued task).
func cancel_active(unit_id: int) -> void:
	if _runners.has(unit_id):
		_runners[unit_id].cancel_active()


## Force-advance to the next task in the queue.
func advance_unit(unit_id: int) -> void:
	if _runners.has(unit_id):
		_runners[unit_id].advance()


## Build per-unit ordered queues from a flat list using unit_index and optional links.
## Build per-unit ordered queues from a flat list of ScenarioData.tasks.
## Uses unit_index and prev/next_index to form a deterministic chain.
## [return] Dictionary: unit_index -> Array[Dictionary] (runner task dicts).
func build_per_unit_queues(flat_tasks: Array[Dictionary]) -> Dictionary:
	var by_unit: Dictionary = {}  # int -> Array[Dictionary]

	# Tag each task with its source index so next/prev_index stay meaningful
	for i in flat_tasks.size():
		var t: Dictionary = flat_tasks[i]
		if t == null:
			continue
		t["__src_index"] = i
		var uid := int(t.get("unit_index", -1))
		if uid < 0:
			continue
		if not by_unit.has(uid):
			by_unit[uid] = []
		(by_unit[uid] as Array).append(t)

	for uid in by_unit.keys():
		var arr: Array = by_unit[uid]
		var by_src: Dictionary = {}
		var has_links := false
		for d: Dictionary in arr:
			by_src[int(d.get("__src_index", -1))] = d
			if d.has("prev_index") or d.has("next_index"):
				has_links = true

		if has_links:
			# head = any task for this unit with prev_index == -1
			var head_src := -1
			for d2: Dictionary in arr:
				if int(d2.get("prev_index", -1)) == -1:
					head_src = int(d2.get("__src_index", -1))
					break
			if head_src == -1 and arr.size() > 0:
				head_src = int(arr[0].get("__src_index", -1))

			var ordered: Array[Dictionary] = []
			var cursor := head_src
			var safety := 0
			while by_src.has(cursor) and safety < 4096:
				var dd: Dictionary = by_src[cursor]
				ordered.append(dd)
				var nxt := int(dd.get("next_index", -1))
				if nxt == cursor:
					break
				cursor = nxt
				safety += 1
			by_unit[uid] = ordered
		else:
			arr.sort_custom(Callable(self, "_cmp_by_src_index"))
			by_unit[uid] = arr

	return by_unit


## Sort helper to keep original authoring order when no explicit links exist.
static func _cmp_by_src_index(a: Dictionary, b: Dictionary) -> bool:
	return int(a.get("__src_index", 0)) < int(b.get("__src_index", 0))


## Normalize ScenarioData.tasks entries (ScenarioTask resources or JSON dicts)
## into runner-friendly dictionaries.
## Supported task_type: move, defend, patrol, set_behaviour, set_combat_mode, wait
## Convert ScenarioTask resources/JSON into runner dictionaries (TaskMove/Defend/...).
## Supports: move, defend, patrol (ping_pong, dwell_s, loop_forever), set_behaviour,
## set_combat_mode, wait (seconds, until_contact). Positions are terrain meters (Vector2).
func normalize_tasks(flat_tasks: Array) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	for t in flat_tasks:
		var d: Dictionary = {}
		var unit_idx := -1
		var next_idx := -1
		var prev_idx := -1
		var pos_m: Vector2 = Vector2.ZERO
		var ttype := ""
		var params: Dictionary = {}

		if typeof(t) == TYPE_DICTIONARY:
			var td: Dictionary = t
			ttype = String(td.get("task_type", "")).strip_edges().to_lower()
			unit_idx = int(td.get("unit_index", -1))
			next_idx = int(td.get("next_index", -1))
			prev_idx = int(td.get("prev_index", -1))
			var pm: Variant = td.get("position_m", null)
			if typeof(pm) == TYPE_DICTIONARY:
				# {x,y}
				pos_m = Vector2(float(pm.get("x", 0.0)), float(pm.get("y", 0.0)))
			elif typeof(pm) == TYPE_VECTOR2:
				pos_m = pm
			params = td.get("params", {})
		elif t is ScenarioTask:
			var st: ScenarioTask = t
			ttype = String(st.task.type_id) if st.task else ""
			unit_idx = st.unit_index
			next_idx = st.next_index
			prev_idx = st.prev_index
			pos_m = st.position_m
			params = st.params
		else:
			continue

		match ttype:
			"move":
				d = {"type": "TaskMove", "point_m": pos_m}
			"defend":
				d = {
					"type": "TaskDefend",
					"center_m": pos_m,
					"radius": float(params.get("radius_m", 0.0)),
				}
			"patrol":
				# Minimal: generate a simple 4-point loop N-E-S-W around center
				var r := float(params.get("radius_m", 100.0))
				var pts: Array[Vector2] = []
				if r > 0.0:
					pts = [
						pos_m + Vector2(0, -r),
						pos_m + Vector2(r, 0),
						pos_m + Vector2(0, r),
						pos_m + Vector2(-r, 0),
					]
				d = {
					"type": "TaskPatrol",
					"points_m": pts,
					"ping_pong": false,
					"dwell_s": float(params.get("dwell_s", 0.0)),
					"loop_forever": bool(params.get("loop_forever", false)),
				}
			"set_behaviour":
				d = {"type": "TaskSetBehaviour", "behaviour": int(params.get("behaviour", 1))}
			"set_combat_mode":
				d = {"type": "TaskSetCombatMode", "mode": int(params.get("combat_mode", 2))}
			"wait":
				d = {
					"type": "TaskWait",
					"seconds": float(params.get("duration_s", 0.0)),
					"until_contact": bool(params.get("until_contact", false)),
				}
			_:
				# Unsupported task types are skipped
				d = {}

		if not d.is_empty():
			d["unit_index"] = unit_idx
			d["next_index"] = next_idx
			d["prev_index"] = prev_idx
			out.append(d)

	return out


## SimWorld callback: mark defender as recently attacked and open return-fire window.
func _on_engagement_reported(attacker_id: String, defender_id: String, _damage: float) -> void:
	if Game.current_scenario == null:
		return
	var attacker_idx: int = int(_unit_index_cache.get(attacker_id, -1))
	var defender_idx: int = int(_unit_index_cache.get(defender_id, -1))
	if attacker_idx == -1 or defender_idx == -1:
		refresh_unit_index_cache()
		if attacker_idx == -1:
			attacker_idx = int(_unit_index_cache.get(attacker_id, -1))
		if defender_idx == -1:
			defender_idx = int(_unit_index_cache.get(defender_id, -1))

	# Allow RETURN_FIRE units to respond for a short window
	# defender_id maps to ScenarioUnit.id; our dictionary keys are unit indices, so search
	if defender_idx >= 0:
		var def_su: ScenarioUnit = Game.current_scenario.units[defender_idx]
		var key_def := "recently_attacked_" + String(attacker_id)
		def_su.set_meta(key_def, true)
		(
			_recent_attack_marks
			. append(
				{
					"uid": defender_idx,
					"key": key_def,
					"expire": (Time.get_ticks_msec() / 1000.0) + return_fire_window_sec,
				}
			)
		)
		var def_agent: AIAgent = _agents.get(defender_idx, null)
		if def_agent:
			def_agent.notify_hostile_shot()

	if attacker_idx >= 0:
		# Also mark the attacker so RETURN_FIRE from the defender will be allowed when roles swap
		var att_su: ScenarioUnit = Game.current_scenario.units[attacker_idx]
		var key_att := "recently_attacked_" + String(defender_id)
		att_su.set_meta(key_att, true)
		(
			_recent_attack_marks
			. append(
				{
					"uid": attacker_idx,
					"key": key_att,
					"expire": (Time.get_ticks_msec() / 1000.0) + return_fire_window_sec,
				}
			)
		)


## Tick all runners (fixed step) and clear expired return-fire marks.
func _physics_process(dt: float) -> void:
	# Sweep and clear expired "recently_attacked_*" marks
	if not _recent_attack_marks.is_empty():
		var now := Time.get_ticks_msec() / 1000.0
		for i in range(_recent_attack_marks.size() - 1, -1, -1):
			var rec: Dictionary = _recent_attack_marks[i]
			if float(rec.get("expire", 0.0)) <= now:
				var idx := int(rec.get("uid", -1))
				var k: String = String(rec.get("key", ""))
				if idx >= 0 and Game.current_scenario and Game.current_scenario.units.size() > idx:
					var su: ScenarioUnit = Game.current_scenario.units[idx]
					if su and su.has_meta(k):
						su.remove_meta(k)
				_recent_attack_marks.remove_at(i)

	for uid in _runners.keys():
		var runner: ScenarioTaskRunner = _runners[uid]
		var agent: AIAgent = _agents.get(uid, null)
		if agent == null:
			continue
		runner.tick(dt, agent)


func _apply_initial_blocks_for_unit(unit_id: int) -> void:
	var idxs: Array = _initial_blocks_by_unit.get(unit_id, [])
	if idxs.is_empty():
		return
	var runner: ScenarioTaskRunner = _runners.get(unit_id, null)
	if runner == null:
		return
	for idx in idxs:
		runner.block_task_index(int(idx), true)
	_initial_blocks_by_unit.erase(unit_id)


func _on_trigger_activated(trigger_id: String) -> void:
	var entries: Array = _blocked_triggers.get(trigger_id, [])
	if entries.is_empty():
		return
	for entry in entries:
		var uid := int(entry.get("unit_id", -1))
		var tidx := int(entry.get("task_index", -1))
		var runner: ScenarioTaskRunner = _runners.get(uid, null)
		if runner:
			runner.block_task_index(tidx, false)
	_blocked_triggers.erase(trigger_id)


## Instantiate and bind an AIAgent using configured adapters.
func create_agent(unit_id: int) -> AIAgent:
	_ensure_adapter_cache()
	if _movement_adapter == null:
		LogService.error(
			"AIController missing MovementAdapter reference.", "AIController.gd:create_agent"
		)
		return null
	if _combat_adapter == null:
		LogService.error(
			"AIController missing CombatAdapter reference.", "AIController.gd:create_agent"
		)
		return null
	if _los_adapter == null:
		LogService.warning(
			"AIController missing LOSAdapter; TaskWait until_contact will be blind.",
			"AIController.gd:create_agent"
		)
	var agent := AIAgent.new()
	agent.unit_id = unit_id
	agent.bind_adapters(_movement_adapter, _combat_adapter, _los_adapter, _orders_router)
	if _agents_root and is_instance_valid(_agents_root):
		_agents_root.add_child(agent)
	else:
		add_child(agent)
	return agent


func _resolve_context_nodes() -> void:
	_sim = sim_world_ref if sim_world_ref else _get_node_from_path(sim_world_path) as SimWorld
	if _sim == null:
		_sim = get_tree().get_root().find_child("SimWorld", true, false)
	_ensure_adapter_cache()


func _ensure_adapter_cache() -> void:
	if _movement_adapter == null:
		_movement_adapter = movement_adapter_ref
	if _movement_adapter == null and not movement_adapter_path.is_empty():
		_movement_adapter = _get_node_from_path(movement_adapter_path) as MovementAdapter
	if _combat_adapter == null:
		_combat_adapter = combat_adapter_ref
	if _combat_adapter == null and not combat_adapter_path.is_empty():
		_combat_adapter = _get_node_from_path(combat_adapter_path) as CombatAdapter
	if _los_adapter == null:
		_los_adapter = los_adapter_ref
	if _los_adapter == null and not los_adapter_path.is_empty():
		_los_adapter = _get_node_from_path(los_adapter_path) as LOSAdapter
	if _orders_router == null:
		_orders_router = orders_router_ref
	if _orders_router == null and not orders_router_path.is_empty():
		_orders_router = _get_node_from_path(orders_router_path) as OrdersRouter
	if _agents_root == null:
		_agents_root = agents_root_ref
	if _agents_root == null:
		var node := _get_node_from_path(agents_root_path)
		_agents_root = node if node else self


func _get_node_from_path(path: NodePath) -> Node:
	if path.is_empty():
		return null
	return get_node_or_null(path)


## Rebuild the ScenarioUnit id -> index cache for quick lookups.
func refresh_unit_index_cache() -> void:
	_unit_index_cache.clear()
	if Game.current_scenario == null:
		return
	var units: Array = Game.current_scenario.units
	for i in units.size():
		var su: ScenarioUnit = units[i]
		if su == null:
			continue
		if su.id == null or String(su.id).is_empty():
			continue
		_unit_index_cache[String(su.id)] = i


## Register trigger/task sync so tasks stay blocked until trigger activates.
## [param per_unit] Dictionary returned from build_per_unit_queues.
## [param triggers] Scenario triggers.
func apply_trigger_sync(per_unit: Dictionary, triggers: Array) -> void:
	_initial_blocks_by_unit.clear()
	_blocked_triggers.clear()
	if triggers == null:
		return
	var owner_by_task: Dictionary = {}
	for uid in per_unit.keys():
		var tasks: Array = per_unit[uid]
		for task in tasks:
			var idx := int(task.get("__src_index", -1))
			if idx < 0:
				continue
			owner_by_task[idx] = uid
	for trig in triggers:
		if trig == null:
			continue
		var tid := String(trig.id)
		for tidx in trig.synced_tasks:
			var idx := int(tidx)
			var uid := int(owner_by_task.get(idx, -1))
			if uid < 0:
				continue
			if not _initial_blocks_by_unit.has(uid):
				_initial_blocks_by_unit[uid] = []
			(_initial_blocks_by_unit[uid] as Array).append(idx)
			if not _blocked_triggers.has(tid):
				_blocked_triggers[tid] = []
			(_blocked_triggers[tid] as Array).append({"unit_id": uid, "task_index": idx})


## Bind TriggerEngine to receive trigger_activated notifications.
func bind_trigger_engine(engine: TriggerEngine) -> void:
	if engine == null:
		return
	if not engine.trigger_activated.is_connected(_on_trigger_activated):
		engine.trigger_activated.connect(_on_trigger_activated)


## Bind environment behaviour system signals (placeholder).
func bind_env_behavior_system(_env_sys: Node) -> void:
	if _env_sys == null:
		return
	if not _env_sys.is_connected("unit_lost", Callable(self, "_on_unit_lost")):
		_env_sys.unit_lost.connect(_on_unit_lost)
	if not _env_sys.is_connected("unit_recovered", Callable(self, "_on_unit_recovered")):
		_env_sys.unit_recovered.connect(_on_unit_recovered)
	if not _env_sys.is_connected("unit_bogged", Callable(self, "_on_unit_bogged")):
		_env_sys.unit_bogged.connect(_on_unit_bogged)
	if not _env_sys.is_connected("unit_unbogged", Callable(self, "_on_unit_unbogged")):
		_env_sys.unit_unbogged.connect(_on_unit_unbogged)
	_env_behavior_system = _env_sys


## Handle unit lost event (placeholder).
func _on_unit_lost(_unit_id: String) -> void:
	var idx := _uid_to_index(_unit_id)
	if idx >= 0:
		pause_unit(idx)


## Handle unit recovered event (placeholder).
func _on_unit_recovered(_unit_id: String) -> void:
	var idx := _uid_to_index(_unit_id)
	if idx >= 0:
		resume_unit(idx)


## Handle unit bogged event (placeholder).
func _on_unit_bogged(_unit_id: String) -> void:
	var idx := _uid_to_index(_unit_id)
	if idx >= 0:
		pause_unit(idx)


## Handle unit unbogged event (placeholder).
func _on_unit_unbogged(_unit_id: String) -> void:
	var idx := _uid_to_index(_unit_id)
	if idx >= 0:
		resume_unit(idx)


## Apply navigation bias intent from orders (placeholder).
func apply_navigation_bias_from_order(_unit_id: String, _bias: StringName) -> void:
	if _env_behavior_system and _env_behavior_system.has_method("set_navigation_bias"):
		_env_behavior_system.set_navigation_bias(_unit_id, _bias)


func _uid_to_index(uid: String) -> int:
	if uid == "":
		return -1
	var idx := int(_unit_index_cache.get(uid, -1))
	if idx == -1:
		refresh_unit_index_cache()
		idx = int(_unit_index_cache.get(uid, -1))
	return idx
