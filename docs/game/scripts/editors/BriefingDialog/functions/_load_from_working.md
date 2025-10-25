# BriefingDialog::_load_from_working Function Reference

*Defined at:* `scripts/editors/BriefingDialog.gd` (lines 65–78)</br>
*Belongs to:* [BriefingDialog](../../BriefingDialog.md)

**Signature**

```gdscript
func _load_from_working() -> void
```

## Description

Load UI from working copy.

## Source

```gdscript
func _load_from_working() -> void:
	title_input.text = String(working.title)
	enemy_input.text = String(working.frag_enemy)
	friendly_input.text = String(working.frag_friendly)
	terrain_input.text = String(working.frag_terrain)
	mission_input.text = String(working.frag_mission)
	execution_input.text = String(working.frag_execution)
	admin_logi_input.text = String(working.frago_logi)

	if working.frag_objectives == null:
		working.frag_objectives = []
	_rebuild_objectives()
```
