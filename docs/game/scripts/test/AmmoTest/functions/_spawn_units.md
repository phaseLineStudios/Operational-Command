# AmmoTest::_spawn_units Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 117–143)</br>
*Belongs to:* [AmmoTest](../../AmmoTest.md)

**Signature**

```gdscript
func _spawn_units() -> void
```

## Source

```gdscript
func _spawn_units() -> void:
	# Shooter
	shooter = UnitData.new()
	shooter.id = "alpha"
	shooter.title = "Alpha"
	shooter.ammunition = {AMMO_TYPE: _init_shooter_cap}
	shooter.state_ammunition = {AMMO_TYPE: _init_shooter_cap}

	# Logistics unit
	logi = UnitData.new()
	logi.id = "logi1"
	logi.title = "Logistics Truck"
	logi.throughput = {AMMO_TYPE: _init_logi_stock}
	logi.supply_transfer_rate = _rate
	logi.supply_transfer_radius_m = _radius
	logi.equipment_tags = ["LOGISTICS"]

	ammo.register_unit(shooter)
	ammo.register_unit(logi)

	_pos_shooter = Vector3(0, 0, 0)
	_pos_logi = Vector3(100, 0, 0)  # start out of range

	ammo.set_unit_position(shooter.id, _pos_shooter)
	ammo.set_unit_position(logi.id, _pos_logi)
```
