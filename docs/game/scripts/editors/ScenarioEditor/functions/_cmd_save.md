# ScenarioEditor::_cmd_save Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 658–669)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _cmd_save() -> void
```

## Description

Save to current path or fallback to Save As

## Source

```gdscript
func _cmd_save() -> void:
	if _current_path.strip_edges() == "":
		_cmd_save_as()
		return
	if ctx.data == null:
		_show_info("No scenario to save.")
		return
	if persistence.save_to_path(ctx, _current_path):
		_dirty = false
		_show_info("Saved: %s" % _current_path)
```
