# AmmoTest::_on_toggle_auto Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 166–174)</br>
*Belongs to:* [AmmoTest](../../AmmoTest.md)

**Signature**

```gdscript
func _on_toggle_auto() -> void
```

## Source

```gdscript
func _on_toggle_auto() -> void:
	if _fire_timer.is_stopped():
		_fire_timer.start()
		_btn_auto.text = "Auto Fire: ON"
	else:
		_fire_timer.stop()
		_btn_auto.text = "Auto Fire"
```
