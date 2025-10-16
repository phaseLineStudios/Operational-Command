# BriefingDialog::_reset_ui Function Reference

*Defined at:* `scripts/editors/BriefingDialog.gd` (lines 80–95)</br>
*Belongs to:* [BriefingDialog](../../BriefingDialog.md)

**Signature**

```gdscript
func _reset_ui() -> void
```

## Description

Clear UI to defaults.

## Source

```gdscript
func _reset_ui() -> void:
	for node in [
		title_input,
		enemy_input,
		friendly_input,
		terrain_input,
		mission_input,
		execution_input,
		admin_logi_input
	]:
		if node:
			node.text = ""
	for c in objectives_vbox.get_children():
		c.queue_free()
```
