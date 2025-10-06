# AmmoTest::_wire_ui Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 144–155)</br>
*Belongs to:* [AmmoTest](../AmmoTest.md)

**Signature**

```gdscript
func _wire_ui() -> void
```

## Source

```gdscript
func _wire_ui() -> void:
	_btn_fire.pressed.connect(_on_fire_once)
	_btn_auto.pressed.connect(_on_toggle_auto)
	_btn_near.pressed.connect(_on_move_near)
	_btn_far.pressed.connect(_on_move_far)
	_btn_reset.pressed.connect(_on_reset)
	_fire_timer.timeout.connect(_on_fire_once)
	_fire_timer.wait_time = 0.7
	_fire_timer.one_shot = false
	_fire_timer.stop()
```
