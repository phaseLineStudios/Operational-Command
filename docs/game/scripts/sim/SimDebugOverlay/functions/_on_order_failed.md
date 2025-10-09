# SimDebugOverlay::_on_order_failed Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 163–170)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _on_order_failed(order: Dictionary, _reason: String) -> void
```

## Description

Record failed order attempts (marked ✖) to aid debugging.
[param order] Order dictionary that failed.
[param _reason] Failure reason (unused here).

## Source

```gdscript
func _on_order_failed(order: Dictionary, _reason: String) -> void:
	var uid := str(order.get("unit_id", ""))
	var typ := str(order.get("type", "")).to_upper() + " ✖"
	if uid != "":
		_last_order[uid] = typ
	queue_redraw()
```
