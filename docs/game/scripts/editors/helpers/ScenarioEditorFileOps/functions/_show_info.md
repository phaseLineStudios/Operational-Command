# ScenarioEditorFileOps::_show_info Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorFileOps.gd` (lines 138–144)</br>
*Belongs to:* [ScenarioEditorFileOps](../../ScenarioEditorFileOps.md)

**Signature**

```gdscript
func _show_info(msg: String) -> void
```

- **msg**: Message to display.

## Description

Show a non-blocking info toast/dialog with a message.

## Source

```gdscript
func _show_info(msg: String) -> void:
	var d := AcceptDialog.new()
	d.title = "Info"
	d.dialog_text = msg
	editor.add_child(d)
```
