# FuelTest::_on_toggle_move Function Reference

*Defined at:* `scripts/test/FuelTest.gd` (lines 278–283)</br>
*Belongs to:* [FuelTest](../../FuelTest.md)

**Signature**

```gdscript
func _on_toggle_move() -> void
```

## Source

```gdscript
func _on_toggle_move() -> void:
	move_enabled = !move_enabled
	if btn_move:
		btn_move.text = ("Stop Moving" if move_enabled else "Toggle Move")
```
