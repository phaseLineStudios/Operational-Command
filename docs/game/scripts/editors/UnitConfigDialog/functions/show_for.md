# UnitConfigDialog::show_for Function Reference

*Defined at:* `scripts/editors/UnitConfigDialog.gd` (lines 43–68)</br>
*Belongs to:* [UnitConfigDialog](../../UnitConfigDialog.md)

**Signature**

```gdscript
func show_for(_editor: ScenarioEditor, index: int) -> void
```

## Description

Open dialog for a unit index in editor.ctx.data.units

## Source

```gdscript
func show_for(_editor: ScenarioEditor, index: int) -> void:
	editor = _editor
	unit_index = index
	var su: ScenarioUnit = editor.ctx.data.units[unit_index]
	_before = su.duplicate(true)

	callsign_in.text = su.callsign

	for i in aff_in.item_count:
		if aff_in.get_item_id(i) == int(su.affiliation):
			aff_in.select(i)
			break

	for i in combat_in.item_count:
		if combat_in.get_item_id(i) == int(su.combat_mode):
			combat_in.select(i)
			break

	for i in beh_in.item_count:
		if beh_in.get_item_id(i) == int(su.behaviour):
			beh_in.select(i)
			break

	visible = true
```
