# ScenarioEditor::_on_briefing_update Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 406–415)</br>
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
	file_ops.mark_dirty()
	_on_data_changed()
```
