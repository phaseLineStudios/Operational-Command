# SimWorld::_on_order_failed Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 335–337)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _on_order_failed(_order: Dictionary, reason: String) -> void
```

## Description

Router callback: order failed.
[param _order] Order dictionary (unused).
[param reason] Failure reason.

## Source

```gdscript
func _on_order_failed(_order: Dictionary, reason: String) -> void:
	emit_signal("radio_message", "error", "Order failed (%s)." % reason)
	LogService.warning("radio_message: %s" % {"Order failed": reason}, "SimWorld.gd:299")
```
