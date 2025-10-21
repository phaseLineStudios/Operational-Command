# SetupController::_input Function Reference

*Defined at:* `scripts/test/PathTest.gd` (lines 47–56)</br>
*Belongs to:* [SetupController](../../SetupController.md)

**Signature**

```gdscript
func _input(e: InputEvent) -> void
```

## Source

```gdscript
func _input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		if renderer == null or unit == null:
			return
		var pos := (e as InputEventMouseButton).position
		if not renderer.is_inside_terrain(pos):
			LogService.warning("Outside terrain: " + str(pos), "PathTest.gd:51")
			return
		var terrain_pos := renderer.map_to_terrain(pos)
		unit.move_to_m(terrain_pos)
```
