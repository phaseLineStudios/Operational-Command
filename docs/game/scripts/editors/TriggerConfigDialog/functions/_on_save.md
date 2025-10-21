# TriggerConfigDialog::_on_save Function Reference

*Defined at:* `scripts/editors/TriggerConfigDialog.gd` (lines 58–90)</br>
*Belongs to:* [TriggerConfigDialog](../../TriggerConfigDialog.md)

**Signature**

```gdscript
func _on_save() -> void
```

## Source

```gdscript
func _on_save() -> void:
	if editor == null or trigger_index < 0 or trigger_index >= editor.ctx.data.triggers.size():
		return
	var live: ScenarioTrigger = editor.ctx.data.triggers[trigger_index]

	var after := live.duplicate(true)
	after.title = trig_title.text
	after.area_shape = trig_shape.get_selected_id() as ScenarioTrigger.AreaShape
	after.area_size_m = Vector2(trig_size_x.value, trig_size_y.value)
	after.require_duration_s = trig_duration.value
	after.presence = trig_presence.get_selected_id() as ScenarioTrigger.PresenceMode
	after.condition_expr = trig_condition.text
	after.on_activate_expr = trig_on_activate.text
	after.on_deactivate_expr = trig_on_deactivate.text

	if editor.history:
		var desc := "Edit Trigger %s" % String(_before.id)
		editor.history.push_res_edit_by_id(
			editor.ctx.data, "triggers", "id", String(live.id), _before, after, desc
		)
	else:
		live.title = after.title
		live.area_shape = after.area_shape
		live.area_size_m = after.area_size_m
		live.require_duration_s = after.require_duration_s
		live.presence = after.presence
		live.condition_expr = after.condition_expr
		live.on_activate_expr = after.on_activate_expr
		live.on_deactivate_expr = after.on_deactivate_expr

	emit_signal("saved", trigger_index, after)
	visible = false
	editor.ctx.request_overlay_redraw()
```
