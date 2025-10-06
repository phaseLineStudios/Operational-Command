# AmmoSystem::_finish_link Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 206–213)</br>
*Belongs to:* [AmmoSystem](../AmmoSystem.md)

**Signature**

```gdscript
func _finish_link(dst_id: String) -> void
```

## Description

Finish an active resupply link for `dst_id`.

## Source

```gdscript
func _finish_link(dst_id: String) -> void:
	var src_id: String = _active_links.get(dst_id, "")
	if src_id != "":
		emit_signal("resupply_completed", src_id, dst_id)
	_active_links.erase(dst_id)
	_xfer_accum.erase(dst_id)
```
