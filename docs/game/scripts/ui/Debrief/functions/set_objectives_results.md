# Debrief::set_objectives_results Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 126–157)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func set_objectives_results(results: Array) -> void
```

## Description

Populates the objectives list with checkmarks and crosses.
Accepted per-item shapes:
- String: "Seize objective"
- Dictionary: {"title": String, "completed": bool}
- Dictionary: {"objective": Object|Dictionary, "completed": bool}
For nested objects or dictionaries, "title" is preferred, then "name".

## Source

```gdscript
func set_objectives_results(results: Array) -> void:
	_objectives_list.clear()
	for r in results:
		var title := ""
		var completed := false

		if r is Dictionary:
			if r.has("title"):
				title = str(r["title"])
			elif r.has("objective"):
				var obj = r["objective"]
				if obj != null:
					if typeof(obj) == TYPE_DICTIONARY:
						if obj.has("title"):
							title = str(obj["title"])
						elif obj.has("name"):
							title = str(obj["name"])
					elif obj is Object:
						var t = obj.get("title")
						if t == null or str(t) == "":
							t = obj.get("name")
						title = str(t if t != null else "Objective")
			completed = bool(r.get("completed", false))
		else:
			title = str(r)

		var prefix := "✔ " if completed else "✖ "
		_objectives_list.add_item(prefix + title)

	_request_align()
```
