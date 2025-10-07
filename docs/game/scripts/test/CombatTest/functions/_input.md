# CombatTest::_input Function Reference

*Defined at:* `scripts/test/CombatTest.gd` (lines 71–88)</br>
*Belongs to:* [CombatTest](../../CombatTest.md)

**Signature**

```gdscript
func _input(e: InputEvent) -> void
```

## Source

```gdscript
func _input(e: InputEvent) -> void:
	if not (e is InputEventMouseButton and e.pressed):
		return
	if renderer == null or _scenario == null:
		return
	var me := e as InputEventMouseButton
	var pos := me.position
	if not renderer.is_inside_terrain(pos):
		print("Outside terrain:", pos)
		return
	var terrain_pos := renderer.map_to_terrain(pos)

	if me.button_index == MOUSE_BUTTON_LEFT:
		_move_su_to(_su_a, terrain_pos)
	elif me.button_index == MOUSE_BUTTON_RIGHT:
		_move_su_to(_su_b, terrain_pos)
```
