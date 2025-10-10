# SimDebugOverlay::_on_order_applied Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 152–159)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _on_order_applied(order: Dictionary) -> void
```

- **order**: Order dictionary that was applied.

## Description

Record the last applied order per unit for label display.

## Source

```gdscript
func _on_order_applied(order: Dictionary) -> void:
	var uid := str(order.get("unit_id", ""))
	var typ := str(order.get("type", "")).to_upper()
	if uid != "":
		_last_order[uid] = typ
	queue_redraw()
```
