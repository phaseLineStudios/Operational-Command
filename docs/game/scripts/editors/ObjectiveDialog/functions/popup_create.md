# ObjectiveDialog::popup_create Function Reference

*Defined at:* `scripts/editors/ObjectiveDialog.gd` (lines 34–43)</br>
*Belongs to:* [ObjectiveDialog](../../ObjectiveDialog.md)

**Signature**

```gdscript
func popup_create() -> void
```

## Description

Open for creating a new objective (clears fields).

## Source

```gdscript
func popup_create() -> void:
	_mode = DialogMode.CREATE
	_edit_index = -1
	_id.text = ""
	_title.text = ""
	_success.text = ""
	_score.value = 100
	popup_centered_ratio(0.55)
```
