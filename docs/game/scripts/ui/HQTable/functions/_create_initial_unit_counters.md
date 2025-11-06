# HQTable::_create_initial_unit_counters Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 296–315)</br>
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
		counter.affiliation = UnitCounter.CounterAffiliation.PLAYER
		counter.callsign = unit.callsign
		counter.symbol_type = unit.unit.type
		counter.symbol_size = unit.unit.size

		%PhysicsObjects.add_child(counter)

		# Convert unit terrain position to 3D world position
		var world_pos: Variant = _terrain_pos_to_world(unit.position_m)
		if world_pos != null:
			# Place counter slightly above the map surface
			counter.global_position = world_pos + Vector3(0, 0.05, 0)
		else:
			# Fallback to spawn location if conversion fails
			counter.global_position = %CounterSpawnLocation.global_position
```
