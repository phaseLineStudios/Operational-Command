# ScenarioEditorFileOps::cmd_save Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorFileOps.gd` (lines 51–62)</br>
*Belongs to:* [ScenarioEditorFileOps](../../ScenarioEditorFileOps.md)

**Signature**

```gdscript
func cmd_save() -> void
```

## Description

Save to current path or fallback to Save As.

## Source

```gdscript
func cmd_save() -> void:
	if current_path.strip_edges() == "":
		cmd_save_as()
		return
	if editor.ctx.data == null:
		_show_info("No scenario to save.")
		return
	if editor.persistence.save_to_path(editor.ctx, current_path):
		dirty = false
		_show_info("Saved: %s" % current_path)
```
