# AmmoSystem::_transfer_tick Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 242–299)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func _transfer_tick(delta: float) -> void
```

## Description

Transfer rounds for all active links using a fractional-rate accumulator so
low rates still work at high frame rates (e.g., 20 rps @ 60 FPS).

## Source

```gdscript
func _transfer_tick(delta: float) -> void:
	for dst_id in _active_links.keys().duplicate():
		var src: ScenarioUnit = _units.get(_active_links[dst_id]) as ScenarioUnit
		var dst: ScenarioUnit = _units.get(dst_id) as ScenarioUnit
		if src == null or dst == null:
			_finish_link(dst_id)
			continue
		# Break link if either unit moves
		if (
			src.move_state() != ScenarioUnit.MoveState.IDLE
			or dst.move_state() != ScenarioUnit.MoveState.IDLE
		):
			_finish_link(dst_id)
			continue
		if not _within_radius(src, dst) or not _has_stock(src):
			_finish_link(dst_id)
			continue

		var acc: float = float(_xfer_accum.get(dst_id, 0.0))
		acc += max(0.0, src.unit.supply_transfer_rate) * delta
		var transferable: int = int(floor(acc))
		if transferable <= 0:
			_xfer_accum[dst_id] = acc
			continue

		var remaining: int = transferable
		var transferred: int = 0

		for t in dst.unit.ammunition.keys():
			if remaining <= 0:
				break
			var cap: int = int(dst.unit.ammunition[t])
			var cur: int = int(dst.state_ammunition.get(t, 0))
			if cur >= cap:
				continue
			var need: int = cap - cur
			var stock: int = int(src.unit.throughput.get(t, 0))
			if stock <= 0:
				continue

			var xfer: int = min(need, min(stock, remaining))
			if xfer <= 0:
				continue

			dst.state_ammunition[t] = cur + xfer
			src.unit.throughput[t] = stock - xfer
			remaining -= xfer
			transferred += xfer

		_xfer_accum[dst_id] = acc - float(transferred)

		var out_of_stock := not _has_stock(src)
		if not _needs_ammo(dst) or out_of_stock:
			if out_of_stock:
				emit_signal("supplier_exhausted", _active_links[dst_id])
			_finish_link(dst_id)
```
