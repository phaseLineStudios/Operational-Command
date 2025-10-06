# AmmoSystem::unregister_unit Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 50–59)</br>
*Belongs to:* [AmmoSystem](../AmmoSystem.md)

**Signature**

```gdscript
func unregister_unit(unit_id: String) -> void
```

## Description

Stop tracking a unit and tear down any active resupply links.

## Source

```gdscript
func unregister_unit(unit_id: String) -> void:
	_units.erase(unit_id)
	_positions.erase(unit_id)
	_logi.erase(unit_id)
	for dst in _active_links.keys().duplicate():
		if _active_links[dst] == unit_id or dst == unit_id:
			_active_links.erase(dst)
	_xfer_accum.erase(unit_id)
```
