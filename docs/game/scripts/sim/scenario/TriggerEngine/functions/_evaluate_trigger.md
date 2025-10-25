# TriggerEngine::_evaluate_trigger Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 68–88)</br>
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
	var presence_ok := _check_presence(t)
	var ctx := _make_ctx(t, presence_ok)
	var condition_ok := _vm.eval_condition(t.condition_expr, ctx)
	var combined := presence_ok and condition_ok

	if combined:
		t._accum_true += dt
	else:
		t._accum_true = 0.0

	var passed: bool = combined and (t._accum_true >= max(0.0, t.require_duration_s))

	if not t._active and passed:
		t._active = true
		_vm.run(t.on_activate_expr, ctx)
	elif t._active and not combined:
		t._active = false
		_vm.run(t.on_deactivate_expr, ctx)
```
