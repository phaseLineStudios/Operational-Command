# TriggerEngine::_ready Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 30–37)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Wire API.

## Source

```gdscript
func _ready() -> void:
	_api.sim = _sim
	_api.engine = self
	_vm.set_api(_api)
	# Always process to track real-time for sleep_ui
	set_process(true)
```
