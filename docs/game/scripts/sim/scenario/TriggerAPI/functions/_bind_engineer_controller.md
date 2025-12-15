# TriggerAPI::_bind_engineer_controller Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 624–628)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func _bind_engineer_controller(engineer_ctrl: EngineerController) -> void
```

- **engineer_ctrl**: EngineerController reference.

## Description

Bind to EngineerController to track bridge completions (internal, called by TriggerEngine).

## Source

```gdscript
func _bind_engineer_controller(engineer_ctrl: EngineerController) -> void:
	if engineer_ctrl and not engineer_ctrl.task_completed.is_connected(_on_engineer_task_completed):
		engineer_ctrl.task_completed.connect(_on_engineer_task_completed)
```
