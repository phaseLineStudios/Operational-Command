# AmmoTest::_on_move_near Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 175–181)</br>
*Belongs to:* [AmmoTest](../../AmmoTest.md)

**Signature**

```gdscript
func _on_move_near() -> void
```

## Source

```gdscript
func _on_move_near() -> void:
	_pos_logi = Vector3(10, 0, 0)  # inside radius
	ammo.set_unit_position(logi.id, _pos_logi)
	_print("[MOVE] %s moved near %s" % [logi.id, shooter.id])
	_update_link_status()
```
