# BriefingDialog::_on_save Function Reference

*Defined at:* `scripts/editors/BriefingDialog.gd` (lines 176–184)</br>
*Belongs to:* [BriefingDialog](../../BriefingDialog.md)

**Signature**

```gdscript
func _on_save() -> void
```

## Description

Save current working copy and notify parent.

## Source

```gdscript
func _on_save() -> void:
	_collect_into_working()

	if String(working.id).strip_edges() == "":
		working.id = "%s_brief" % editor.ctx.data.title.to_lower().replace(" ", "_")
	emit_signal("request_update", working)
	show_dialog(false)
```
