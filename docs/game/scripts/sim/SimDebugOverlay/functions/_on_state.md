# SimDebugOverlay::_on_state Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 192–195)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _on_state(_prev, _next) -> void
```

## Description

Request redraw when mission state changes (e.g. RUNNING/PAUSED).

## Source

```gdscript
func _on_state(_prev, _next) -> void:
	queue_redraw()
```
