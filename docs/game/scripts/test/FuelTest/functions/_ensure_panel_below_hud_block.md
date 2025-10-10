# FuelTest::_ensure_panel_below_hud_block Function Reference

*Defined at:* `scripts/test/FuelTest.gd` (lines 153–178)</br>
*Belongs to:* [FuelTest](../../FuelTest.md)

**Signature**

```gdscript
func _ensure_panel_below_hud_block() -> void
```

## Source

```gdscript
func _ensure_panel_below_hud_block() -> void:
	var hud := get_node_or_null("CanvasLayer/HUD") as Control
	if hud == null:
		return

	panel = _find_panel(
		[
			"CanvasLayer/HUD/FuelRefuelPanel",
			"CanvasLayer/HUD/Panel/FuelRefuelPanel",
			"CanvasLayer/HUD/Panel/Pad/VBox/FuelRefuelPanel"
		]
	)

	if panel == null:
		var PanelScene: PackedScene = preload("res://scenes/ui/fuel_refuel_panel.tscn")
		panel = PanelScene.instantiate() as FuelRefuelPanel
		panel.name = "FuelRefuelPanel"
		hud.add_child(panel)
	elif panel.get_parent() != hud:
		panel.get_parent().remove_child(panel)
		hud.add_child(panel)

	# place after layout settles
	call_deferred("_position_fuel_panel_below_hud", 110.0, 160.0, 440.0, 10.0)
```
