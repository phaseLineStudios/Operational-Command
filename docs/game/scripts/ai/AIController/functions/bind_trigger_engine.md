# AIController::bind_trigger_engine Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 496–500)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func bind_trigger_engine(engine: TriggerEngine) -> void
```

## Description

Bind TriggerEngine to receive trigger_activated notifications.

## Source

```gdscript
func bind_trigger_engine(engine: TriggerEngine) -> void:
	if engine == null:
		return
	if not engine.trigger_activated.is_connected(_on_trigger_activated):
		engine.trigger_activated.connect(_on_trigger_activated)
```
