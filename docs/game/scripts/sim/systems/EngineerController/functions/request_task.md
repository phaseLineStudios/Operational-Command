# EngineerController::request_task Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 99–150)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

**Signature**

```gdscript
func request_task(unit_id: String, task_type: String, target_pos: Vector2) -> bool
```

## Description

Request an engineer task
Returns true if accepted, false if unable to comply

## Source

```gdscript
func request_task(unit_id: String, task_type: String, target_pos: Vector2) -> bool:
	var su: ScenarioUnit = _units.get(unit_id)
	if not su:
		LogService.warning("Engineer task failed: unit not found", "EngineerController")
		return false

	if not _engineer_units.get(unit_id, false):
		LogService.warning("Engineer task failed: unit not engineer", "EngineerController")
		return false

	var ammo_type := ""
	var duration := 0.0
	match task_type.to_upper():
		"MINE", "LAY_MINE":
			ammo_type = "ENGINEER_MINE"
			duration = mine_duration
		"DEMO", "DEMOLITION":
			ammo_type = "ENGINEER_DEMO"
			duration = demo_duration
		"BRIDGE", "BUILD_BRIDGE":
			ammo_type = "ENGINEER_BRIDGE"
			duration = bridge_duration
		_:
			LogService.warning("Engineer task failed: unknown task type", "EngineerController")
			return false

	var current_ammo: int = su.state_ammunition.get(ammo_type, 0)
	if current_ammo < 1:
		LogService.warning("Engineer task failed: no %s ammo" % ammo_type, "EngineerController")
		return false

	if _ammo_system:
		if not _ammo_system.consume(unit_id, ammo_type, 1):
			LogService.warning(
				"Engineer task ammo consumption failed for %s" % unit_id, "EngineerController"
			)
			return false

	var task := EngineerTask.new(unit_id, task_type, target_pos, duration)
	_active_tasks.append(task)

	LogService.debug("Emitting task_confirmed for %s" % unit_id, "EngineerController")
	emit_signal("task_confirmed", unit_id, task_type, target_pos)

	LogService.info(
		"Engineer task: %s performing %s at %s" % [unit_id, task_type, target_pos],
		"EngineerController"
	)

	return true
```
