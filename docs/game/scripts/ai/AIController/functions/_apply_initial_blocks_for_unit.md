# AIController::_apply_initial_blocks_for_unit Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 358–369)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _apply_initial_blocks_for_unit(unit_id: int) -> void
```

## Source

```gdscript
func _apply_initial_blocks_for_unit(unit_id: int) -> void:
	var idxs: Array = _initial_blocks_by_unit.get(unit_id, [])
	if idxs.is_empty():
		return
	var runner: ScenarioTaskRunner = _runners.get(unit_id, null)
	if runner == null:
		return
	for idx in idxs:
		runner.block_task_index(int(idx), true)
	_initial_blocks_by_unit.erase(unit_id)
```
