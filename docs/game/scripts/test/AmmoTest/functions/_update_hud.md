# AmmoTest::_update_hud Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 201–208)</br>
*Belongs to:* [AmmoTest](../../AmmoTest.md)

**Signature**

```gdscript
func _update_hud() -> void
```

## Source

```gdscript
func _update_hud() -> void:
	var scur := int(shooter.state_ammunition.get(AMMO_TYPE, 0))
	var scap := int(shooter.ammunition.get(AMMO_TYPE, 0))
	var stock := int(logi.throughput.get(AMMO_TYPE, 0))
	_lbl_shooter.text = "Shooter %s: %d/%d" % [shooter.id, scur, scap]
	_lbl_logi.text = "Logi %s stock(%s): %d" % [logi.id, AMMO_TYPE, stock]
```
