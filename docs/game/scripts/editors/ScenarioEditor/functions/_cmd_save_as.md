# ScenarioEditor::_cmd_save_as Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 671–678)</br>
*Belongs to:* [ScenarioEditor](../ScenarioEditor.md)

**Signature**

```gdscript
func _cmd_save_as() -> void
```

## Description

Show Save As dialog with suggested filename

## Source

```gdscript
func _cmd_save_as() -> void:
	if ctx.data == null:
		_show_info("No scenario to save.")
		return
	_save_dlg.current_file = persistence.suggest_filename(ctx)
	_save_dlg.popup_centered_ratio(0.75)
```
