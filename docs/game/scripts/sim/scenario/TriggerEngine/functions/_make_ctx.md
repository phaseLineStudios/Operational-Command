# TriggerEngine::_make_ctx Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 171–189)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func _make_ctx(t: ScenarioTrigger, presence_ok: bool) -> Dictionary
```

- **t**: Trigger to create context for.
- **presence_ok**: Check if presence check is ok.
- **Return Value**: trigger context.

## Description

Build a context to pass to trigger eval.

## Source

```gdscript
func _make_ctx(t: ScenarioTrigger, presence_ok: bool) -> Dictionary:
	var counts := _counts_in_area(t.area_center_m, t.area_size_m, t.area_shape)
	var ctx := {
		"trigger_id": t.id,
		"title": t.title,
		"center": t.area_center_m,
		"size": t.area_size_m,
		"presence_ok": presence_ok,
		"count_friend": counts.friend,
		"count_enemy": counts.enemy,
		"count_player": counts.player,
	}
	# Include all global variables in context for easy access
	for key in _globals.keys():
		if not ctx.has(key):  # Don't override built-in context vars
			ctx[key] = _globals[key]
	return ctx
```
