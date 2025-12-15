# TriggerEngine::activate_trigger Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 325–337)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func activate_trigger(trigger_id: String) -> bool
```

- **trigger_id**: ID of the trigger to activate.
- **Return Value**: True if trigger was found and activated.

## Description

Manually activate a trigger by ID.
Forces a trigger to become active and run its on_activate expression.
Used by custom voice commands to fire specific triggers.

## Source

```gdscript
func activate_trigger(trigger_id: String) -> bool:
	if not _scenario:
		return false
	for t in _scenario.triggers:
		if t.id == trigger_id and not t._active:
			t._active = true
			var ctx := _make_ctx(t, false)
			_vm.run(t.on_activate_expr, ctx)
			LogService.trace("Manually activated trigger: %s" % trigger_id, "TriggerEngine.gd")
			return true
	return false
```
