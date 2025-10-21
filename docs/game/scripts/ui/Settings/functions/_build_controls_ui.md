# Settings::_build_controls_ui Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 109–124)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _build_controls_ui() -> void
```

## Description

Create rebind buttons for actions.

## Source

```gdscript
func _build_controls_ui() -> void:
	for act in actions_to_rebind:
		if not InputMap.has_action(act):
			continue
		var row := HBoxContainer.new()
		var lab := Label.new()
		lab.text = act
		var btn := _rebind_template.duplicate() as Button
		btn.visible = true
		if btn.has_method("set_action"):
			btn.call("set_action", act)
		row.add_child(lab)
		row.add_child(btn)
		_controls_list.add_child(row)
```
