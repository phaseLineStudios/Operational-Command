# ObjectiveDialog::popup_edit Function Reference

*Defined at:* `scripts/editors/ObjectiveDialog.gd` (lines 47–56)</br>
*Belongs to:* [ObjectiveDialog](../../ObjectiveDialog.md)

**Signature**

```gdscript
func popup_edit(index: int, obj: ScenarioObjectiveData) -> void
```

- **index**: Row index in caller’s objectives list.
- **obj**: Objective to edit.

## Description

Open for editing an objective (prefills fields).

## Source

```gdscript
func popup_edit(index: int, obj: ScenarioObjectiveData) -> void:
	_mode = DialogMode.EDIT
	_edit_index = index
	_id.text = obj.id
	_title.text = obj.title
	_success.text = obj.success
	_score.value = obj.score
	popup_centered_ratio(0.55)
```
