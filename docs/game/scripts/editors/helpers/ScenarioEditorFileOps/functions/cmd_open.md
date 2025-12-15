# ScenarioEditorFileOps::cmd_open Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorFileOps.gd` (lines 74–79)</br>
*Belongs to:* [ScenarioEditorFileOps](../../ScenarioEditorFileOps.md)

**Signature**

```gdscript
func cmd_open() -> void
```

## Description

Show Open dialog (asks to discard if dirty).

## Source

```gdscript
func cmd_open() -> void:
	if dirty and not await confirm_discard():
		return
	open_dlg.popup_centered_ratio(0.75)
```
