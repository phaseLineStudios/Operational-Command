# PoolDropArea::_drop_data Function Reference

*Defined at:* `scripts/ui/helpers/PoolDropArea.gd` (lines 18–23)</br>
*Belongs to:* [PoolDropArea](../../PoolDropArea.md)

**Signature**

```gdscript
func _drop_data(_at_position: Vector2, data: Variant) -> void
```

## Source

```gdscript
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if not _can_drop_data(_at_position, data):
		return
	var unit: Dictionary = data.get("unit", {})
	var slot_id := String(data.get("slot_id", ""))
	emit_signal("request_return_to_pool", slot_id, unit)
```
