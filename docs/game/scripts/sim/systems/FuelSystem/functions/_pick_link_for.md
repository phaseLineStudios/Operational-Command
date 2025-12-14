# FuelSystem::_pick_link_for Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 363–390)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _pick_link_for(dst: ScenarioUnit) -> String
```

## Source

```gdscript
func _pick_link_for(dst: ScenarioUnit) -> String:
	## Choose the nearest eligible tanker for a destination unit. Returns the src unit_id or "".
	var best_src: String = ""
	var best_d: float = INF
	for key in _su.keys():
		var id: String = key as String
		var src: ScenarioUnit = _su[id] as ScenarioUnit
		if src == null or src.id == dst.id:
			continue
		# Don't use dead units as suppliers
		if src.state_strength <= 0:
			continue
		# Only use stationary units as suppliers
		if src.move_state() != ScenarioUnit.MoveState.IDLE:
			continue
		if not _is_tanker(src.unit):
			continue
		if not _within_radius(src, dst):
			continue
		if not _has_stock(src):
			continue
		var d: float = src.position_m.distance_to(dst.position_m)
		if d < best_d:
			best_d = d
			best_src = src.id
	return best_src
```
