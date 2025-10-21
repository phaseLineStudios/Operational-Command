# FuelSystem::_refuel_tick Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 393–442)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _refuel_tick(delta: float) -> void
```

## Source

```gdscript
func _refuel_tick(delta: float) -> void:
	## Create links where needed, then transfer fuel over time while in range.
	for key in _su.keys():
		var dst_id: String = key as String
		if _active_links.has(dst_id):
			continue
		var dst: ScenarioUnit = _su[dst_id] as ScenarioUnit
		if dst == null or not _needs_fuel(dst):
			continue
		var src_id: String = _pick_link_for(dst)
		if src_id != "":
			_begin_link(src_id, dst_id)

	for key2 in _active_links.keys().duplicate():
		var dst_id2: String = key2 as String
		var src_id2: String = _active_links[dst_id2]
		var src: ScenarioUnit = _su.get(src_id2) as ScenarioUnit
		var dst2: ScenarioUnit = _su.get(dst_id2) as ScenarioUnit
		if src == null or dst2 == null:
			_finish_link(dst_id2)
			continue
		if not _within_radius(src, dst2):
			_finish_link(dst_id2)
			continue

		var rate: float = max(0.0, src.unit.supply_transfer_rate)
		var budget: float = rate * max(delta, 0.0) + float(_xfer_accum.get(dst_id2, 0.0))

		var st_dst: UnitFuelState = _fuel.get(dst_id2) as UnitFuelState
		if st_dst == null:
			_finish_link(dst_id2)
			continue

		var cap: float = st_dst.fuel_capacity
		var cur: float = st_dst.state_fuel
		var need: float = max(0.0, cap - cur)
		var stock: float = float(int(src.unit.throughput.get("fuel", 0)))

		var transferred: float = min(need, min(stock, budget))
		if transferred > 0.0:
			st_dst.state_fuel = min(cap, cur + transferred)
			src.unit.throughput["fuel"] = int(stock - transferred)
			_xfer_accum[dst_id2] = budget - transferred
		else:
			_xfer_accum[dst_id2] = budget

		if not _needs_fuel(dst2) or not _has_stock(src):
			_finish_link(dst_id2)
```
