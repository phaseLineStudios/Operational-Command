# AIController::normalize_tasks Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 199–283)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func normalize_tasks(flat_tasks: Array) -> Array[Dictionary]
```

## Description

Normalize ScenarioData.tasks entries (ScenarioTask resources or JSON dicts)
into runner-friendly dictionaries.
Supported task_type: move, defend, patrol, set_behaviour, set_combat_mode, wait
Convert ScenarioTask resources/JSON into runner dictionaries (TaskMove/Defend/...).
Supports: move, defend, patrol (ping_pong, dwell_s, loop_forever), set_behaviour,
set_combat_mode, wait (seconds, until_contact). Positions are terrain meters (Vector2).

## Source

```gdscript
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
```
