# ScenarioTrigger::deserialize Function Reference

*Defined at:* `scripts/editors/triggers/ScenarioTrigger.gd` (lines 74–102)</br>
*Belongs to:* [ScenarioTrigger](../../ScenarioTrigger.md)

**Signature**

```gdscript
func deserialize(d: Variant) -> ScenarioTrigger
```

## Source

```gdscript
static func deserialize(d: Variant) -> ScenarioTrigger:
	if typeof(d) != TYPE_DICTIONARY:
		return null
	var t := ScenarioTrigger.new()
	t.id = d.get("id", "")
	t.title = d.get("title", "Trigger")
	t.area_shape = int(d.get("shape", AreaShape.CIRCLE)) as AreaShape
	if d.has("area_center_m") and typeof(d["area_center_m"]) == TYPE_DICTIONARY:
		t.area_center_m = ContentDB.v2_from(d["area_center_m"])
	t.area_size_m = ContentDB.v2_from(d.get("size_m", Vector2.ZERO))
	t.presence = int(d.get("presence", 0)) as PresenceMode
	t.require_duration_s = float(d.get("require_duration_s", 0.0))
	t.run_once = bool(d.get("run_once", false))
	t.condition_expr = String(d.get("condition_expr", "true"))
	t.on_activate_expr = String(d.get("on_activate_expr", ""))
	t.on_deactivate_expr = String(d.get("on_deactivate_expr", ""))
	var su = d.get("synced_units", [])
	if typeof(su) == TYPE_ARRAY:
		var out_u: Array[int] = []
		for v in su:
			out_u.append(int(v))
		t.synced_units = out_u
	var st = d.get("synced_tasks", [])
	if typeof(st) == TYPE_ARRAY:
		var out_t: Array[int] = []
		for v in st:
			out_t.append(int(v))
		t.synced_tasks = out_t
	return t
```
