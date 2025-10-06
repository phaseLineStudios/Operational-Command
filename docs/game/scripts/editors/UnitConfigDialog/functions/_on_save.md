# UnitConfigDialog::_on_save Function Reference

*Defined at:* `scripts/editors/UnitConfigDialog.gd` (lines 69–92)</br>
*Belongs to:* [UnitConfigDialog](../UnitConfigDialog.md)

**Signature**

```gdscript
func _on_save() -> void
```

## Source

```gdscript
func _on_save() -> void:
	if not editor or unit_index < 0:
		return
	var su_live: ScenarioUnit = editor.ctx.data.units[unit_index]
	var after := su_live.duplicate(true)
	after.callsign = callsign_in.text.strip_edges()
	after.affiliation = aff_in.get_selected_id() as ScenarioUnit.Affiliation
	after.combat_mode = combat_in.get_selected_id() as ScenarioUnit.CombatMode
	after.behaviour = beh_in.get_selected_id() as ScenarioUnit.Behaviour

	if editor.history:
		var desc := "Edit Unit %s" % String(_before.callsign)
		editor.history.push_res_edit_by_id(
			editor.ctx.data, "units", "id", String(su_live.id), _before, after, desc
		)
	else:
		su_live.callsign = after.callsign
		su_live.affiliation = after.affiliation
		su_live.combat_mode = after.combat_mode
		su_live.behaviour = after.behaviour

	visible = false
	editor.ctx.request_overlay_redraw()
	editor._rebuild_scene_tree()
```
