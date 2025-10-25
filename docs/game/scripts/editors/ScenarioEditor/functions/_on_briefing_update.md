# ScenarioEditor::_on_briefing_update Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 744–753)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _on_briefing_update(new_brief: BriefData) -> void
```

## Description

Apply briefing change via history (undoable).

## Source

```gdscript
func _on_briefing_update(new_brief: BriefData) -> void:
	if ctx.data == null:
		return
	var before := ctx.data.briefing
	var label := "Create Briefing" if before == null else "Update Briefing"
	history.push_prop_set(ctx.data, "briefing", before, new_brief, label)
	_dirty = true
	_on_data_changed()
```
