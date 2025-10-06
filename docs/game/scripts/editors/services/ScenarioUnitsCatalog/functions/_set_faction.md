# ScenarioUnitsCatalog::_set_faction Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 45–51)</br>
*Belongs to:* [ScenarioUnitsCatalog](../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func _set_faction(ctx: ScenarioEditorContext, aff) -> void
```

## Source

```gdscript
func _set_faction(ctx: ScenarioEditorContext, aff) -> void:
	ctx.selected_unit_affiliation = aff
	ctx.unit_faction_friend.set_pressed_no_signal(aff == ScenarioUnit.Affiliation.FRIEND)
	ctx.unit_faction_enemy.set_pressed_no_signal(aff == ScenarioUnit.Affiliation.ENEMY)
	_refresh(ctx)
```
