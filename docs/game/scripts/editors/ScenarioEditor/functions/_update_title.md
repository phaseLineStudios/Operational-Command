# ScenarioEditor::_update_title Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 741–744)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _update_title() -> void
```

## Description

Update window title label from scenario title

## Source

```gdscript
func _update_title() -> void:
	title_label.text = ctx.data.title if ctx.data else "Scenario"
```
