# BriefingDialog::_on_objective_create Function Reference

*Defined at:* `scripts/editors/BriefingDialog.gd` (lines 161–165)</br>
*Belongs to:* [BriefingDialog](../../BriefingDialog.md)

**Signature**

```gdscript
func _on_objective_create(obj: ScenarioObjectiveData) -> void
```

## Description

Save `class ScenarioObjectiveData` to scenario.

## Source

```gdscript
func _on_objective_create(obj: ScenarioObjectiveData) -> void:
	working.frag_objectives.append(obj)
	_rebuild_objectives()
```

## References

- [`class ScenarioObjectiveData`](..\..\..\data\ScenarioObjectiveData.md)
