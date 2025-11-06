# ScenarioEditorFileOps::cmd_save_as Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorFileOps.gd` (lines 64–71)</br>
*Belongs to:* [ScenarioEditorFileOps](../../ScenarioEditorFileOps.md)

**Signature**

```gdscript
func cmd_save_as() -> void
```

## Description

Show Save As dialog with suggested filename.

## Source

```gdscript
func cmd_save_as() -> void:
	if editor.ctx.data == null:
		_show_info("No scenario to save.")
		return
	save_dlg.current_file = editor.persistence.suggest_filename(editor.ctx)
	save_dlg.popup_centered_ratio(0.75)
```
