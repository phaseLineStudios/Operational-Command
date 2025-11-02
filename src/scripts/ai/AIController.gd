extends Node
class_name AIController
## Enemy AI task manager with Cold War doctrine behaviors.
##
## Maintains a rolling task list (defend, attack, delay, ambush) and reacts to
## player activity and simulation feedback to re-plan routes and objectives.

## Coordinates per-unit ScenarioTaskRunner and AIAgent to execute authored task chains.

var _runners: Dictionary = {}   ## unit_id -> ScenarioTaskRunner
var _agents: Dictionary = {}    ## unit_id -> AIAgent

func register_unit(unit_id: int, agent: AIAgent, ordered_tasks: Array[Dictionary]) -> void:
	if _runners.has(unit_id):
		unregister_unit(unit_id)
	var runner := ScenarioTaskRunner.new()
	add_child(runner)
	runner.setup(unit_id, ordered_tasks)
	_runners[unit_id] = runner
	_agents[unit_id] = agent

func unregister_unit(unit_id: int) -> void:
	if _runners.has(unit_id):
		var r: ScenarioTaskRunner = _runners[unit_id]
		_runners.erase(unit_id)
		if is_instance_valid(r):
			r.queue_free()
	_agents.erase(unit_id)

func is_unit_idle(unit_id: int) -> bool:
	if not _runners.has(unit_id):
		return true
	return _runners[unit_id].is_idle()

func pause_unit(unit_id: int) -> void:
	if _runners.has(unit_id):
		_runners[unit_id].pause()

func resume_unit(unit_id: int) -> void:
	if _runners.has(unit_id):
		_runners[unit_id].resume()

func cancel_active(unit_id: int) -> void:
	if _runners.has(unit_id):
		_runners[unit_id].cancel_active()

func advance_unit(unit_id: int) -> void:
	if _runners.has(unit_id):
		_runners[unit_id].advance()

## Build per-unit ordered queues from a flat list using unit_index and optional links.
func build_per_unit_queues(flat_tasks: Array[Dictionary]) -> Dictionary:
	var grouped: Dictionary = {}  ## unit_id -> Array[Dictionary]
	for t in flat_tasks:
		var uid: int = int(t.get("unit_index", -1))
		if not grouped.has(uid):
			grouped[uid] = []
		(grouped[uid] as Array).append(t)

	for uid in grouped.keys():
		var tasks: Array = grouped[uid] as Array
		tasks.sort_custom(Callable(self, "_cmp_by_index"))

		var has_links: bool = false
		for tt in tasks:
			var d: Dictionary = tt
			if d.has("prev_index") or d.has("next_index"):
				has_links = true
				break

		if has_links:
			var by_index: Dictionary = {}
			var all_indices: Array[int] = []
			for tt in tasks:
				var d2: Dictionary = tt
				var idx: int = int(d2.get("index", 0))
				by_index[idx] = d2
				all_indices.append(idx)

			var pointed: Dictionary = {}  ## indices that are targets of prev_index
			for tt in tasks:
				var prev_v: Variant = (tt as Dictionary).get("prev_index", null)
				if prev_v != null:
					pointed[int((tt as Dictionary).get("index", 0))] = true

			var head_index: int = -1
			for idx2 in all_indices:
				if not pointed.has(idx2):
					head_index = idx2
					break
			if head_index == -1 and not all_indices.is_empty():
				head_index = all_indices.front()

			var ordered: Array[Dictionary] = []
			var cursor: int = head_index
			var safety: int = 0
			while safety < tasks.size():
				var cur_task: Dictionary = by_index.get(cursor, {})
				if cur_task.is_empty():
					break
				ordered.append(cur_task)
				var maybe_next: Variant = cur_task.get("next_index", null)
				if maybe_next == null:
					break
				cursor = int(maybe_next)
				safety += 1
			grouped[uid] = ordered
		else:
			grouped[uid] = tasks

	return grouped

static func _cmp_by_index(a: Dictionary, b: Dictionary) -> bool:
	return int(a.get("index", 0)) < int(b.get("index", 0))

func _physics_process(dt: float) -> void:
	for uid in _runners.keys():
		var runner: ScenarioTaskRunner = _runners[uid]
		var agent: AIAgent = _agents.get(uid, null)
		if agent == null:
			continue
		runner.tick(dt, agent)
