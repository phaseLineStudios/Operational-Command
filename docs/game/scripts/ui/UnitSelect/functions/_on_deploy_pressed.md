# UnitSelect::_on_deploy_pressed Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 393–401)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _on_deploy_pressed() -> void
```

## Description

Deploy current loadout if slots are filled

## Source

```gdscript
func _on_deploy_pressed() -> void:
	# Only when all slots filled
	if _assigned_by_unit.size() != _total_slots:
		return
	var loadout := _export_loadout()
	Game.set_scenario_loadout(loadout)
	Game.goto_scene(SCENE_HQ_TABLE)
```
