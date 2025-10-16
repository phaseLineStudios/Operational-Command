# BriefingDialog::_on_objective_update Function Reference

*Defined at:* `scripts/editors/BriefingDialog.gd` (lines 167–174)</br>
*Belongs to:* [BriefingDialog](../../BriefingDialog.md)

**Signature**

```gdscript
func _on_objective_update(index: int, obj: ScenarioObjectiveData) -> void
```

## Description

Apply edited objective at index (preserve id if it existed).

## Source

```gdscript
func _on_objective_update(index: int, obj: ScenarioObjectiveData) -> void:
	if index < 0 or index >= working.frag_objectives.size():
		return

	working.frag_objectives[index] = obj
	_rebuild_objectives()
```
