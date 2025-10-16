# BriefingDialog::_collect_into_working Function Reference

*Defined at:* `scripts/editors/BriefingDialog.gd` (lines 97–108)</br>
*Belongs to:* [BriefingDialog](../../BriefingDialog.md)

**Signature**

```gdscript
func _collect_into_working() -> void
```

## Description

Collect UI -> working copy.

## Source

```gdscript
func _collect_into_working() -> void:
	working.title = title_input.text.strip_edges()
	working.frag_enemy = enemy_input.text.strip_edges()
	working.frag_friendly = friendly_input.text.strip_edges()
	working.frag_terrain = terrain_input.text.strip_edges()
	working.frag_mission = mission_input.text.strip_edges()
	working.frag_execution = execution_input.text.strip_edges()
	working.frago_logi = admin_logi_input.text.strip_edges()
	if working.frag_objectives == null:
		working.frag_objectives = []
```
