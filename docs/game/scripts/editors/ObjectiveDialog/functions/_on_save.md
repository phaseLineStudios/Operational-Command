# ObjectiveDialog::_on_save Function Reference

*Defined at:* `scripts/editors/ObjectiveDialog.gd` (lines 58–72)</br>
*Belongs to:* [ObjectiveDialog](../../ObjectiveDialog.md)

**Signature**

```gdscript
func _on_save() -> void
```

## Description

Called when user presses Save.

## Source

```gdscript
func _on_save() -> void:
	var o := ScenarioObjectiveData.new()
	o.id = _id.text.strip_edges()
	o.title = _title.text.strip_edges()
	o.success = _success.text.strip_edges()
	o.score = int(_score.value)

	if _mode == DialogMode.CREATE:
		emit_signal("request_create", o)
	else:
		emit_signal("request_update", _edit_index, o)

	hide()
```
