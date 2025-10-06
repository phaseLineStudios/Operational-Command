# ScenarioEditor::_show_info Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 890–896)</br>
*Belongs to:* [ScenarioEditor](../ScenarioEditor.md)

**Signature**

```gdscript
func _show_info(msg: String) -> void
```

## Description

Show a non-blocking info toast/dialog with a message

## Source

```gdscript
func _show_info(msg: String) -> void:
	var d := AcceptDialog.new()
	d.title = "Info"
	d.dialog_text = msg
	add_child(d)
```
