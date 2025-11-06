# TriggerAPI::_on_engineer_task_completed Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 810–814)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func _on_engineer_task_completed(_unit_id: String, task_type: String, _target_pos: Vector2) -> void
```

## Description

Handle engineer task completion signal (internal).

## Source

```gdscript
func _on_engineer_task_completed(_unit_id: String, task_type: String, _target_pos: Vector2) -> void:
	if task_type.to_lower() == "bridge" or task_type.to_lower() == "build_bridge":
		_bridges_built += 1
```
