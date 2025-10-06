# UnitPlaceTool::_on_activated Function Reference

*Defined at:* `scripts/editors/tools/ScenarioUnitTool.gd` (lines 12–35)</br>
*Belongs to:* [UnitPlaceTool](../UnitPlaceTool.md)

**Signature**

```gdscript
func _on_activated() -> void
```

## Source

```gdscript
func _on_activated() -> void:
	if not payload:
		return
	if payload is UnitData:
		if editor.ctx.selected_unit_affiliation == ScenarioUnit.Affiliation.FRIEND:
			_icon_tex = payload.icon
		else:
			_icon_tex = payload.enemy_icon
	elif payload is UnitSlotData:
		_icon_tex = load("res://assets/textures/units/slot_icon.png") as Texture2D
	if _icon_tex == null:
		_icon_tex = (
			load(
				(
					"res://assets/textures/units/nato_unknown_platoon.png"
					if editor.ctx.selected_unit_affiliation == ScenarioUnit.Affiliation.FRIEND
					else "res://assets/textures/units/enemy_unknown_platoon.png"
				)
			)
			as Texture2D
		)
	emit_signal("request_redraw_overlay")
```
