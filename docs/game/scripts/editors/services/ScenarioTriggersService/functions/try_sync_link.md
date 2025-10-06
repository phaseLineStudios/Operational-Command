# ScenarioTriggersService::try_sync_link Function Reference

*Defined at:* `scripts/editors/services/ScenarioTriggersService.gd` (lines 51–81)</br>
*Belongs to:* [ScenarioTriggersService](../ScenarioTriggersService.md)

**Signature**

```gdscript
func try_sync_link(ctx: ScenarioEditorContext, a: Dictionary, b: Dictionary) -> void
```

## Source

```gdscript
func try_sync_link(ctx: ScenarioEditorContext, a: Dictionary, b: Dictionary) -> void:
	if a.is_empty() or b.is_empty():
		return
	var ta := StringName(a.get("type", ""))
	var tb := StringName(b.get("type", ""))
	if ta == tb and ta != &"trigger":
		return
	if ta != &"trigger" and tb != &"trigger":
		return
	var trig_idx := int(a["index"]) if ta == &"trigger" else int(b["index"])
	var unit_idx := int(b["index"]) if tb == &"unit" else (int(a["index"]) if ta == &"unit" else -1)
	var task_idx := int(b["index"]) if tb == &"task" else (int(a["index"]) if ta == &"task" else -1)
	if ctx.data == null or ctx.data.triggers == null:
		return
	if trig_idx < 0 or trig_idx >= ctx.data.triggers.size():
		return
	var trig: ScenarioTrigger = ctx.data.triggers[trig_idx]
	if trig == null:
		return
	if unit_idx >= 0:
		if trig.synced_units == null:
			trig.synced_units = []
		if not trig.synced_units.has(unit_idx):
			trig.synced_units.append(unit_idx)
	if task_idx >= 0:
		if trig.synced_tasks == null:
			trig.synced_tasks = []
		if not trig.synced_tasks.has(task_idx):
			trig.synced_tasks.append(task_idx)
	ctx.request_overlay_redraw()
	ctx.request_scene_tree_rebuild()
```
