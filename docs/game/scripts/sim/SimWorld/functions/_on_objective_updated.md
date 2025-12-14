# SimWorld::_on_objective_updated Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 170–173)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _on_objective_updated(_id: String, _obj_state: int) -> void
```

- **_id**: Id of updated objective.
- **_obj_state**: New state of objective.

## Description

Immidiatly check if mission is completed on objective state change.

## Source

```gdscript
func _on_objective_updated(_id: String, _obj_state: int) -> void:
	_mission_complete_check(0.0)
```
