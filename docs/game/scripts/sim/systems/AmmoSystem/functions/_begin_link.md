# AmmoSystem::_begin_link Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 199–204)</br>
*Belongs to:* [AmmoSystem](../AmmoSystem.md)

**Signature**

```gdscript
func _begin_link(src_id: String, dst_id: String) -> void
```

## Description

Begin a resupply link from `src_id` to `dst_id`.

## Source

```gdscript
func _begin_link(src_id: String, dst_id: String) -> void:
	_active_links[dst_id] = src_id
	_xfer_accum[dst_id] = 0.0
	emit_signal("resupply_started", src_id, dst_id)
```
