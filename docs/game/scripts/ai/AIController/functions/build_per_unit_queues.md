# AIController::build_per_unit_queues Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 134–187)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func build_per_unit_queues(flat_tasks: Array[Dictionary]) -> Dictionary
```

- **Return Value**: Dictionary: unit_index -> Array[Dictionary] (runner task dicts).

## Description

Build per-unit ordered queues from a flat list using unit_index and optional links.
Build per-unit ordered queues from a flat list of ScenarioData.tasks.
Uses unit_index and prev/next_index to form a deterministic chain.

## Source

```gdscript
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
```
