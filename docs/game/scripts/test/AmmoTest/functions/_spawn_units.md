# AmmoTest::_spawn_units Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 117–149)</br>
*Belongs to:* [AmmoTest](../../AmmoTest.md)

**Signature**

```gdscript
func _spawn_units() -> void
```

## Source

```gdscript
func _spawn_units() -> void:
	# Shooter
	var shooter_data := UnitData.new()
	shooter_data.id = "alpha"
	shooter_data.title = "Alpha"
	shooter_data.ammunition = {AMMO_TYPE: _init_shooter_cap}
	shooter = ScenarioUnit.new()
	shooter.id = "alpha"
	shooter.unit = shooter_data
	shooter.state_ammunition = {AMMO_TYPE: _init_shooter_cap}

	# Logistics unit
	var logi_data := UnitData.new()
	logi_data.id = "logi1"
	logi_data.title = "Logistics Truck"
	logi_data.throughput = {AMMO_TYPE: _init_logi_stock}
	logi_data.supply_transfer_rate = _rate
	logi_data.supply_transfer_radius_m = _radius
	logi_data.equipment_tags = ["LOGISTICS"]
	logi = ScenarioUnit.new()
	logi.id = "logi1"
	logi.unit = logi_data

	ammo.register_unit(shooter)
	ammo.register_unit(logi)

	_pos_shooter = Vector3(0, 0, 0)
	_pos_logi = Vector3(100, 0, 0)  # start out of range

	ammo.set_unit_position(shooter.id, _pos_shooter)
	ammo.set_unit_position(logi.id, _pos_logi)
```
