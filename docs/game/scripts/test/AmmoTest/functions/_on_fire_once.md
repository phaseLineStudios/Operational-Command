# AmmoTest::_on_fire_once Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 165–171)</br>
*Belongs to:* [AmmoTest](../../AmmoTest.md)

**Signature**

```gdscript
func _on_fire_once() -> void
```

## Source

```gdscript
func _on_fire_once() -> void:
	var ok := adapter.request_fire(shooter.id, AMMO_TYPE, BURST)
	if ok:
		_print("[FIRE] %s -> %s (%d rounds)" % [shooter.id, AMMO_TYPE, BURST])
	_update_hud()
```
