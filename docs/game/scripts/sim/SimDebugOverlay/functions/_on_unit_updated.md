# SimDebugOverlay::_on_unit_updated Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 189–192)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _on_unit_updated(_id: String, _snap: Dictionary) -> void
```

## Description

Request redraw when a unit snapshot updates.

## Source

```gdscript
func _on_unit_updated(_id: String, _snap: Dictionary) -> void:
	queue_redraw()
```
