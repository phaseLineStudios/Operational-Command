# TriggerConfigDialog::show_for Function Reference

*Defined at:* `scripts/editors/TriggerConfigDialog.gd` (lines 30–57)</br>
*Belongs to:* [TriggerConfigDialog](../TriggerConfigDialog.md)

**Signature**

```gdscript
func show_for(_editor: ScenarioEditor, index: int) -> void
```

## Source

```gdscript
func show_for(_editor: ScenarioEditor, index: int) -> void:
	if _editor == null or index < 0 or index >= _editor.ctx.data.triggers.size():
		return
	editor = _editor
	trigger_index = index

	var trig: ScenarioTrigger = editor.ctx.data.triggers[trigger_index]
	_before = trig.duplicate(true)

	trig_title.text = trig.title
	trig_presence.clear()
	for i in ScenarioTrigger.PresenceMode.size():
		trig_presence.add_item(str(ScenarioTrigger.PresenceMode.keys()[i]).capitalize(), i)
	trig_presence.select(int(trig.presence))
	trig_shape.clear()
	for i in ScenarioTrigger.AreaShape.size():
		trig_shape.add_item(str(ScenarioTrigger.AreaShape.keys()[i]).capitalize(), i)
	trig_shape.select(int(trig.area_shape))
	trig_size_x.value = trig.area_size_m.x
	trig_size_y.value = trig.area_size_m.y
	trig_duration.value = trig.require_duration_s
	trig_condition.text = trig.condition_expr
	trig_on_activate.text = trig.on_activate_expr
	trig_on_deactivate.text = trig.on_deactivate_expr

	visible = true
```
