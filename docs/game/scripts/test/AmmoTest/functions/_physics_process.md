# AmmoTest::_physics_process Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 100–106)</br>
*Belongs to:* [AmmoTest](../../AmmoTest.md)

**Signature**

```gdscript
func _physics_process(delta: float) -> void
```

## Source

```gdscript
func _physics_process(delta: float) -> void:
	# Harmless even if AmmoSystem also ticks internally.
	ammo.tick(delta)
	_update_link_status()
	_update_hud()  # keep labels live while resupplying
```
