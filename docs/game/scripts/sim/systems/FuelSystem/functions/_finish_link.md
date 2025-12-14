# FuelSystem::_finish_link Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 398–406)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _finish_link(dst_id: String) -> void
```

## Source

```gdscript
func _finish_link(dst_id: String) -> void:
	## Finish and signal the end of a refuel link.
	var src_id: String = _active_links.get(dst_id, "")
	if src_id != "":
		emit_signal("refuel_completed", src_id, dst_id)
	_active_links.erase(dst_id)
	_xfer_accum.erase(dst_id)
```
