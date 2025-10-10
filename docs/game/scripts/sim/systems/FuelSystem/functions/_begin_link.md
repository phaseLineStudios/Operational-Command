# FuelSystem::_begin_link Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 377–383)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _begin_link(src_id: String, dst_id: String) -> void
```

## Source

```gdscript
func _begin_link(src_id: String, dst_id: String) -> void:
	## Start a refuel link.
	_active_links[dst_id] = src_id
	_xfer_accum[dst_id] = 0.0
	emit_signal("refuel_started", src_id, dst_id)
```
