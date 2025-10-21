# FuelSystem::unregister_unit Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 73–86)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func unregister_unit(unit_id: String) -> void
```

## Source

```gdscript
func unregister_unit(unit_id: String) -> void:
	## Unregister a unit and drop any active refuel links.
	_su.erase(unit_id)
	_fuel.erase(unit_id)
	_pos.erase(unit_id)
	_prev.erase(unit_id)
	_immobilized.erase(unit_id)
	_xfer_accum.erase(unit_id)
	for dst_key in _active_links.keys().duplicate():
		var dst: String = dst_key as String
		if _active_links[dst] == unit_id or dst == unit_id:
			_active_links.erase(dst)
```
