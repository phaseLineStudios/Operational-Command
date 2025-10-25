# SimDebugOverlay::_on_resized Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 127–131)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _on_resized() -> void
```

## Description

Recompute transforms when map or base resizes.

## Source

```gdscript
func _on_resized() -> void:
	_compute_map_transform()
	queue_redraw()
```
