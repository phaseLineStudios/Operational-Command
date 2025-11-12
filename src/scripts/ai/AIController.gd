class_name AIController
extends Node
## Enemy AI task manager with Cold War doctrine behaviors.
##
## Maintains a rolling task list (defend, attack, delay, ambush) and reacts to
## player activity and simulation feedback to re-plan routes and objectives.

## Coordinates per-unit ScenarioTaskRunner and AIAgent to execute authored task chains.

## Seconds a RETURN_FIRE unit may fire after being attacked.
@export var return_fire_window_sec: float = 5.0
## Active task runners per unit id.
var _runners: Dictionary = {}  ## unit_id -> ScenarioTaskRunner
## AI agents per unit id.
var _agents: Dictionary = {}  ## unit_id -> AIAgent
## Temporary return-fire flags: { uid:int, key:String, expire:float }.
var _recent_attack_marks: Array = []  ## Array of { uid:int, key:String, expire:float }


## Initialize controller and subscribe to sim engagement events for RETURN_FIRE.
func _ready() -> void:
	# Wire return-fire window from SimWorld engagement events
	var sim: SimWorld = get_tree().get_root().find_child("SimWorld", true, false)
	if sim and not sim.engagement_reported.is_connected(_on_engagement_reported):
		sim.engagement_reported.connect(_on_engagement_reported)


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


## Unregister and free the runner/agent for a unit id (idempotent).
func unregister_unit(unit_id: int) -> void:
	if _runners.has(unit_id):
		var r: ScenarioTaskRunner = _runners[unit_id]
		_runners.erase(unit_id)
		if is_instance_valid(r):
			r.queue_free()
	_agents.erase(unit_id)


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
	# Allow RETURN_FIRE units to respond for a short window
	# defender_id maps to ScenarioUnit.id; our dictionary keys are unit indices, so search
	for uid in _agents.keys():
		var agent: AIAgent = _agents[uid]
		if agent == null:
			continue
		var su: ScenarioUnit = null
		if Game.current_scenario and Game.current_scenario.units.size() > uid:
			su = Game.current_scenario.units[uid]
		if su and su.id == defender_id:
			# Mark defender as recently attacked by this attacker (for Combat.gd's return-fire check)
			var key := "recently_attacked_" + String(attacker_id)
			su.set_meta(key, true)
			(
				_recent_attack_marks
				. append(
					{
						"uid": uid,
						"key": key,
						"expire": (Time.get_ticks_msec() / 1000.0) + return_fire_window_sec,
					}
				)
			)
			# Also unlock RETURN_FIRE via CombatAdapter path
			agent.notify_hostile_shot()
			break


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
