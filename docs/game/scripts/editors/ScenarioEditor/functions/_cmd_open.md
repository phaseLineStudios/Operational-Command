# ScenarioEditor::_cmd_open Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 680–685)</br>
*Belongs to:* [ScenarioEditor](../ScenarioEditor.md)

**Signature**

```gdscript
func _cmd_open() -> void
```

## Description

Show Open dialog (asks to discard if dirty)

## Source

```gdscript
func _cmd_open() -> void:
	if _dirty and not await _confirm_discard():
		return
	_open_dlg.popup_centered_ratio(0.75)
```
