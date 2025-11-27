# ScenarioUnitsCatalog::_on_dialog_closed Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 173–177)</br>
*Belongs to:* [ScenarioUnitsCatalog](../../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func _on_dialog_closed(ctx: ScenarioEditorContext) -> void
```

## Description

Called when dialog is closed without saving

## Source

```gdscript
func _on_dialog_closed(ctx: ScenarioEditorContext) -> void:
	# Deselect so user can select another unit
	_deselect_unit(ctx)
```
