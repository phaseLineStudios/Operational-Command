# HQTable::_create_initial_unit_counters Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 426–443)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _create_initial_unit_counters(playable_units: Array[ScenarioUnit]) -> void
```

## Source

```gdscript
func _create_initial_unit_counters(playable_units: Array[ScenarioUnit]) -> void:
	for unit in playable_units:
		var counter := preload("res://scenes/system/unit_counter.tscn").instantiate()

		counter.setup(
			MilSymbol.UnitAffiliation.FRIEND, unit.unit.type, unit.unit.size, unit.callsign
		)
		%PhysicsObjects.add_child(counter)

		var world_pos: Variant = _terrain_pos_to_world(unit.position_m)
		if world_pos != null:
			counter.global_position = world_pos + Vector3(0, 0.25, 0)
		else:
			counter.global_position = %CounterSpawnLocation.global_position

		await counter.texture_ready
```
