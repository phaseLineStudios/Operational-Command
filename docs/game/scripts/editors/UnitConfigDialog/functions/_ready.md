# UnitConfigDialog::_ready Function Reference

*Defined at:* `scripts/editors/UnitConfigDialog.gd` (lines 20–41)</br>
*Belongs to:* [UnitConfigDialog](../UnitConfigDialog.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	if aff_in.item_count == 0:
		aff_in.add_item("Friendly", ScenarioUnit.Affiliation.FRIEND)
		aff_in.add_item("Enemy", ScenarioUnit.Affiliation.ENEMY)

	if combat_in.item_count == 0:
		combat_in.add_item("Hold Fire", ScenarioUnit.CombatMode.FORCED_HOLD_FIRE)
		combat_in.add_item("Return Fire", ScenarioUnit.CombatMode.DO_NOT_FIRE_UNLESS_FIRED_UPON)
		combat_in.add_item("Open Fire", ScenarioUnit.CombatMode.OPEN_FIRE)

	if beh_in.item_count == 0:
		beh_in.add_item("Careless", ScenarioUnit.Behaviour.CARELESS)
		beh_in.add_item("Safe", ScenarioUnit.Behaviour.SAFE)
		beh_in.add_item("Aware", ScenarioUnit.Behaviour.AWARE)
		beh_in.add_item("Combat", ScenarioUnit.Behaviour.COMBAT)
		beh_in.add_item("Stealth", ScenarioUnit.Behaviour.STEALTH)

	save_btn.pressed.connect(_on_save)
	close_btn.pressed.connect(func(): visible = false)
	close_requested.connect(func(): visible = false)
```
