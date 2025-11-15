# ScenarioEditorOverlay::_get_scaled_icon_task Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 669–679)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _get_scaled_icon_task(inst: ScenarioTask) -> Texture2D
```

## Description

Get (and cache) the scaled inner task icon

## Source

```gdscript
func _get_scaled_icon_task(inst: ScenarioTask) -> Texture2D:
	if not inst or not inst.task or not inst.task.icon:
		return null
	var base: Texture2D = inst.task.icon
	var key := (
		"TASK:%s:%s:%d"
		% [String(inst.task.type_id), String(inst.task.resource_path), task_icon_inner_px]
	)
	return _scaled_cached(key, base, task_icon_inner_px)
```
