# OrdersRouter::_apply_custom Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 310–315)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _apply_custom(_unit: ScenarioUnit, order: Dictionary) -> bool
```

- **_unit**: Subject unit (unused, but kept for consistency).
- **order**: Custom order dictionary with custom_keyword and custom_metadata.
- **Return Value**: Always returns `true` (order is "accepted" but deferred to signal handlers).

## Description

CUSTOM: Emit signal for mission-specific handling. Does not apply standard routing.
Emits `signal custom_order_received` with full order dictionary for external handling.
  
  

**Order dictionary contains:**
  
- `custom_keyword: String`
  
- `custom_full_text: String`
  
- `custom_metadata: Dictionary`
  
- `raw: PackedStringArray`

## Source

```gdscript
func _apply_custom(_unit: ScenarioUnit, order: Dictionary) -> bool:
	emit_signal("custom_order_received", order)
	emit_signal("order_applied", order)
	return true
```

## References

- [`signal custom_order_received`](../../OrdersRouter.md#custom_order_received)
