# TriggerEngine::_evaluate_trigger Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 108–142)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func _evaluate_trigger(t: ScenarioTrigger, dt: float) -> void
```

- **t**: Trigger to evaluate.
- **dt**: Delta time since last tick.

## Description

Evaluate a ScenarioTrigger.

## Source

```gdscript
func _evaluate_trigger(t: ScenarioTrigger, dt: float) -> void:
	# Skip evaluation if this is a run_once trigger that has already run
	if t.run_once and t._has_run:
		return

	var presence_ok := _check_presence(t)
	var ctx := _make_ctx(t, presence_ok)

	# Build debug info for better error messages
	var debug_info := {"trigger_id": t.id, "trigger_title": t.title, "expr_type": "condition_expr"}

	var condition_ok := _vm.eval_condition(t.condition_expr, ctx, debug_info)
	var combined := presence_ok and condition_ok

	if combined:
		t._accum_true += dt
	else:
		t._accum_true = 0.0

	var passed: bool = combined and (t._accum_true >= max(0.0, t.require_duration_s))

	if not t._active and passed:
		t._active = true
		debug_info["expr_type"] = "on_activate_expr"
		_vm.run(t.on_activate_expr, ctx, debug_info)
		emit_signal("trigger_activated", t.id)
		# Mark as run if this is a run_once trigger
		if t.run_once:
			t._has_run = true
	elif t._active and not combined:
		t._active = false
		debug_info["expr_type"] = "on_deactivate_expr"
		_vm.run(t.on_deactivate_expr, ctx, debug_info)
```
