# AmmoTest::_on_reset Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 189–197)</br>
*Belongs to:* [AmmoTest](../../AmmoTest.md)

**Signature**

```gdscript
func _on_reset() -> void
```

## Source

```gdscript
func _on_reset() -> void:
	shooter.ammunition[AMMO_TYPE] = _init_shooter_cap
	shooter.state_ammunition[AMMO_TYPE] = _init_shooter_cap
	logi.throughput[AMMO_TYPE] = _init_logi_stock
	_print("[RESET] ammo and stock restored")
	_update_hud()
	_update_link_status()
```
