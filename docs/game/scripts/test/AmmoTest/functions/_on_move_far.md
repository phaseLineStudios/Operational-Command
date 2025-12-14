# AmmoTest::_on_move_far Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 188–194)</br>
*Belongs to:* [AmmoTest](../../AmmoTest.md)

**Signature**

```gdscript
func _on_move_far() -> void
```

## Source

```gdscript
func _on_move_far() -> void:
	_pos_logi = Vector3(100, 0, 0)  # outside radius
	ammo.set_unit_position(logi.id, _pos_logi)
	_print("[MOVE] %s moved far from %s" % [logi.id, shooter.id])
	_update_link_status()
```
