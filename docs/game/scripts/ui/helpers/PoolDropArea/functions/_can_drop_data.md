# PoolDropArea::_can_drop_data Function Reference

*Defined at:* `scripts/ui/helpers/PoolDropArea.gd` (lines 12–17)</br>
*Belongs to:* [PoolDropArea](../PoolDropArea.md)

**Signature**

```gdscript
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool
```

## Source

```gdscript
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if typeof(data) != TYPE_DICTIONARY:
		return false
	return String(data.get("type", "")) == "assigned_unit"
```
